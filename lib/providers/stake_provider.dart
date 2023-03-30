/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import 'package:stake_pool_lotto/models/token.dart';
import '../providers/provider.dart';
import '../storage/storage_key.dart';
import '../themes/colors/color.dart';


/// Delegation Status
/// ------------------------------------------------------------------------------------------------

enum DelegationStatus {
  
  active('Active'),
  inactive('Inactive'),
  deactivating('Deactivating'),
  ;

  const DelegationStatus(this.label);
  final String label;

  Color get color {
    switch (this) {
      case DelegationStatus.active:
        return SPDColor.shared.success;
      case DelegationStatus.inactive:
        return SPDColor.shared.error;
      case DelegationStatus.deactivating:
        return SPDColor.shared.warning;
    }
  }
}


/// Delegation Info
/// ------------------------------------------------------------------------------------------------

class DelegationInfo extends Serializable {

  DelegationInfo({
    required this.address,
    required this.vote,
    required this.stake,
    required this.rent,
    required this.credits,
    required this.status,
    required this.deactivationEpoch,
  }): stakeAndRent = lamportsToSol(solToLamports(stake) + solToLamports(rent));

  final String address;
  final String vote;
  final double stake;
  final double rent;
  final double credits;
  final DelegationStatus status;
  final double stakeAndRent;
  final BigInt deactivationEpoch;
  
  factory DelegationInfo.fromJson(final Map<String, dynamic> json) => DelegationInfo(
    address: json['address'],
    vote: json['vote'],
    stake: json['stake'],
    rent: json['rent'],
    credits: json['credits'],
    status: json['status'],
    deactivationEpoch: BigInt.parse(json['deactivationEpoch']),
  );

  @override
  Map<String, dynamic> toJson() => {
    'address': address,
    'vote': vote,
    'stake': stake,
    'rent': rent,
    'credits': credits,
    'status': status,
    'deactivationEpoch': deactivationEpoch.toString(),
  };
}


/// Stake Info
/// ------------------------------------------------------------------------------------------------

class StakeValidatorInfo {

  const StakeValidatorInfo({
    required this.name,
    required this.logo,
  });

  final String name;
  final String? logo;
}


/// Stake Info
/// ------------------------------------------------------------------------------------------------

class StakeInfo extends Serializable {

  const StakeInfo({
    required this.delegated,
    required this.undelegated,
    required this.deactivating,
  });

  final double delegated;
  final double undelegated;
  final double deactivating;
  
  factory StakeInfo.fromJson(final Map<String, dynamic> json) => StakeInfo(
    delegated: json['delegated'],
    undelegated: json['undelegated'],
    deactivating: json['deactivating'],
  );

  @override
  Map<String, dynamic> toJson() => {
    'delegated': delegated,
    'undelegated': undelegated,
    'deactivating': deactivating,
  };
}


/// Stake Provider
/// ------------------------------------------------------------------------------------------------

class StakeProvider extends SPLProvider<StakeInfo> {

  /// Stake account information provider.
  StakeProvider._();

  /// Singleton instance.
  static final StakeProvider shared = StakeProvider._();

  @override
  String get storageKey => SPDStorageKey.stakeInfoValue;
  
  @override
  StakeInfo Function(Map<String, dynamic>) get decoder => StakeInfo.fromJson;
  
  EpochInfo? epochInfo;

  List<DelegationInfo>? accounts;

  final Map<String, InflationReward?> rewards = {};

  final Map<String, StakeValidatorInfo?> validators = {
    'DDT': StakeValidatorInfo(
      name: SPDToken.drop.name,
      logo: 'assets/images/logo.png',
    ),
    'FwR3PbjS5iyqzLiLugrBqKSa5EKZ4vK9SKs7eQXtT59f': StakeValidatorInfo(
      name: 'FW Validator',
      logo: null,
    )
  };

  Future<InflationReward> reward(
    final SolanaWalletProvider provider, 
    final DelegationInfo info,
  ) async {
    final InflationReward? reward = rewards[info.address];

    final EpochInfo? epochInfo = this.epochInfo;
    final int? previousEpoch = epochInfo != null ? epochInfo.epoch - 1 : null;

    final int? rewardEpoch = (info.deactivationEpoch == BigInt.parse('18446744073709551615'))
      ? null : info.deactivationEpoch.toInt() - 1;
    if (reward != null && (reward.epoch == rewardEpoch || reward.epoch == previousEpoch)) {
      return reward;
    }
    return rewards[info.address] = (await provider.connection.getInflationReward(
      [PublicKey.fromBase58(info.address)],
      config: GetInflationRewardConfig(epoch: rewardEpoch),
    ))[0] ?? InflationReward(
        epoch: previousEpoch ?? -1, 
        effectiveSlot: -1, 
        amount: 0, 
        postBalance: -1, 
        commission: -1,
      );
  }

  double? get total {
    final StakeInfo? value = this.value;
    return value != null ? value.delegated + value.undelegated + value.deactivating : null;
  }

  /// Parses a program account response.
  List<ProgramAccount> _programAccountParser(final dynamic items)
    => list.decode(items, ProgramAccount.fromJson);

  /// Parses an epoch info response.
  EpochInfo _epochInfoParser(final dynamic json)
    => EpochInfo.fromJson(json);

  @override
  Future<StakeInfo> fetch(final SolanaWalletProvider provider) async {
    final Connection connection = provider.connection;
    final Account? connectedAccount = provider.connectedAccount;
    if (connectedAccount == null) throw Exception('[StakeProvider] No connected account.');
    final List<JsonRpcResponse> responses = await connection.bulkRequest([
      JsonRpcRequest.build(
        Method.getEpochInfo.name, [],
        config: GetEpochInfoConfig(),
      ),
      JsonRpcRequest.build(
        Method.getProgramAccounts.name, 
        [StakeProgram.programId.toBase58()], 
        config: GetProgramAccountsConfig(
          filters: ProgramFilters(
            dataSize: StakeProgram.space,
            memcmp: MemCmp(
              offset: 4 + 8 + 32, // withdraw authority.
              bytes: connectedAccount.addressBase58,
            ),
          ),              
        ),
      ),
    ],
    parsers: [
      _epochInfoParser,
      _programAccountParser,
    ]);
    final EpochInfo epochInfo = responses.first.result;
    final List<ProgramAccount> programAccounts = responses.last.result;
    BigInt delegated = BigInt.zero;
    BigInt undelegated = BigInt.zero;
    BigInt deactivating = BigInt.zero;
    final BigInt epoch = epochInfo.epoch.toBigInt();
    final List<DelegationInfo> accounts = [];
    for (final ProgramAccount programAccount in programAccounts) {
      final AccountInfo accountInfo = programAccount.account;
      final StakeAccountInfo stakeAccountInfo = StakeAccountInfo.fromAccountInfo(accountInfo);
      print('--------------------------------------------------------------------------------');
      print('KEY ${programAccount.pubkey}');
      print('ACC ${stakeAccountInfo.toJson()}');
      final Delegation delegation = stakeAccountInfo.stake.delegation;
      late final DelegationStatus status;
      if (delegation.deactivationEpoch == epoch) {
        deactivating += delegation.stake;
        status = DelegationStatus.deactivating;
      } else if (delegation.deactivationEpoch < epoch) {
        undelegated += delegation.stake;
        status = DelegationStatus.inactive;
      } else {
        delegated += delegation.stake;
        status = DelegationStatus.active;
      }
      accounts.add(
        DelegationInfo(
          address: programAccount.pubkey, 
          vote: delegation.voterPubkey,
          stake: lamportsToSol(delegation.stake), 
          rent: lamportsToSol(stakeAccountInfo.meta.rentExemptReserve), 
          credits: lamportsToSol(stakeAccountInfo.stake.creditsObserved),
          status: status, 
          deactivationEpoch: delegation.deactivationEpoch,
        ),
      );
    }
    this.epochInfo = epochInfo;
    this.accounts = accounts;
    return StakeInfo(
      delegated: lamportsToSol(delegated),
      undelegated: lamportsToSol(undelegated),
      deactivating: lamportsToSol(deactivating),
    );
  }
}