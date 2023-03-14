/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:math' as math;
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import '../../constants.dart';
import '../../exceptions/exception.dart';
import '../../programs/stake_pool/utils.dart';


/// Withdraw Account Type
/// ------------------------------------------------------------------------------------------------

enum WithdrawAccountType {
  preferred,
  active,
  transient,
  reserved,
}


/// Withdraw Account
/// ------------------------------------------------------------------------------------------------

class WithdrawAccount {

  const WithdrawAccount({
    required this.type,
    required this.stakeAddress,
    this.voteAddress,
    required this.amount,
  });

  final WithdrawAccountType type;
  final PublicKey stakeAddress;
  final PublicKey? voteAddress;
  final BigInt amount;

  WithdrawAccount copyWithAmount(final BigInt amount) => WithdrawAccount(
    type: type, 
    stakeAddress: stakeAddress,
    voteAddress: voteAddress, 
    amount: amount,
  );
}


/// Withdraw
/// ------------------------------------------------------------------------------------------------

Future<InstructionData> withdraw({
  required final SolanaWalletProvider provider,
  required final Connection connection,
  required final PublicKey wallet,
  required final StakePool stakePool,
  required final ValidatorList validatorList,
  required final PublicKey tokenAccount,
  required final PublicKey withdrawAccount,
  required final BigInt amount,
}) async {

  // Map base-58 public keys.
  final PublicKey reserveStake = PublicKey.fromBase58(stakePool.reserveStake);
  final PublicKey poolMint = PublicKey.fromBase58(stakePool.poolMint);

  // The JSON RPC connection.
  final Connection connection = provider.connection;

  // Fetch the user's `stake pool lotto` token account info.
  final TokenAccountInfo? tokenAccountInfo = await getTokenAccountInfo(
    connection, 
    tokenAccount, 
    poolMint,
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
  final int reserveStakeBalance = await connection.getBalance(reserveStake);

  /// Fetch the rent exemption amount for a (validator) stake account.
  final int minBalanceForRentExemption = await connection.getMinimumBalanceForRentExemption(
    StakeProgram.space,
  );

  final int availableReserveBalance = reserveStakeBalance - minBalanceForRentExemption - 1 - solToLamports(100).toInt();
  return  amount < availableReserveBalance.toBigInt()
    ? withdrawSol(
        wallet: wallet, 
        amount: amount, 
        stakePool: stakePool,
        tokenAccount: tokenAccount,
        withdrawAccount: withdrawAccount,
      )
    : await withdrawStake(
        wallet: wallet,
        connection: connection, 
        amount: amount, 
        stakePool: stakePool,
        validatorList: validatorList, 
        tokenAccount: tokenAccount,
        withdrawAccount: withdrawAccount,
        reserveStakeAvailableBalance: availableReserveBalance,
        minBalanceForRentExemption: minBalanceForRentExemption,
      );
}


/// Withdraw Stake
/// ------------------------------------------------------------------------------------------------

InstructionData withdrawSol({
  required final PublicKey wallet,
  required final BigInt amount,
  required final StakePool stakePool,
  required final PublicKey tokenAccount, 
  required final PublicKey withdrawAccount, 
}) {
  final List<TransactionInstruction> instructions = [];

  final PublicKey reserveStake = PublicKey.fromBase58(stakePool.reserveStake);
  final PublicKey managerFeeAccount = PublicKey.fromBase58(stakePool.managerFeeAccount);
  final PublicKey poolMint = PublicKey.fromBase58(stakePool.poolMint);

  instructions.add(
    StakePoolProgram.withdrawSol(
      stakePoolAddress: stakePoolAddress, 
      withdrawAuthority: withdrawAccount, 
      userTransferAuthority: wallet, 
      userTokenAccount: tokenAccount, 
      reserveStake: reserveStake, 
      receiverAccount: wallet, 
      receiverTokenAccount: managerFeeAccount, 
      poolMint: poolMint, 
      lamports: amount,
    )
  );

  return InstructionData(
    instructions: instructions,
  );
}


/// Withdraw Stake
/// ------------------------------------------------------------------------------------------------

Future<InstructionData> withdrawStake({
  required final PublicKey wallet,
  required final Connection connection,
  required final BigInt amount,
  required final StakePool stakePool,
  required final ValidatorList validatorList,
  required final PublicKey tokenAccount, 
  required final PublicKey withdrawAccount, 
  required final int reserveStakeAvailableBalance,
  required final int minBalanceForRentExemption,
}) async {
  final List<TransactionInstruction> instructions = [];

  // Map base-58 public key strings.
  final PublicKey poolValidatorList = PublicKey.fromBase58(stakePool.validatorList);
  final PublicKey poolManagerFeeAccount = PublicKey.fromBase58(stakePool.managerFeeAccount);
  final PublicKey poolMint = PublicKey.fromBase58(stakePool.poolMint);

  // Minimum balance required for a stake account.
  final int minBalance = minBalanceForRentExemption + StakePoolProgram.minimumActiveStake;

  final List<WithdrawAccount> accounts = withdrawAccounts(
    stakePool: stakePool,
    validatorList: validatorList, 
    amount: amount,
    minBalance: minBalance.toBigInt(),
    reserveStakeAvailableBalance: reserveStakeAvailableBalance,
  );

  // final userTransferAuthority = Keypair.generate();
  final List<Signer> signers = [];

  // instructions.add(
  //   TokenProgram.approve(
  //     source: tokenAccount,
  //     delegate: userTransferAuthority.publicKey,
  //     owner: wallet,
  //     amount: amount,
  //   ),
  // );

  final int minDelegation = await connection.getStakeMinimumDelegation();
  print('MIN DELEGATION         $minDelegation');
  print('MIN DELEGATION         ${lamportsToSol(minDelegation.toBigInt())} SOL');

  // Max 5 accounts to prevent an error: "Transaction too large"
  final int maxWithdrawAccounts = math.min(5, accounts.length);
  for (int i = 0; i < maxWithdrawAccounts; ++i) {
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
        lamports: minBalanceForRentExemption.toBigInt(),
        space: StakeProgram.space.toBigInt(),
        programId: StakeProgram.programId,
      ),
    );
    instructions.add(
      StakePoolProgram.withdrawStake(
        stakePoolAddress: stakePoolAddress, 
        validatorList: poolValidatorList, 
        withdrawAuthority: withdrawAccount, 
        validatorOrReserveStakeAccount: account.stakeAddress, 
        unitializedStakeAccount: stakeAccountKeypair.publicKey, 
        userWithdrawAuthority: wallet, 
        userTransferAuthority: wallet,// userTransferAuthority.publicKey, 
        userTokenAccount: tokenAccount, 
        managerFeeAccount: poolManagerFeeAccount, 
        poolMint: poolMint, 
        lamports: account.amount,
      ),
    );
  }

  return InstructionData(
    instructions: instructions,
    signers: signers,
  );
}


/// Withdraw Accounts
/// ------------------------------------------------------------------------------------------------

List<WithdrawAccount> withdrawAccounts({
  required final StakePool stakePool,
  required final ValidatorList validatorList,
  required final BigInt amount,
  required final BigInt minBalance,
  required final int reserveStakeAvailableBalance,
}) {
  final List<WithdrawAccount> accounts = [];

  for (final ValidatorStakeInfo validator in validatorList.validators) {
    
    if (validator.status != StakeStatus.active) {
      continue;
    }

    final PublicKey voteAccountAddress = PublicKey.fromBase58(validator.voteAccountAddress);

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

    final BigInt transientStakeLamports = validator.transientStakeLamports - minBalance;
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

  /// Sort by type and then balance.
  accounts.sort((a, b) {
    final int compare = a.type.index - b.type.index;
    return compare == 0 ? (b.amount - a.amount).toInt() : compare;
  });

  if (reserveStakeAvailableBalance > 0) {
    accounts.add(
      WithdrawAccount(
        type: WithdrawAccountType.reserved, 
        stakeAddress: PublicKey.fromBase58(stakePool.reserveStake), 
        amount: reserveStakeAvailableBalance.toBigInt(),
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

  BigInt remainingAmount = amount;
  final List<WithdrawAccount> withdrawalAccounts = [];
  final double feeRatio = stakePool.stakeWithdrawalFee.ratio;

  for (final WithdrawAccount account in accounts) {
    
    /// If the fee is not 0 (i.e. no fee), it needs to be removed from [account.amount].
    assert(feeRatio == 0);

    if (account.amount <= minBalance && account.type == WithdrawAccountType.transient) {
      continue;
    }
    
    print('STAKE POOL TOKEN SUPPLY    ${stakePool.poolTokenSupply}');
    print('STAKE POOL TOTAL LAMPORTS  ${stakePool.totalLamports}');
    print('AVAILABLE WITHDRAW         ${calcPoolTokensForDeposit(stakePool: stakePool, stakeLamports: account.amount)}');

    final BigInt withdrawalAmount = biMin(account.amount, remainingAmount);
    print('WITHDRAW AMOUNT LAM (${account.type}) = $withdrawalAmount');
    print('WITHDRAW AMOUNT SOL (${account.type}) = ${lamportsToSol(withdrawalAmount)} SOL');
    withdrawalAccounts.add(account.copyWithAmount(withdrawalAmount));
    remainingAmount -= withdrawalAmount;
    print('REMAINING AMOUNT = $remainingAmount');

    if (remainingAmount == BigInt.zero) {
      break;
    }
  }

  if (remainingAmount != BigInt.zero) {
    throw const SPDException('Insufficient validator balances to perform withdrawal.');
  }

  return withdrawalAccounts;
}