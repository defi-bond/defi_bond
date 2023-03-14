/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import 'package:stake_pool_lotto/layouts/padding.dart';
import 'package:stake_pool_lotto/providers/price_provider.dart';
import 'package:stake_pool_lotto/themes/colors/color.dart';
import 'package:stake_pool_lotto/widgets/buttons/primary_button.dart';
import '../../layouts/grid.dart';
import '../../models/token.dart';
import '../../navigator/navigator.dart';
import '../../providers/account_balance_provider.dart';
import '../../screens/staking/staking_screen.dart';
import '../cards/wallet_card.dart';
import '../tiles/token_tile.dart';
import '../views/stack_view.dart';


/// Wallet
/// ------------------------------------------------------------------------------------------------

class SPDWallet extends StatefulWidget {
  
  const SPDWallet({
    super.key,
  });

  @override
  State<SPDWallet> createState() => _SPDWalletState();
}


/// Wallet State
/// ------------------------------------------------------------------------------------------------

class _SPDWalletState extends State<SPDWallet> {

  void _onPressedStaking() {
    SPDNavigator.shared.push(
      context, 
      builder: (context) => const SPDStakingScreen(),
    ).ignore();
  }
  
  @override
  Widget build(final BuildContext context) {
    final SolanaWalletProvider provider = SolanaWalletProvider.of(context);
    final Account? connectedAccount = provider.connectedAccount;
    final AccountBalanceProvider accountBalanceProvider = context.watch<AccountBalanceProvider>();
    final double? solBalance = accountBalanceProvider.sol;
    final double? tokenBalance = accountBalanceProvider.token;
    final double? totalBalance = accountBalanceProvider.total;
    SPDPrimaryButton;
    return Column(
      children: [
        SolanaWalletButton(
          connectStyle: SPDPrimaryButton.defaultNoneStyle(),
          disconnectStyle: SPDPrimaryButton.defaultStyle(),
          connectBuilder: (context, account) {
            return SPDWalletCard(
              account: account,
              balance: totalBalance,
            );
          },
        ),

        if (connectedAccount != null)
          const SizedBox(
            height: SPDGrid.x4,
          ),

        if (connectedAccount != null)
          SPLStackView(
            axis: Axis.vertical,
            mainAxisSize: MainAxisSize.min,
            spacing: SPDGrid.x4,
            children: [
              SPDTokenTile(
                title: 'Available', 
                token: SPDToken.solana, 
                amount: solBalance,
              ),
              SPDTokenTile(
                title: 'Staked', 
                token: SPDToken.stakePoolDrops, 
                amount: tokenBalance,
              ),
            ],
          ),

          if (connectedAccount != null)
            const SizedBox(
              height: SPDGrid.x4,
            ),

          if (connectedAccount != null)
            SPLStackView(
              axis: Axis.vertical,
              mainAxisSize: MainAxisSize.min,
              children: [
                SPDPrimaryButton(
                  expand: false,
                  onPressed: _onPressedStaking,
                  child: const Text('Staking'), 
                ),
              ],
            ),
      ],
    );
  }
}