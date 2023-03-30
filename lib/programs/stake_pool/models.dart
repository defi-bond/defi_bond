/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_wallet_provider/solana_wallet_provider.dart';


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


/// Stake Pool Info
/// ------------------------------------------------------------------------------------------------

class ReserveStakeBalance {
  
  const ReserveStakeBalance({
    required this.balance,
    required this.minBalanceForRentExemption,
    required this.minDelegation,
  });
  
  final int balance;
  
  final int minBalanceForRentExemption;
  
  final int minDelegation;

  int get minBalance 
    => minBalanceForRentExemption 
     + minDelegation 
     + lamportsPerSol; // +1 SOL for clearance.

  int get availableBalance => balance - minBalance;
}


/// Stake Pool Info
/// ------------------------------------------------------------------------------------------------

class StakePoolInfo {

  const StakePoolInfo({
    required this.stakePool, 
    required this.validatorList, 
    required this.address, 
    required this.validatorListAddress,
    required this.tokenAccount,
    required this.withdraw, 
    required this.reserve, 
    required this.managerFee, 
    required this.mint, 
  });

  final StakePool stakePool;
  final ValidatorList validatorList;
  final PublicKey address;
  final PublicKey validatorListAddress;
  final TokenAccountInfo? tokenAccount;
  final PublicKey withdraw;
  final PublicKey reserve;
  final PublicKey managerFee;
  final PublicKey mint;
}


/// Update Validator List Balance
/// ------------------------------------------------------------------------------------------------

class UpdateValidatorListBalance {
  
  const UpdateValidatorListBalance({
    required this.instruction,
    this.validators = const [],
    this.validatorAndTransientStakeAccounts = const [],
  }): assert(validators.length == validatorAndTransientStakeAccounts.length);

  final TransactionInstruction instruction;

  final List<ValidatorStakeInfo> validators;

  final List<PublicKey> validatorAndTransientStakeAccounts;
}