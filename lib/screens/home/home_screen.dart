/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import 'package:stake_pool_lotto/programs/lotto/program.dart';
import 'package:stake_pool_lotto/programs/lotto/state.dart';
import 'package:synchronized/synchronized.dart';
import '../../layouts/grid.dart';
import '../../layouts/padding.dart';
import '../../providers/jackpot_provider.dart';
import '../../widgets/components/jackpot.dart';
import '../../widgets/components/wallet.dart';
import '../../providers/provider.dart';
import '../../providers/account_balance_provider.dart';
import '../../utils/snackbar.dart';


/// Home Screen
/// ------------------------------------------------------------------------------------------------

class SPDHomeScreen extends StatefulWidget {
  
  const SPDHomeScreen({ 
    super.key,
  });

  /// Navigator route name.
  static const String routeName = '/home/home';

  /// Serialise this class into a json object.
  Map<String, dynamic> toJson() => {};

  /// Create an instance of this class from the given json object.
  /// @param [json]: A map containing the class' constructor parameters.
  factory SPDHomeScreen.fromJson(Map<String, dynamic> json)
    => const SPDHomeScreen();

  /// Create an instance of the class' state widget.
  @override
  SPDHomeScreenState createState() => SPDHomeScreenState();
}


/// Home Screen State
/// ------------------------------------------------------------------------------------------------

class SPDHomeScreenState extends State<SPDHomeScreen> {

  final Lock tokenBalanceLock = Lock();

  Future<void> _onRefreshTokenBalances() async {
    try {
      if (!tokenBalanceLock.inLock) {
        final provider = SolanaWalletProvider.of(context);
        await tokenBalanceLock.synchronized(
          () => Future.wait([
            JackpotProvider.shared.update(
              provider,
              notifyLevel: SPLProviderStatus.error,
            ),
            AccountBalanceProvider.shared.update(
              provider, 
              notifyLevel: SPLProviderStatus.error,
            ),
          ]),
        );
      }
    } catch(error) {
      SPLSnackbar.shared.error(context, 'Failed to update balances.');
    }
  }

  /// Build the final widget.
  /// @param [context]: The current build context.
  @override
  Widget build(BuildContext context) {    
    return RefreshIndicator(
      onRefresh: _onRefreshTokenBalances,
      child: SafeArea(
        child: Padding(
          padding: SPDEdgeInsets.shared.symmetric(
            vertical: SPDGrid.x3,
            horizontal: SPDGrid.x3,
          ),
          child: Center(
            child: ScrollConfiguration(
              behavior: MaterialScrollBehavior().copyWith(overscroll: false),
              child: ListView(
                shrinkWrap: true,
                children: [

                  TextButton(onPressed: () {
                    final x = LottoProgram.findATA(LottoSeed.fee);
                    print('FEE ATA = ${x.publicKey}');
                  }, child: Text('Fee Ata')),
                  const SPDJackpot(),
                  const SizedBox(
                    height: SPDGrid.x4,
                  ),
                  SPDWallet(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}