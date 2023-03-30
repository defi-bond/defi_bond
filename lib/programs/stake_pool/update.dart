/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import 'package:stake_pool_lotto/exceptions/exception.dart';
import 'models.dart';
import 'utils.dart';


/// Update Stake Pool Remote
/// ------------------------------------------------------------------------------------------------

Future<void> updateStakePoolRemote(
  final Connection connection, {
  required final StakePool stakePool,
  final int maxAttemps = 3,
  final bool force = false,
}) async {
  
  if (!force) {
    final EpochInfo epochInfo = await connection.getEpochInfo();
    if (stakePool.lastUpdateEpoch == epochInfo.epoch.toBigInt()) {
      print('Update not required.');
      return;
    }
  }

  try {
    for (int count = 1; count <= maxAttemps; ++count) {
      final http.Response response = await http.post(
        Uri.http('ec2-18-217-3-117.us-east-2.compute.amazonaws.com', '/pool/update'),
      );
      if (response.statusCode == 200) {
        break;
      }  
      
      if (count == maxAttemps) {
        throw SPDException('Failed to update stake pool, please try again soon.');
      } else {
        await Future.delayed(Duration(milliseconds: count * 250));
      }
    }
  } on SocketException catch (error) {
    print('*** ERROR (${error.runtimeType}) $error');
    rethrow;
  }
}


/// Update Stake Pool
/// ------------------------------------------------------------------------------------------------

Future<List<TransactionInstruction>> updateStakePool(
  final Connection connection, {
  required final StakePool stakePool,
  required final ValidatorList validatorList,
  required final PublicKey validatorListAccount,
  required final PublicKey stakePoolAccount,
  required final PublicKey withdrawAccount,
  required final PublicKey reserveAccount,
  required final PublicKey managerFeeAccount,
  required final PublicKey mintAccount,
}) async {

  // final EpochInfo epochInfo = await connection.getEpochInfo();
  // if (stakePool.lastUpdateEpoch == epochInfo.epoch.toBigInt()) {
  //   print('Update not required.');
  //   return;
  // }
  
  final List<TransactionInstruction> instructions = [];

  List<PublicKey> validatorAndTransientStakeAccounts = [];
  const int maxUpdate = StakePoolProgram.maxValidatorsToUpdate;
  assert(maxUpdate > 0);
  
  for (int i = 0; i < validatorList.validators.length; ++i) {
    
    final ValidatorStakeInfo validator = validatorList.validators[i];
    final PublicKey voteAccount = PublicKey.fromBase58(validator.voteAccountAddress);
    
    validatorAndTransientStakeAccounts.addAll([
      StakePoolProgram.findStakeProgramAddress(
        voteAccount,
        stakePoolAccount,
        nonZeroUint(validator.validatorSeedSuffix)?.toBigInt(),
      ).publicKey,
      StakePoolProgram.findTransientStakeProgramAddress(
        voteAccount,
        stakePoolAccount,
        validator.transientSeedSuffix,
      ).publicKey,
    ]);

    final int count = i + 1;
    if ((count % maxUpdate == 0) || count == validatorList.validators.length) {
      instructions.add(
        StakePoolProgram.updateValidatorListBalance(
          stakePoolAddress: stakePoolAccount, 
          withdrawAuthority: withdrawAccount, 
          validatorList: validatorListAccount, 
          reserveStake: reserveAccount, 
          validatorAndTransientStakeAccounts: validatorAndTransientStakeAccounts, 
          startIndex: instructions.length * maxUpdate, 
          noMerge: false,
        ),
      );
      validatorAndTransientStakeAccounts = [];
    }
  }

  instructions.add(
    StakePoolProgram.updateStakePoolBalance(
      stakePoolAddress: stakePoolAccount, 
      withdrawAuthority: withdrawAccount, 
      validatorList: validatorListAccount, 
      reserveStake: reserveAccount, 
      managerFeeAccount: managerFeeAccount, 
      poolMint: mintAccount, 
    ),
  );

  instructions.add(
    StakePoolProgram.cleanupRemovedValidatorEntries(
      stakePoolAddress: stakePoolAccount, 
      validatorList: validatorListAccount,
    ),
  );

  return instructions;
}


/// Update Validator List Balance
/// ------------------------------------------------------------------------------------------------

UpdateValidatorListBalance updateValidatorListBalance({
  required final StakePool stakePool,
  required final ValidatorList validatorList,
  required final PublicKey validatorListAccount,
  required final PublicKey stakePoolAccount,
  required final PublicKey withdrawAccount,
  required final PublicKey reserveAccount,
  required final PublicKey managerFeeAccount,
  required final PublicKey mintAccount,
  final bool Function(ValidatorStakeInfo)? predicate,
}) {
  final List<ValidatorStakeInfo> validators = [];
  final List<PublicKey> validatorAndTransientStakeAccounts = [];
  for (final ValidatorStakeInfo info in validatorList.validators) {
    if (predicate == null || predicate(info)) {
      validators.add(info);
      final voteAccount = PublicKey.fromBase58(info.voteAccountAddress);
      validatorAndTransientStakeAccounts.addAll([
        StakePoolProgram.findStakeProgramAddress(
          voteAccount,
          mintAccount,
          nonZeroUint(info.validatorSeedSuffix)?.toBigInt(),
        ).publicKey,
        StakePoolProgram.findTransientStakeProgramAddress(
          voteAccount,
          mintAccount,
          info.transientSeedSuffix,
        ).publicKey,
      ]);
    }
  }

  return UpdateValidatorListBalance(
    validators: validators,
    validatorAndTransientStakeAccounts: validatorAndTransientStakeAccounts,
    instruction: StakePoolProgram.updateValidatorListBalance(
      stakePoolAddress: stakePoolAccount, 
      withdrawAuthority: withdrawAccount, 
      validatorList: validatorListAccount, 
      reserveStake: reserveAccount, 
      validatorAndTransientStakeAccounts: validatorAndTransientStakeAccounts, 
      startIndex: 0, 
      noMerge: false,
    ),
  );
}


/// Update Stake Pool Balance
/// ------------------------------------------------------------------------------------------------

TransactionInstruction updateStakePoolBalance({
  required final PublicKey stakePoolAccount,
  required final PublicKey validatorListAccount,
  required final PublicKey withdrawAccount,
  required final PublicKey reserveAccount,
  required final PublicKey managerFeeAccount,
  required final PublicKey mintAccount,
}) => StakePoolProgram.updateStakePoolBalance(
  stakePoolAddress: stakePoolAccount, 
  withdrawAuthority: withdrawAccount, 
  validatorList: validatorListAccount, 
  reserveStake: reserveAccount, 
  managerFeeAccount: managerFeeAccount, 
  poolMint: mintAccount,
);