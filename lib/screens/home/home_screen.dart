/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import 'package:stake_pool_lotto/constants.dart';
import 'package:stake_pool_lotto/programs/stake_pool/utils.dart';
import 'package:stake_pool_lotto/screens/scaffolds/screen_scaffold.dart';
import 'package:stake_pool_lotto/widgets/views/connect_view.dart';
import 'package:stake_pool_lotto/widgets/views/stack_view.dart';
import 'package:synchronized/synchronized.dart';
import '../../icons/dream_drops_icons.dart';
import '../../layouts/grid.dart';
import '../../layouts/padding.dart';
import '../../providers/jackpot_provider.dart';
import '../../providers/provider.dart';
import '../../providers/account_balance_provider.dart';
import '../../themes/colors/color.dart';
import '../../utils/snackbar.dart';
import '../../widgets/components/jackpot.dart';
import '../../widgets/components/wallet.dart';


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
  factory SPDHomeScreen.fromJson(final Map<String, dynamic> json)
    => const SPDHomeScreen();

  /// Create an instance of the class' state widget.
  @override
  SPDHomeScreenState createState() => SPDHomeScreenState();
}


/// Home Screen State
/// ------------------------------------------------------------------------------------------------

class SPDHomeScreenState extends State<SPDHomeScreen> {

  bool _accountBalanceLock = false;

  Future<void> _onRefreshAccountBalances() async {
    try {
      if (!_accountBalanceLock) {
        _accountBalanceLock = true;
        final provider = SolanaWalletProvider.of(context);
        final notifyLevel = SPLProviderStatus.error;
        await Future.wait([
          JackpotProvider.shared.update(
            provider,
            notifyLevel: notifyLevel,
          ),
          if (provider.adapter.isAuthorized)
            AccountBalanceProvider.shared.update(
              provider, 
              notifyLevel: notifyLevel,
            ),
          ]);
      }
    } catch(error) {
      SPDSnackbar.shared.error(context, 'Failed to update balances.');
    } finally {
      _accountBalanceLock = false;
    }
  }

  Widget _devWarning() {
    return ColoredBox(
      color: SPDColor.shared.brand1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: SPDEdgeInsets.shared.symmetric(
              vertical: 2,
              horizontal: SPDGrid.x3,
            ),
            child: Text('DEMO APP RUNNING ON DEVNET', style: TextStyle(fontSize: 12, color: Colors.black),),
          ),
        ],
      ),
    );
  }

  Widget _walletBuilder(
    final BuildContext context, 
    final Account account,
  ) => SPDWallet(account: account);

  /// Builds the final widget.
  @override
  Widget build(final BuildContext context) {   
    return SPDScreenScaffold(
      onRefresh: _onRefreshAccountBalances,
      child: ColoredBox(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // _devWarning(),
            Padding(
              padding: SPDEdgeInsets.shared.vertical(),
              child: Icon(
                SPDIcons.logo,
                size: SPDGrid.x4,
                color: SPDColor.shared.brand1,
              ),
            ),
              
            SPDStackView(
              spacing: SPDGrid.x6,
              children: [
                const SPDJackpot(),
                SPDConnectView(
                  builder: _walletBuilder,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}