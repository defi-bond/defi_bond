/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import '../../constants.dart' show mintAddress, reserveAddress, stakePoolAddress, validatorListAddress;
import '../../exceptions/exception.dart';
import '../../programs/stake_pool/models.dart';


/// Helper methods
/// ------------------------------------------------------------------------------------------------

/// Returns null if [value] is negative or zero.
int? nonZeroUint(final int value) => value > 0 ? value : null;

/// Returns the minimum value.
BigInt minBigInt(final BigInt a, final BigInt b) => a < b ? a : b;

/// Returns the stake pool for [address].
Future<StakePoolInfo> getStakePoolInfo(
  final SolanaWalletProvider provider,
) async {

  // The JSON RPC connection.
  final Connection connection = provider.connection;

  // Get the user account connected to the app.
  final Account? connectedAccount = provider.connectedAccount;

  // Check that the user account is connected to the app.
  if (connectedAccount == null) {
    throw const SPDException('Connect wallet to dApp.');
  }

  // Get the user's token address.
  final ProgramAddress tokenAddress = PublicKey.findAssociatedTokenAddress(
    connectedAccount.toPublicKey(), 
    mintAddress,
  );

  final List<JsonRpcResponse<AccountInfo?>> responses = await connection.bulkRequest([
    JsonRpcRequest.build(
      Method.getAccountInfo.name,
      [stakePoolAddress.toBase58()],
      config: GetAccountInfoConfig(),
    ),
    JsonRpcRequest.build(
      Method.getAccountInfo.name,
      [validatorListAddress.toBase58()],
      config: GetAccountInfoConfig(),
    ),
    JsonRpcRequest.build(
      Method.getAccountInfo.name,
      [tokenAddress.publicKey.toBase58()],
      config: GetAccountInfoConfig(),
    ),
  ],
  parsers: [
    (final Map<String, dynamic>? json) => AccountInfo.tryFromJson(json),
  ]);

  final AccountInfo? stakePoolAccountInfo = responses[0].result;
  
  if (stakePoolAccountInfo == null) {
    throw SPDException('Invalid stake pool account $stakePoolAddress');
  }
  
  final StakePool stakePool = StakePool.fromAccountInfo(stakePoolAccountInfo);

  final AccountInfo? validatorListAccountInfo = responses[1].result;
  
  if (validatorListAccountInfo == null) {
    throw SPDException('Invalid validator list account $validatorListAddress');
  }

  final ValidatorList validatorList = ValidatorList.fromAccountInfo(validatorListAccountInfo);

  /// Check that the pool contains some validators.
  if (validatorList.validators.isEmpty) {
    throw const SPDException('No validators found, please try again soon.');
  }

  final AccountInfo? tokenAccountInfo = responses[2].result;
  
  TokenAccountInfo? tokenAccount;
  if (tokenAccountInfo != null) {
    tokenAccount = TokenAccountInfo.fromAccountInfo(tokenAccountInfo);
    if (tokenAccount.mint != mintAddress.toBase58()) {
      throw SPDException('Invalid token mint for $tokenAccount, expected $mintAddress.');
    }
  }

  // Get the withdraw address.
  final ProgramAddress withdrawAddress = StakePoolProgram.findWithdrawAuthorityProgramAddress(
    stakePoolAddress,
  );

  // Create the `update` instructions.
  return StakePoolInfo(
    stakePool: stakePool, 
    validatorList: validatorList, 
    address: stakePoolAddress, 
    validatorListAddress: validatorListAddress,
    tokenAccount: tokenAccount,
    withdraw: withdrawAddress.publicKey, 
    reserve: PublicKey.fromBase58(stakePool.reserveStake), 
    managerFee: PublicKey.fromBase58(stakePool.managerFeeAccount), 
    mint: PublicKey.fromBase58(stakePool.poolMint),
  );
}

/// Returns the stake pool for [address].
Future<StakePool> getStakePool(
  final Connection connection,
  final PublicKey address,
) async {
  final AccountInfo? accountInfo = await connection.getAccountInfo(address);
  if (accountInfo == null) throw SPDException('Invalid stake pool account.');
  return StakePool.fromAccountInfo(accountInfo);
}

/// Returns the validator list for [address].
Future<ValidatorList> getValidatorList(
  final Connection connection,
  final PublicKey address,
) async {
  final AccountInfo? accountInfo = await connection.getAccountInfo(address);
  if (accountInfo == null) throw SPDException('Invalid validator list account $address.');
  return ValidatorList.fromAccountInfo(accountInfo);
}

// Future<void> updateStakePool({
//   required final SolanaWalletProvider provider,
//   final bool Function(ValidatorStakeInfo)? predicate,
// }) async {
//   // The JSON RPC connection.
//   final Connection connection = provider.connection;

//   // Get the user account connected to the app.
//   final Account? connectedAccount = provider.connectedAccount;

//   // Check that the user account is connected to the app.
//   if (connectedAccount == null) {
//     throw const SPDException('Connect wallet to dApp.');
//   }

//   // Fetch the stake pool's account data.
//   final StakePool stakePool = await getStakePool(connection, stakePoolAddress);
//   final PublicKey poolMint = PublicKey.fromBase58(stakePool.poolMint);
//   final PublicKey poolValidatorList = PublicKey.fromBase58(stakePool.validatorList);
//   final PublicKey poolReserveStake = PublicKey.fromBase58(stakePool.reserveStake);
//   final PublicKey poolManagerFeeAccount = PublicKey.fromBase58(stakePool.managerFeeAccount);

//   /// Fetch the stake pool's validator list.
//   final ValidatorList validatorList = await getValidatorList(connection, poolValidatorList);

//   /// Check that the pool contains some validators.
//   if (validatorList.validators.isEmpty) {
//     throw const SPDException('No validators found, please try again soon.');
//   }

//   // Get the `stake pool lotto` withdraw address.
//   final ProgramAddress withdrawAddress = StakePoolProgram.findWithdrawAuthorityProgramAddress(
//     stakePoolAddress,
//   );

//   // Create the `update` instructions.
//   final UpdateInstructionData updateData = updateInstructions(
//     stakePool: stakePool, 
//     validatorList: validatorList, 
//     poolAddress: stakePoolAddress, 
//     withdrawAccount: withdrawAddress.publicKey, 
//     reserveStake: poolReserveStake, 
//     managerFeeAccount: poolManagerFeeAccount, 
//     poolMint: poolMint,
//   );

//   // final Transaction tx0 = Transaction();
//   // tx0.addAll(updateData.instructions);
//   // final _result = await provider.signTransactions(transactions: [tx0]);
//   // final _signature = await provider.connection.sendSignedTransaction(_result.signedPayloads.first);
//   // final _notification = await provider.connection.confirmTransaction(_signature);

//   // Create the transaction.
//   final Transaction tx = Transaction();
//   tx.addAll(updateData.instructions);

//   // // Sign, send and confirm the transaction.
//   // final result = await provider.signTransactions(transactions: [tx]);
//   // final signature = await provider.connection.sendSignedTransaction(result.signedPayloads.first);
//   // final notification = await provider.connection.confirmTransaction(signature);

//   // // Check for any errors.
//   // final error = notification.err;
//   // if (error != null) {
//   //   print('ERROR [depositOrWithdraw] ${notification.err}');
//   //   throw const SPLException('Failed to confirm `update` transaction.');
//   // }
// }

Future<TokenAccountInfo?> getTokenAccountInfo(
  final Connection connection,
  final PublicKey tokenAccount,
  final PublicKey expectedTokenMint,
) async {
  final AccountInfo? accountInfo = await connection.getAccountInfo(tokenAccount);
  if (accountInfo == null) return null;
  final TokenAccountInfo tokenAccountInfo = TokenAccountInfo.fromAccountInfo(accountInfo);
  if (tokenAccountInfo.mint != expectedTokenMint.toBase58()) {
    throw SPDException('Invalid token mint for $tokenAccount, expected $expectedTokenMint.');
  }
  return tokenAccountInfo;
}

Future<StakeAccount> getStakeAccountInfo(
  final Connection connection,
  final PublicKey stakeAccount,
) async {
  final AccountInfo? accountInfo = await connection.getParsedAccountInfo(stakeAccount);
  if (accountInfo == null || !accountInfo.isJson || !accountInfo.jsonData.containsKey('parsed')) {
    throw SPDException('Invalid stake account.');
  }
  if (accountInfo.jsonData['program'] != 'stake') {
    throw SPDException('Not a stake account.');
  }
  return StakeAccount.fromJson(accountInfo.jsonData['parsed']);
}


JsonRpcContextResult<u64> _contextParser(final dynamic json) {
  return JsonRpcContextResult.parse(json, (input) => input as int);
}

u64 _parser(final dynamic json) {
  return json;
}

Future<ReserveStakeBalance> getReserveStakeBalance(
  final Connection connection, {
  final PublicKey? address,
}) async {
  final List<JsonRpcResponse> responses = await connection.bulkRequest([
    JsonRpcRequest.build(
      Method.getBalance.name, 
      [(address ?? reserveAddress).toBase58()], 
      config: const GetBalanceConfig()
    ),
    JsonRpcRequest.build(
      Method.getMinimumBalanceForRentExemption.name, 
      [StakeProgram.space], 
      config: const GetMinimumBalanceForRentExemptionConfig()
    ),
    JsonRpcRequest.build(
      Method.getStakeMinimumDelegation.name, 
      const [], 
      config: const GetBalanceConfig()
    ),
  ],
  parsers: [
    _contextParser,
    _parser,
    _contextParser,
  ]);
  return ReserveStakeBalance(
    balance: responses[0].result!.value!,
    minBalanceForRentExemption: responses[1].result!,
    minDelegation: responses[2].result!.value!
  );
}

/// Calculate the pool tokens that should be minted for a deposit of `stakeLamports`.
BigInt calcPoolTokensForDeposit({
  required final StakePool stakePool, 
  required final BigInt stakeLamports,
}) {
  if (stakePool.poolTokenSupply == BigInt.zero || stakePool.totalLamports == BigInt.zero) {
    return stakeLamports;
  }
  return BigInt.from((stakeLamports * stakePool.poolTokenSupply) / stakePool.totalLamports);
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
          nonZeroUint(info.validatorSeedSuffix)?.toBigInt(),
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