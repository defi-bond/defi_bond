/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:typed_data';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import '../../constants.dart' show stakePoolAddress;
import '../../exceptions/exception.dart';
import 'utils.dart';


/// Delegate
/// ------------------------------------------------------------------------------------------------

Future<void> delegate({
  required final SolanaWalletProvider provider,
}) async {

  // The JSON RPC connection.
  final Connection connection = provider.connection;

  // // Check that the user account is connected to the app.
  // if (!provider.isAuthorized) {
  //   throw const SPLException('Connect wallet to dApp.');
  // }

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
    predicate: (info) => info.status == StakeStatus.active,
  );

  final List<ValidatorStakeInfo> validatorStakeInfoList = updateData.validatorStakeInfoList;
  final int reserveStakeBalance = await connection.getBalance(poolReserveStake);

  final int minBalanceForRentExemption = await connection.getMinimumBalanceForRentExemption(
    StakeProgram.space,
  );

  final int minDelegation = await connection.getStakeMinimumDelegation();

  print('POOL RESERVE BALANCE   $reserveStakeBalance');

  print('MIN RENT EX            $minBalanceForRentExemption');

  print('MIN DELEGATION         $minDelegation');

  final int lamports = ((reserveStakeBalance-minBalanceForRentExemption-minDelegation) / validatorStakeInfoList.length).floor();

  print('POOL PER VALIDATOR     $lamports');

  print('ACTIVE VALIDATORS      ${validatorStakeInfoList.length}');

  if (lamports <= minBalanceForRentExemption+minDelegation) {
    throw Exception('Not enough SOL in the reserve.');
  }

  final p = PublicKey.fromBase58(stakePool.reserveStake);
  final x = await connection.getStakeActivation(p);
  print('RESERVE STAKE      $p ${x.toJson()}');

  final List<TransactionInstruction> instructions = [];
  for (final ValidatorStakeInfo info in validatorStakeInfoList) {
    final voteAccount = PublicKey.fromBase58(info.voteAccountAddress);
    final transientSeedSuffix = info.transientSeedSuffix + BigInt.one;
    final validatorAddress = StakePoolProgram.findStakeProgramAddress(
      voteAccount, 
      stakePoolAddress,
    );
    final transientAddress = StakePoolProgram.findTransientStakeProgramAddress(
      voteAccount,
      stakePoolAddress,
      transientSeedSuffix,
    );
    // final ta = StakePoolProgram.findTransientStakeProgramAddress(
    //   voteAccount,
    //   poolAddress,
    //   transientSeedSuffix - BigInt.one,
    // );
    instructions.add(
      StakePoolProgram.increaseValidatorStake(
        stakePoolAddress: stakePoolAddress, 
        staker: PublicKey.fromBase58(stakePool.staker), 
        withdrawAuthority: withdrawAddress.publicKey, 
        validatorList: poolValidatorList,
        reserveStake: poolReserveStake,
        transientStakeAccount: transientAddress.publicKey, 
        validatorStakeAccount: validatorAddress.publicKey, 
        validatorVoteAccount: voteAccount, 
        lamports: lamports.toBigInt(), 
        transientStakeSeed: transientSeedSuffix,
      ),
    );
    final x = await connection.getStakeActivation(voteAccount);
    print('ACTIVATION VOTE  $voteAccount ${x.toJson()}');
    final y = await connection.getStakeActivation(validatorAddress.publicKey);
    print('ACTIVATION STAKE ${validatorAddress.publicKey} ${y.toJson()}');
    // final z = await connection.getStakeActivation(ta.publicKey);
    // print('ACTIVATION TRANS ${ta.publicKey} ${z.toJson()}');
    // print('\n');
  }

  // Create the transaction.
  final Transaction tx = Transaction();
  tx.addAll(updateData.instructions);
  tx.addAll(instructions);


  print('INSTRUCTION COUNT ${tx.instructions.length}');
  print('STAKER ADDRESS (XXX) ${PublicKey.fromBase58(stakePool.staker).toBase58()}');

  final staker = Keypair.fromSecretKeySync(Uint8List.fromList([
    44,24,219,8,224,220,188,164,213,139,63,173,27,121,147,2,73,37,183,11,30,
    5,236,127,38,75,215,66,250,113,130,40,189,51,210,24,58,144,121,60,211,90,
    15,62,175,11,176,34,215,62,94,151,102,179,203,142,168,92,64,52,46,199,101,59,
  ]));

  print('STAKER ADDRESS (B58) ${staker.publicKey.toBase58()}');

  // Sign, send and confirm the transaction.
  await connection.sendAndConfirmTransaction(tx, signers: [staker]);
}