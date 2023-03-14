/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import '../../constants.dart' show stakePoolAddress;
import '../../exceptions/exception.dart';


/// Helper methods
/// ------------------------------------------------------------------------------------------------

BigInt biMin(final BigInt a, final BigInt b) {
  return a < b ? a : b;
}

Future<StakePool> getStakePool(
  final Connection connection,
  final PublicKey address,
) async {
  final AccountInfo? accountInfo = await connection.getAccountInfo(address);

  if (accountInfo == null) {
    throw Exception('Invalid stake pool account.');
  }

  return StakePool.fromAccountInfo(accountInfo);
}

Future<void> updateStakePool({
  required final SolanaWalletProvider provider,
  final bool Function(ValidatorStakeInfo)? predicate,
}) async {
  // The JSON RPC connection.
  final Connection connection = provider.connection;

  // Get the user account connected to the app.
  final Account? connectedAccount = provider.connectedAccount;

  // Check that the user account is connected to the app.
  if (connectedAccount == null) {
    throw const SPDException('Connect wallet to dApp.');
  }

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

  // final Transaction tx0 = Transaction();
  // tx0.addAll(updateData.instructions);
  // final _result = await provider.signTransactions(transactions: [tx0]);
  // final _signature = await provider.connection.sendSignedTransaction(_result.signedPayloads.first);
  // final _notification = await provider.connection.confirmTransaction(_signature);

  // Create the transaction.
  final Transaction tx = Transaction();
  tx.addAll(updateData.instructions);

  // // Sign, send and confirm the transaction.
  // final result = await provider.signTransactions(transactions: [tx]);
  // final signature = await provider.connection.sendSignedTransaction(result.signedPayloads.first);
  // final notification = await provider.connection.confirmTransaction(signature);

  // // Check for any errors.
  // final error = notification.err;
  // if (error != null) {
  //   print('ERROR [depositOrWithdraw] ${notification.err}');
  //   throw const SPLException('Failed to confirm `update` transaction.');
  // }
}

Future<TokenAccountInfo?> getTokenAccountInfo(
  final Connection connection,
  final PublicKey tokenAccount,
  final PublicKey expectedTokenMint,
) async {
  final AccountInfo? accountInfo = await connection.getAccountInfo(tokenAccount);

  if (accountInfo == null) {
    return null;
  }

  final TokenAccountInfo tokenAccountInfo = TokenAccountInfo.fromAccountInfo(accountInfo);

  if (tokenAccountInfo.mint != expectedTokenMint.toBase58()) {
    throw Exception(
      'Invalid token mint for $tokenAccount, expected mint is $expectedTokenMint.',
    );
  }

  return tokenAccountInfo;
}

Future<StakeAccount> getStakeAccountInfo(
  final Connection connection,
  final PublicKey stakeAccount,
) async {
  final AccountInfo? accountInfo = await connection.getParsedAccountInfo(stakeAccount);

  if (accountInfo == null || !accountInfo.isJson || !accountInfo.jsonData.containsKey('parsed')) {
    throw Exception('Invalid stake account.');
  }

  if (accountInfo.jsonData['program'] != 'stake') {
    throw Exception('Not a stake account.');
  }

  return StakeAccount.fromJson(accountInfo.jsonData['parsed']);
}

Future<ValidatorList> getValidatorList(
  final Connection connection,
  final PublicKey validatorList,
) async {
  final AccountInfo? accountInfo = await connection.getAccountInfo(validatorList);
  
  if (accountInfo == null) {
    throw Exception('Invalid validator list account $validatorList.');
  }

  return ValidatorList.fromAccountInfo(accountInfo);
}

/// Calculate the pool tokens that should be minted for a deposit of `stakeLamports`.
int calcPoolTokensForDeposit({
  required final StakePool stakePool, 
  required final BigInt stakeLamports,
}) {
  if (stakePool.poolTokenSupply == BigInt.zero || stakePool.totalLamports == BigInt.zero) {
    return stakeLamports.toInt();
  }

  return ((stakeLamports * stakePool.poolTokenSupply) / stakePool.totalLamports).floor();
}

/// Calculate lamports amount on withdrawal.
double calcLamportsWithdrawAmount(
  final StakePool stakePool, 
  final BigInt poolTokens,
) {
  final BigInt numerator = poolTokens * stakePool.totalLamports;
  final BigInt denominator = stakePool.poolTokenSupply;

  if (numerator < denominator || denominator == BigInt.zero) {
    return 0.0;
  }

  return numerator / denominator;
}

// BigInt divideBnToNumber(numerator: BN, denominator: BN): number {
//   if (denominator.isZero()) {
//     return 0;
//   }
//   const quotient = numerator.div(denominator).toNumber();
//   const rem = numerator.umod(denominator);
//   const gcd = rem.gcd(denominator);
//   return quotient + rem.div(gcd).toNumber() / denominator.div(gcd).toNumber();
// }

UpdateInstructionData updateInstructions({
  required final StakePool stakePool,
  required final ValidatorList validatorList,
  required final PublicKey poolAddress,
  required final PublicKey withdrawAccount,
  required final PublicKey reserveStake,
  required final PublicKey managerFeeAccount,
  required final PublicKey poolMint,
  final bool Function(ValidatorStakeInfo)? predicate,
}) {
  final List<TransactionInstruction> instructions = [];
  final List<PublicKey> validatorAndTransientStakePairs = [];
  final List<ValidatorStakeInfo> validatorStakeInfoList = [];
  final PublicKey poolValidatorList = PublicKey.fromBase58(stakePool.validatorList);
  
  for (final ValidatorStakeInfo info in validatorList.validators) {
    if (predicate == null || predicate(info)) {
      final voteAccount = PublicKey.fromBase58(info.voteAccountAddress);
      validatorAndTransientStakePairs.addAll([
        StakePoolProgram.findStakeProgramAddress(
          voteAccount,
          poolAddress,
        ).publicKey,
        StakePoolProgram.findTransientStakeProgramAddress(
          voteAccount,
          poolAddress,
          info.transientSeedSuffix,
        ).publicKey,
      ]);
      validatorStakeInfoList.add(info);
    }
  }

  instructions.addAll([
    StakePoolProgram.updateValidatorListBalance(
      stakePoolAddress: poolAddress, 
      withdrawAuthority: withdrawAccount, 
      validatorList: poolValidatorList, 
      reserveStake: reserveStake, 
      validatorAndTransientStakeAccounts: validatorAndTransientStakePairs, 
      startIndex: 0, 
      noMerge: false,
    ),
    StakePoolProgram.updateStakePoolBalance(
      stakePoolAddress: poolAddress, 
      withdrawAuthority: withdrawAccount, 
      validatorList: poolValidatorList, 
      reserveStake: reserveStake, 
      managerFeeAccount: managerFeeAccount, 
      poolMint: poolMint,
    ),
    StakePoolProgram.cleanupRemovedValidatorEntries(
      stakePoolAddress: poolAddress,
      validatorList: poolValidatorList,
    ),
  ]);

  return UpdateInstructionData(
    instructions: instructions,
    validatorStakeInfoList: validatorStakeInfoList,
  );
}

class InstructionData {
  
  const InstructionData({
    required this.instructions,
    this.signers,
  });

  final List<TransactionInstruction> instructions;
  final List<Signer>? signers;
}

class UpdateInstructionData {
  
  const UpdateInstructionData({
    required this.instructions,
    required this.validatorStakeInfoList,
  });

  final List<TransactionInstruction> instructions;
  final List<ValidatorStakeInfo> validatorStakeInfoList;
}