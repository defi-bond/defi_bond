/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import '../../constants.dart';
import '../../exceptions/exception.dart';
import 'deposit.dart';
import 'withdraw.dart';
import 'utils.dart';


/// Deposit or Withdraw
/// ------------------------------------------------------------------------------------------------

/// Send and confirm a `deposit` or `withdraw` transaction on the network.
/// 
/// If [amount] > 0 execute a `deposit` transaction.
/// 
/// If [amount] < 0 run a `withdraw` transaction.
/// 
/// If [amount] == 0 throw an exception.
Future<SignAndSendTransactionsResult> depositOrWithdraw(
  final BuildContext context, {
  required final SolanaWalletProvider provider,
  required final BigInt amount,
}) async {
  return provider.signAndSendTransactions(
    context, 
    depositOrWithdrawTx(provider: provider, amount: amount)
  );
  // // Check that the provided amount is valid (+ve for deposits and -ve for withdrawals).
  // if (amount == BigInt.zero) {
  //   throw const SPDException('Invalid amount.');
  // }

  // // The JSON RPC connection.
  // final Connection connection = provider.connection;

  // // Get the user account connected to the app.
  // final Account? connectedAccount = provider.connectedAccount;

  // // Check that the user account is connected to the app.
  // if (connectedAccount == null) {
  //   throw const SPDException('Connect wallet to dApp.');
  // }

  // // Get the user account public key address.
  // final PublicKey wallet = PublicKey.fromBase64(connectedAccount.address);

  // // Fetch the stake pool's account data.
  // final StakePool stakePool = await getStakePool(connection, stakePoolAddress);
  // final PublicKey poolMint = PublicKey.fromBase58(stakePool.poolMint);
  // final PublicKey poolValidatorList = PublicKey.fromBase58(stakePool.validatorList);
  // final PublicKey poolReserveStake = PublicKey.fromBase58(stakePool.reserveStake);
  // final PublicKey poolManagerFeeAccount = PublicKey.fromBase58(stakePool.managerFeeAccount);

  // /// Fetch the stake pool's validator list.
  // final ValidatorList validatorList = await getValidatorList(connection, poolValidatorList);

  // /// Check that the pool contains some validators.
  // if (validatorList.validators.isEmpty) {
  //   throw const SPDException('No validators found, please try again soon.');
  // }

  // // Get the user's `stake pool lotto` token address.
  // final ProgramAddress tokenAddress = PublicKey.findAssociatedTokenAddress(
  //   wallet, 
  //   poolMint,
  // );

  // // Get the `stake pool lotto` withdraw address.
  // final ProgramAddress withdrawAddress = StakePoolProgram.findWithdrawAuthorityProgramAddress(
  //   stakePoolAddress,
  // );

  // // Create the `update` instructions.
  // final UpdateInstructionData updateData = updateInstructions(
  //   stakePool: stakePool, 
  //   validatorList: validatorList, 
  //   poolAddress: stakePoolAddress, 
  //   withdrawAccount: withdrawAddress.publicKey, 
  //   reserveStake: poolReserveStake, 
  //   managerFeeAccount: poolManagerFeeAccount, 
  //   poolMint: poolMint,
  // );

  // // Create the `deposit` or `withdraw` instructions.
  // final InstructionData data = amount > BigInt.zero 
  //   ? await depositSol(
  //       provider: provider,
  //       connection: connection,
  //       wallet: wallet,
  //       stakePool: stakePool,
  //       validatorList: validatorList,
  //       tokenAccount: tokenAddress.publicKey,
  //       withdrawAccount: withdrawAddress.publicKey,
  //       amount: amount,
  //     )
  //   : await withdraw(
  //       provider: provider,
  //       connection: connection, 
  //       wallet: wallet, 
  //       stakePool: stakePool, 
  //       validatorList: validatorList, 
  //       tokenAccount: tokenAddress.publicKey, 
  //       withdrawAccount: withdrawAddress.publicKey, 
  //       amount: -amount,
  //     );

  // // Create the transaction.
  // final Transaction tx = Transaction();
  // tx.addAll(updateData.instructions);
  // tx.addAll(data.instructions);

  // print('INSTRUCTION LENGTH ${data.instructions.length}');

  // // Sign, send and confirm the transaction.
  // final signers = data.signers != null ? [data.signers!] : null;
  // final result = await provider.signA(transactions: [tx], signers: signers);
  // final signature = await provider.connection.sendSignedTransaction(result.signedPayloads.first);
  // final notification = await provider.connection.confirmTransaction(signature);

  // // Check for any errors.
  // final error = notification.err;
  // if (error != null) {
  //   print('ERROR [depositOrWithdraw] ${notification.err}');
  //   throw const SPDException('Failed to confirm transaction.');
  // }
}

Future<List<Transaction>> depositOrWithdrawTx({
  required final SolanaWalletProvider provider,
  required final BigInt amount,
}) async {

  // Check that the provided amount is valid (+ve for deposits and -ve for withdrawals).
  if (amount == BigInt.zero) {
    throw const SPDException('Invalid amount.');
  }

  // The JSON RPC connection.
  final Connection connection = provider.connection;

  // Get the user account connected to the app.
  final Account? connectedAccount = provider.connectedAccount;

  // Check that the user account is connected to the app.
  if (connectedAccount == null) {
    throw const SPDException('Connect wallet to dApp.');
  }

  // Get the user account public key address.
  final PublicKey wallet = PublicKey.fromBase64(connectedAccount.address);

  // Fetch the stake pool's account data.
  final StakePool stakePool = await getStakePool(connection, stakePoolAddress);
  final PublicKey poolMint = PublicKey.fromBase58(stakePool.poolMint);
  final PublicKey poolValidatorList = PublicKey.fromBase58(stakePool.validatorList);
  final PublicKey poolReserveStake = PublicKey.fromBase58(stakePool.reserveStake);
  final PublicKey poolManagerFeeAccount = PublicKey.fromBase58(stakePool.managerFeeAccount);

  /// Fetch the stake pool's validator list.
  final ValidatorList validatorList = await getValidatorList(connection, poolValidatorList);

  /// Check that the pool contains some validators.
  if (validatorList.validators.isEmpty) {
    throw const SPDException('No validators found, please try again soon.');
  }

  // Get the user's `stake pool lotto` token address.
  final ProgramAddress tokenAddress = PublicKey.findAssociatedTokenAddress(
    wallet, 
    poolMint,
  );

  // Get the `stake pool lotto` withdraw address.
  final ProgramAddress withdrawAddress = StakePoolProgram.findWithdrawAuthorityProgramAddress(
    stakePoolAddress,
  );

  // Create the `update` instructions.
  final UpdateInstructionData updateData = updateInstructions(
    stakePool: stakePool, 
    validatorList: validatorList, 
    poolAddress: stakePoolAddress, 
    withdrawAccount: withdrawAddress.publicKey, 
    reserveStake: poolReserveStake, 
    managerFeeAccount: poolManagerFeeAccount, 
    poolMint: poolMint,
  );

  // Create the `deposit` or `withdraw` instructions.
  final InstructionData data = amount > BigInt.zero 
    ? await depositSol(
        provider: provider,
        connection: connection,
        wallet: wallet,
        stakePool: stakePool,
        validatorList: validatorList,
        tokenAccount: tokenAddress.publicKey,
        withdrawAccount: withdrawAddress.publicKey,
        amount: amount,
      )
    : await withdraw(
        provider: provider,
        connection: connection, 
        wallet: wallet, 
        stakePool: stakePool, 
        validatorList: validatorList, 
        tokenAccount: tokenAddress.publicKey, 
        withdrawAccount: withdrawAddress.publicKey, 
        amount: -amount,
      );

  // Create the transaction.
  final Transaction tx = Transaction(
    feePayer: wallet,
    recentBlockhash: (await provider.connection.getLatestBlockhash()).blockhash
  );
  tx.addAll(updateData.instructions);
  tx.addAll(data.instructions);

  return [tx];
  // print('INSTRUCTION LENGTH ${data.instructions.length}');

  // // Sign, send and confirm the transaction.
  // final signers = data.signers != null ? data.signers! : null;
  // final result = await provider.signMessages(
  //   messages: [tx.compileMessage()], 
  //   signers: signers != null ? [signers] : null, 
  //   addresses: [
  //     wallet,
  //     if (signers != null)
  //       ...(signers.map((e) => e.publicKey).toList())
  // ]);
  
  // return provider.connection.getFeeForEncodedMessage(result.signedPayloads.first);
}