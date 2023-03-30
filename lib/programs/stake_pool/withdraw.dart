/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:math' as math;
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import '../../constants.dart';
import '../../exceptions/exception.dart';
import '../../programs/stake_pool/update.dart';
import '../../programs/stake_pool/utils.dart';
import 'models.dart';


/// Withdraw
/// ------------------------------------------------------------------------------------------------

Future<List<TransactionWithSigners>> withdraw({
  required final SolanaWalletProvider provider,
  required final BigInt amount,
}) async {

  // The JSON RPC connection.
  final Connection connection = provider.connection;

  // Get the user account connected to the app.
  final Account? connectedAccount = provider.connectedAccount;

  // Check that the user account has been authorized by the app.
  if (connectedAccount == null) {
    throw const SPDException('No wallet connected.');
  }

  // Get the user account public key address.
  final PublicKey wallet = PublicKey.fromBase64(connectedAccount.address);

  // Fetch the stake pool's account data.
  final StakePool stakePool = await getStakePool(connection, stakePoolAddress);
  final PublicKey mintAccount = PublicKey.fromBase58(stakePool.poolMint);
  final PublicKey validatorListAccount = PublicKey.fromBase58(stakePool.validatorList);
  final PublicKey reserveAccount = PublicKey.fromBase58(stakePool.reserveStake);
  final PublicKey managerFeeAccount = PublicKey.fromBase58(stakePool.managerFeeAccount);

  /// Fetch the stake pool's validator list.
  final ValidatorList validatorList = await getValidatorList(connection, validatorListAccount);

  /// Check that the pool contains at least one validator.
  if (validatorList.validators.isEmpty) {
    throw const SPDException('No validators found, please try again soon.');
  }

  // Get the stake pool's withdraw address.
  final PublicKey withdrawAccount = StakePoolProgram.findWithdrawAuthorityProgramAddress(
    stakePoolAddress,
  ).publicKey;

  // Get the user's stake pool token address.
  final PublicKey tokenAccount = PublicKey.findAssociatedTokenAddress(
    wallet, 
    mintAccount,
  ).publicKey;

  // Fetch the user's token account info.
  final TokenAccountInfo? tokenAccountInfo = await getTokenAccountInfo(
    connection, 
    tokenAccount, 
    mintAccount,
  );

  // Check that the token account exists.
  if (tokenAccountInfo == null) {
    throw SPDException('The token account $tokenAccount does not exist.');
  }

  // Check that the user's account contains enough tokens for the withdrawal [amount].
  if (tokenAccountInfo.amount < amount) {
    throw SPDException('Insufficient balance for withdrawal amount ${lamportsToSol(amount)}.');
  }

  // Fetch the reserve stake account info.
  final ReserveStakeBalance reserveStakeBalance = await getReserveStakeBalance(
    connection, 
    address: reserveAccount,
  );

  // Transactions.
  late final List<TransactionWithSigners> transactions;

  final int availableReserveBalance = reserveStakeBalance.availableBalance;
  if (amount < availableReserveBalance.toBigInt()) {
    transactions = [
      TransactionWithSigners(
        transaction: Transaction(
          instructions: [
            StakePoolProgram.withdrawSol(
              stakePoolAddress: stakePoolAddress, 
              withdrawAuthority: withdrawAccount, 
              userTransferAuthority: wallet, 
              userTokenAccount: tokenAccount, 
              reserveStake: reserveAccount, 
              receiverAccount: wallet, 
              receiverTokenAccount: managerFeeAccount, 
              poolMint: mintAccount, 
              lamports: amount,
            ),
          ],
        ),
      ),
    ];
  } else {
    transactions = await _withdrawStake(
      wallet: wallet,
      connection: connection, 
      stakePool: stakePool,
      validatorList: validatorList, 
      validatorListAccount: validatorListAccount,
      withdrawAccount: withdrawAccount,
      tokenAccount: tokenAccount,
      managerFeeAccount: managerFeeAccount,
      mintAccount: mintAccount,
      reserveStakeBalance: reserveStakeBalance,
      lamports: amount,
    );
  }

  await updateStakePoolRemote(connection, stakePool: stakePool);

  return transactions;
}


/// Withdraw Stake
/// ------------------------------------------------------------------------------------------------

Future<List<TransactionWithSigners>> _withdrawStake({
  required final PublicKey wallet,
  required final Connection connection,
  required final StakePool stakePool,
  required final ValidatorList validatorList,
  required final PublicKey validatorListAccount,
  required final PublicKey withdrawAccount,
  required final PublicKey tokenAccount,  
  required final PublicKey managerFeeAccount, 
  required final PublicKey mintAccount, 
  required final ReserveStakeBalance reserveStakeBalance,
  required final BigInt lamports,
}) async {

  // Minimum balance required for a stake account.
  final int minBalance = reserveStakeBalance.minBalanceForRentExemption 
    + StakePoolProgram.minimumActiveStake;

  final List<WithdrawAccount> accounts = _withdrawAccounts(
    stakePool: stakePool,
    validatorList: validatorList, 
    amount: lamports,
    minStakeBalance: minBalance.toBigInt(),
    reserveStakeBalance: reserveStakeBalance,
  );

  // final userTransferAuthority = Keypair.generateSync();

  // instructions.add(
  //   TokenProgram.approve(
  //     source: tokenAccount,
  //     delegate: userTransferAuthority.publicKey,
  //     owner: wallet,
  //     amount: amount,
  //   ),
  // );


  final List<TransactionWithSigners> transactions = [];
  List<TransactionInstruction> instructions = [];
  List<Signer> signers = [];
  // Max 5 accounts per transaction to prevent error: "Transaction too large"
  final int maxWithdrawAccounts = math.min(5, accounts.length);
  for (int i = 0; i < accounts.length; ++i) {
    final WithdrawAccount account = accounts[i];
    print('ACCOUNT TYPE   ${account.type}');
    print('ACCOUNT ADDRES ${account.stakeAddress}');
    print('ACCOUNT AMOUNT ${account.amount}');
    print('ACCOUNT INDEX  ${instructions.length}');
    final Keypair stakeAccountKeypair = Keypair.generateSync();
    signers.add(stakeAccountKeypair);

    instructions.add(
      SystemProgram.createAccount(
        fromPublicKey: wallet,
        newAccountPublicKey: stakeAccountKeypair.publicKey,
        lamports: reserveStakeBalance.minBalanceForRentExemption.toBigInt(),
        space: StakeProgram.space.toBigInt(),
        programId: StakeProgram.programId,
      ),
    );

    instructions.add(
      StakePoolProgram.withdrawStake(
        stakePoolAddress: stakePoolAddress, 
        validatorList: validatorListAccount, 
        withdrawAuthority: withdrawAccount, 
        validatorOrReserveStakeAccount: account.stakeAddress, 
        unitializedStakeAccount: stakeAccountKeypair.publicKey, 
        userWithdrawAuthority: wallet, 
        userTransferAuthority: wallet, //userTransferAuthority.publicKey, 
        userTokenAccount: tokenAccount, 
        managerFeeAccount: managerFeeAccount, 
        poolMint: mintAccount, 
        lamports: account.amount,
      ),
    );
    print('ADD C0 = ${signers.length % maxWithdrawAccounts}');
    print('ADD C1 = ${(i+1) == accounts.length}');
    if ((signers.length % maxWithdrawAccounts) == 0 || (i+1) == accounts.length) {
      transactions.add(
        TransactionWithSigners(
          transaction: Transaction(
            instructions: instructions,
          ),
          signers: signers,
        ),
      );
      signers = [];
      instructions = [];
    }
  }

  return transactions;
}


/// Withdraw Accounts
/// ------------------------------------------------------------------------------------------------

List<WithdrawAccount> _withdrawAccounts({
  required final StakePool stakePool,
  required final ValidatorList validatorList,
  required final BigInt amount,
  required final BigInt minStakeBalance,
  required final ReserveStakeBalance reserveStakeBalance,
}) {
  // Active stake accounts with sufficient balance.
  final List<WithdrawAccount> accounts = [];

  // Collect active stake accounts with sufficient balance.
  for (final ValidatorStakeInfo validator in validatorList.validators) {
    
    // Active validators only.
    if (validator.status != StakeStatus.active) continue;

    // Validator vote account.
    final PublicKey voteAccountAddress = PublicKey.fromBase58(validator.voteAccountAddress);

    // Active balance.
    if (validator.activeStakeLamports > BigInt.zero) {
      final bool isPreferred = (
        stakePool.preferredWithdrawValidatorVoteAddress == validator.voteAccountAddress
      );
      final ProgramAddress stakeAccountAddress = StakePoolProgram.findStakeProgramAddress(
        voteAccountAddress, 
        stakePoolAddress,
      );
      accounts.add(
        WithdrawAccount(
          type: isPreferred 
            ? WithdrawAccountType.preferred 
            : WithdrawAccountType.active, 
          stakeAddress: stakeAccountAddress.publicKey, 
          voteAddress: voteAccountAddress,
          amount: validator.activeStakeLamports,
        )
      );
    }

    // Transient balance.
    final BigInt transientStakeLamports = validator.transientStakeLamports - minStakeBalance;
    if (transientStakeLamports > BigInt.zero) {
      final transientStakeAccountAddress = StakePoolProgram.findTransientStakeProgramAddress(
        voteAccountAddress,
        stakePoolAddress,
        validator.transientSeedSuffix,
      );
      accounts.add(
        WithdrawAccount(
          type: WithdrawAccountType.transient, 
          stakeAddress: transientStakeAccountAddress.publicKey, 
          voteAddress: voteAccountAddress,
          amount: transientStakeLamports,
        )
      );
    }
  }

  // Sort by type and then balance.
  accounts.sort((a, b) {
    final int compare = a.type.index - b.type.index;
    return compare == 0 ? (b.amount - a.amount).toInt() : compare;
  });

  // Add reserve account.
  if (reserveStakeBalance.availableBalance > 0) {
    accounts.add(
      WithdrawAccount(
        type: WithdrawAccountType.reserved, 
        stakeAddress: PublicKey.fromBase58(stakePool.reserveStake), 
        amount: reserveStakeBalance.availableBalance.toBigInt(),
      ),
    );
  }

  print('\n');
  print('WITHDRAW ACCOUNTS');
  print(accounts.map((e) {
    print('\n');
    print('\tType:      ${e.type}');
    print('\tAmount:    ${e.amount}');
    print('\tStake:     ${e.stakeAddress}');
    print('\tVote:      ${e.voteAddress}');
  print('\n');
  }));
  print('\n');

  // Withdrawal accounts.
  BigInt remainingAmount = amount;
  final List<WithdrawAccount> withdrawalAccounts = [];

  // Fee applied to each withdrawal.
  final Fee fee = stakePool.stakeWithdrawalFee;
  final Fee inverseFee = Fee(
    denominator: fee.denominator, 
    numerator: fee.denominator - fee.numerator,
  );

  print('\nWITHDRAWAL AMOUNT $amount\n');

  for (final WithdrawAccount account in accounts) {
    
    BigInt availableForWithdrawal = calcPoolTokensForDeposit(
      stakePool: stakePool, 
      stakeLamports: account.amount,
    );

    print('-\tAVAILABLE FOR WITHDRAWAL $availableForWithdrawal');

    if (inverseFee.numerator != BigInt.zero) {
      availableForWithdrawal = BigInt.from(
        (availableForWithdrawal * inverseFee.denominator) / inverseFee.numerator
      );
    }

    print('-\tFEE NUMERATOR ${inverseFee.numerator}');
    print('-\tFEE DENOMINATOR ${inverseFee.denominator}');

    final BigInt withdrawalAmount = minBigInt(availableForWithdrawal, remainingAmount);
    if (withdrawalAmount <= BigInt.zero) {
      print('\n');
      continue;
    }

    print('-\tACCOUNT TO DEBIT TYPE ${account.type}');
    print('-\tACCOUNT TO DEBIT STKE ${account.stakeAddress}');
    print('-\tACCOUNT TO DEBIT VOTE ${account.voteAddress}');

    print('-\tACCOUNT WITHDRAW AMOUNT DENOMINATOR ${withdrawalAmount}');

    withdrawalAccounts.add(account.copyWithAmount(withdrawalAmount));
    remainingAmount -= withdrawalAmount;

    print('-\tREMAINING BALANCE ${remainingAmount}\n');

    if (remainingAmount <= BigInt.zero) {
      break;
    }
  }

  if (remainingAmount != BigInt.zero) {
    throw const SPDException('Insufficient validator balances to perform withdrawal.');
  }

  return withdrawalAccounts;
}