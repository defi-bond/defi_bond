/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import '../constants.dart';
import '../providers/provider.dart';
import '../storage/storage_key.dart';


/// Account Balance Info
/// ------------------------------------------------------------------------------------------------

class AccountBalanceInfo extends Serializable {

  /// Account balances.
  const AccountBalanceInfo(
    this.sol, 
    this.token,
  );

  /// Solana token balance.
  final double sol;

  /// Pool token balance.
  final double token;
  
  factory AccountBalanceInfo.fromJson(
    final Map<String, dynamic> json,
  ) => AccountBalanceInfo(
    json['sol'],
    json['token'],
  );
  
  @override
  Map<String, dynamic> toJson() => {
    'sol': sol,
    'token': token,
  };
}


/// Account Balance Provider
/// ------------------------------------------------------------------------------------------------

class AccountBalanceProvider extends SPLProvider<AccountBalanceInfo> {

  AccountBalanceProvider._();

  static final AccountBalanceProvider shared = AccountBalanceProvider._();

  double? get sol => value?.sol;

  double? get token => value?.token;

  double? get total {
    final double? sol = this.sol;
    final double? token = this.token;
    return sol != null && token != null ? sol + token : null;
  }

  @override
  String get storageKey => SPDStorageKey.tokenBalanceValue;
  
  @override
  AccountBalanceInfo Function(Map<String, dynamic>) get decoder => AccountBalanceInfo.fromJson;

  @override
  Future<AccountBalanceInfo> fetch(final SolanaWalletProvider provider) async {
    final Connection connection = provider.connection;
    final PublicKey? connectedAccount = provider.connectedAccount?.toPublicKey();
    if (connectedAccount == null) throw Exception('[AccountBalanceProvider] No connected account.');
    final List<AccountInfo?> accountInfos = await connection.getMultipleAccounts([
      connectedAccount,
      associatedTokenAddress(connectedAccount).publicKey
    ]);
    final AccountInfo? solAccountInfo = accountInfos[0];
    final TokenAccountInfo? tokenAccountInfo = TokenAccountInfo.tryFromAccountInfo(accountInfos[1]);
    print('TOKEN BALANCE INFO ${tokenAccountInfo?.toJson()}');
    return AccountBalanceInfo(
      lamportsToSol(solAccountInfo?.lamports.toBigInt() ?? BigInt.zero), 
      lamportsToSol(tokenAccountInfo?.amount ?? BigInt.zero), 
    );
  }
}