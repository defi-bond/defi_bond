/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import 'package:stake_pool_lotto/programs/stake_pool/update.dart';
import '../../constants.dart' show stakePoolAddress;
import '../../exceptions/exception.dart';
import 'utils.dart';


/// Deposit
/// ------------------------------------------------------------------------------------------------

/// Deposits SOL or a Stake Account into the stake pool.
/// 
/// Provide [amount] to deposit SOL and [stakeAccount] + [validatorStakeAccount] to deposit an 
/// active stake account.
Future<List<TransactionWithSigners>> deposit({
  required final SolanaWalletProvider provider,
  final BigInt? amount,
  final PublicKey? stakeAccount,
  final PublicKey? validatorStakeAccount,
}) async {

  // Check parameters.
  assert(amount == null || stakeAccount == null, 'Must provider [amount] or a [stake information].');
  assert(amount != null || stakeAccount != null, 'Provide [amount] or a [stake information] but not both.');
  assert(stakeAccount == null || validatorStakeAccount != null, 'Validator stake account required for stake deposit.');

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

  // Create an empty transaction.
  final Transaction transaction = Transaction();

  // Add an instruction to create an associated token account for the pool's token.
  if (tokenAccountInfo == null) {
    transaction.add(
      AssociatedTokenProgram.create(
        tokenMint: mintAccount, 
        associatedTokenAccount: tokenAccount, 
        associatedTokenAccountOwner: wallet, 
        fundingAccount: wallet,
      ),
    );
  }

  // Add a deposit instruction (SOL or Stake).
  if (amount != null) {
    transaction.add(
      StakePoolProgram.depositSol(
        stakePoolAddress: stakePoolAddress, 
        withdrawAuthority: withdrawAccount, 
        reserveStake: reserveAccount, 
        payer: wallet, 
        payerTokenAccount: tokenAccount, 
        feeAccount: managerFeeAccount, 
        referralFeeAccount: managerFeeAccount, 
        poolMint: mintAccount, 
        lamports: amount,
      ),
    );
  } else if (stakeAccount != null && validatorStakeAccount != null) {
    final PublicKey depositAccount = StakePoolProgram.findDepositAuthorityProgramAddress(
      stakePoolAddress,
    ).publicKey;
    transaction.add(
      StakeProgram.authorize(
        stakeAccount: stakeAccount, 
        authority: wallet, 
        newAuthority: depositAccount, 
        authorityType: StakeAuthorize.withdrawer,
      ),
    );
    transaction.add(
      StakePoolProgram.depositStake(
        stakePoolAddress: stakePoolAddress, 
        validatorList: validatorListAccount, 
        depositAuthority: depositAccount,
        withdrawAuthority: withdrawAccount, 
        stakeAccount: stakeAccount,
        validatorStakeAccount: validatorStakeAccount, 
        reserveStake: reserveAccount, 
        userTokenAccount: tokenAccount, 
        tokenAccount: managerFeeAccount,  
        referralFeeAccount: managerFeeAccount, 
        poolMint: mintAccount,
      ),
    );
  } else {
    throw SPDException('Invalid arguments for [deposit]');
  }

  // final List<TransactionInstruction> updateInstructions = await updateStakePool(
  //   connection, 
  //   stakePool: stakePool, 
  //   validatorList: validatorList, 
  //   validatorListAccount: validatorListAccount, 
  //   stakePoolAccount: stakePoolAddress, 
  //   withdrawAccount: withdrawAccount, 
  //   reserveAccount: reserveAccount, 
  //   managerFeeAccount: managerFeeAccount, 
  //   mintAccount: mintAccount, 
  // );
  // final updateTransaction = Transaction(
  //   instructions: updateInstructions,
  // );
  // final txs = await _serializeTransactions(connection, [updateTransaction], connectedAccount);
  // await provider.adapter.signAndSendTransactions(transactions: txs);

  await updateStakePoolRemote(connection, stakePool: stakePool);

  return [
    // TransactionWithSigners(transaction: updateTransaction),
    TransactionWithSigners(transaction: transaction)
  ];
}

Future<List<String>> _serializeTransactions(
  final Connection connection,
  final Iterable<Transaction> transactions,
  final Account? connectedAccount,
) async {
  final List<String> encodedTransactions = [];
  final BlockhashCache blockhashCache = BlockhashCache();
  const SerializeConfig config = SerializeConfig(requireAllSignatures: false);
  for (final Transaction transaction in transactions) {
    final BlockhashWithExpiryBlockHeight blockhashInfo = transaction.blockhash 
      ?? (await blockhashCache.get(connection, disabled: false));
    final Transaction tx = transaction.copyWith(
      recentBlockhash: blockhashInfo.blockhash,
      lastValidBlockHeight: blockhashInfo.lastValidBlockHeight,
      feePayer: transaction.feePayer ?? PublicKey.tryFromBase64(connectedAccount?.address),
    );
    if (SolanaWalletAdapterPlatform.instance.isDesktop) {
      encodedTransactions.add(tx.serializeMessage().getString(BufferEncoding.base58));
    } else {
      encodedTransactions.add(tx.serialize(config).getString(BufferEncoding.base64));
    }
  }
  return encodedTransactions;
}

// /// Creates a deposit SOL instruction.
// Future<TransactionInstruction> depositSol({
//   required final SolanaWalletProvider provider,
//   required final Connection connection,
//   required final PublicKey wallet,
//   required final StakePool stakePool,
//   required final ValidatorList validatorList,
//   required final PublicKey tokenAccount,
//   required final PublicKey withdrawAccount,
//   required final BigInt amount,
// }) async {
//   // 
//   final List<TransactionInstruction> instructions = [];

//   // Map base-58 public keys.
//   final PublicKey reserveStake = PublicKey.fromBase58(stakePool.reserveStake);
//   final PublicKey managerFeeAccount = PublicKey.fromBase58(stakePool.managerFeeAccount);
//   final PublicKey poolMint = PublicKey.fromBase58(stakePool.poolMint);

//   // Fetch the user's token account info.
//   final TokenAccountInfo? tokenAccountInfo = await getTokenAccountInfo(
//     connection, 
//     tokenAccount, 
//     poolMint,
//   );

//   // Create an associated token account for the pool's token.
//   if (tokenAccountInfo == null) {
//     instructions.add(
//       AssociatedTokenProgram.create(
//         tokenMint: poolMint, 
//         associatedTokenAccount: tokenAccount, 
//         associatedTokenAccountOwner: wallet, 
//         fundingAccount: wallet,
//       ),
//     );
//   }

//   // Create a deposit SOL instruction.
//   return StakePoolProgram.depositSol(
//     stakePoolAddress: stakePoolAddress, 
//     withdrawAuthority: withdrawAccount, 
//     reserveStake: reserveStake, 
//     payer: wallet, 
//     payerTokenAccount: tokenAccount, 
//     feeAccount: managerFeeAccount, 
//     referralFeeAccount: managerFeeAccount, 
//     poolMint: poolMint, 
//     lamports: amount,
//   );
// }


// // /// Deposit Stake
// // /// ------------------------------------------------------------------------------------------------

// // /// Creates a deposit Stake instruction.
// // Future<InstructionData> depositStake({
// //   required final SolanaWalletProvider provider,
// //   required final Connection connection,
// //   required final PublicKey wallet,
// //   required final StakePool stakePool,
// //   required final ValidatorList validatorList,
// //   required final PublicKey tokenAccount,
// //   required final PublicKey withdrawAccount,
// //   required final PublicKey stakeAccount,
// //   required final PublicKey voteAccount,
// // }) async {
// //   final List<TransactionInstruction> instructions = [];

// //   // Map base-58 public keys.
// //   final StakePoolInfo stakeAccountInfo = await getStakePoolInfo(provider);

// //   // Create an associated token account for the pool's token.
// //   if (tokenAccountInfo == null) {
// //     instructions.add(
// //       AssociatedTokenProgram.create(
// //         tokenMint: stakeAccountInfo.mint, 
// //         associatedTokenAccount: tokenAccount, 
// //         associatedTokenAccountOwner: wallet, 
// //         fundingAccount: wallet,
// //       ),
// //     );
// //   }

// //   // Create a deposit Stake instruction.
// //   instructions.add(
// //     StakePoolProgram.depositStake(
// //       stakePoolAddress: stakePoolAddress, 
// //       validatorList: validatorList, 
// //       depositAuthority: depositAddress.publicKey, 
// //       withdrawAuthority: withdrawAccount, 
// //       stakeAccount: stakeAccount, 
// //       validatorStakeAccount: voteAccount, 
// //       reserveStake: reserveStake, 
// //       userTokenAccount: tokenAccount, 
// //       tokenAccount: tokenAccount, 
// //       referralFeeAccount: managerFeeAccount, 
// //       poolMint: poolMint,
// //     ),
// //   );

// //   return InstructionData(
// //     instructions: instructions,
// //   );
// // }