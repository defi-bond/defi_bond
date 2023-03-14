/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:async';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import '../exceptions/exception.dart';
import '../programs/lotto/program.dart';
import '../programs/lotto/state.dart';
import '../providers/provider.dart';
import '../storage/storage_key.dart';


/// Jackpot Info
/// ------------------------------------------------------------------------------------------------

class JackpotInfo extends Serializable {

  const JackpotInfo({
    required this.solBalance,
    required this.tokenBalance,
  });

  final double solBalance;
  
  final double tokenBalance;
  
  factory JackpotInfo.fromJson(final Map<String, dynamic> json) => JackpotInfo(
    solBalance: json['solBalance'],
    tokenBalance: json['tokenBalance'],
  );

  @override
  Map<String, dynamic> toJson() => {
    'solBalance': solBalance,
    'tokenBalance': tokenBalance,
  };

  JackpotInfo copyWith({
    final double? solBalance,
    final double? tokenBalance,
  }) => JackpotInfo(
    solBalance: solBalance ?? this.solBalance,
    tokenBalance: tokenBalance ?? this.tokenBalance,
  );
}

/// Jackpot Provider
/// ------------------------------------------------------------------------------------------------

class JackpotProvider extends SPLProvider<JackpotInfo> {

  /// Jackpot information provider.
  JackpotProvider._();

  /// Singleton instance.
  static final JackpotProvider shared = JackpotProvider._();

  @override
  String get storageKey => SPDStorageKey.jackpotInfo;
  
  @override
  JackpotInfo Function(Map<String, dynamic>) get decoder => JackpotInfo.fromJson;

  /// ATA account.
  ProgramAddress get ataAccountAddress => LottoProgram.findATA(LottoSeed.jackpot);

  /// ATA token balance.
  double get tokenBalance => value?.tokenBalance ?? 0.0;

  @override
  Future<JackpotInfo> fetch(final SolanaWalletProvider provider) async {
    final Connection connection = provider.connection;
    final AccountInfo? ataAccountInfo = await connection.getAccountInfo(
      ataAccountAddress.publicKey,
    );
    if (ataAccountInfo == null) {
      throw const SPDException('Failed to load jackpot data.');
    }
    final TokenAccountInfo ataTokenAccountInfo = TokenAccountInfo.fromAccountInfo(ataAccountInfo);
    return JackpotInfo(
      solBalance: lamportsToSol(ataAccountInfo.lamports.toBigInt()),
      tokenBalance: lamportsToSol(ataTokenAccountInfo.amount),
    );
  }
}