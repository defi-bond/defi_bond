/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import 'package:stake_pool_lotto/widgets/buttons/tertiary_button.dart';
import '../cards/wallet_card.dart';
import '../tiles/token_tile.dart';
import '../views/stack_view.dart';
import '../../layouts/grid.dart';
import '../../models/token.dart';
import '../../providers/account_balance_provider.dart';
import '../../providers/stake_provider.dart';
import '../../widgets/components/logo.dart';
import '../../widgets/components/section.dart';
import '../../widgets/components/solana_logo.dart';


/// Wallet
/// ------------------------------------------------------------------------------------------------

class SPDWallet extends StatelessWidget {
  
  const SPDWallet({
    super.key,
    required this.account,
  });

  final Account account;

  @override
  Widget build(final BuildContext context) {
    final AccountBalanceProvider accountBalanceProvider = context.watch<AccountBalanceProvider>();
    final StakeProvider stakeProvider = context.watch<StakeProvider>();
    final double? solBalance = accountBalanceProvider.sol;
    final double? tokenBalance = accountBalanceProvider.token;
    final double? stakeBalance = stakeProvider.total;
    final double? total = solBalance != null || tokenBalance != null || stakeBalance != null
      ? ((solBalance ?? 0) + (tokenBalance ?? 0) + (stakeBalance ?? 0)) : null;
    return Column(
      children: [
        SolanaWalletButton(
          connectedStyle: SPDTertiaryButton.styleFrom(),
          connectedBuilder: (context, account) => SPDWalletCard(
            account: account, 
            balance: total,
          ),
        ),
        SizedBox(
          height: SPDGrid.x6,
        ),
        SPDStackView(
          mainAxisSize: MainAxisSize.min,
          spacing: SPDGrid.x4,
          children: [
            SPDSection(
              title: Text('Available'),
              child: SPDTokenTile(
                icon: SPDSolanaLogo(),
                token: SPDToken.solana, 
                amount: solBalance,
              ),
            ),
            SPDSection(
              title: Text('Staked'),
              child: Column(
                children: [
                  SPDTokenTile(
                    icon: SPDLogo(),
                    token: SPDToken.drop, 
                    amount: tokenBalance,
                  ),
                  const SizedBox(
                    height: SPDGrid.x2,
                  ),
                  SPDTokenTile(
                    icon: SPDSolanaLogo(),
                    token: SPDToken.solana, 
                    amount: stakeBalance,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}