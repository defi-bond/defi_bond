/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import 'package:stake_pool_lotto/themes/colors/color.dart';
import '../../extensions/text_style.dart';
import '../../icons/stake_pool_drops_icons.dart';
import '../../layouts/grid.dart';
import '../../layouts/padding.dart';
import '../../themes/fonts/font.dart';


/// Wallet Card
/// ------------------------------------------------------------------------------------------------

class SPDWalletCard extends StatefulWidget {

  const SPDWalletCard({
    super.key,
    required this.account,
    required this.balance,
  });

  final Account account;

  final double? balance;

  @override
  State<SPDWalletCard> createState() => _SPDWalletCardState();
}


/// Wallet Card State
/// ------------------------------------------------------------------------------------------------

class _SPDWalletCardState extends State<SPDWalletCard> {

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: SPDEdgeInsets.shared.card(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  '${widget.account.label ?? "Wallet"}',
                ),
                const SizedBox(
                  width: SPDGrid.x1,
                ),
                Icon(
                  SPDIcons.chevrondown,
                  size: SPDGrid.x2,
                  color: SPDColor.shared.font,
                ),
              ],
            ),
            const SizedBox(
              height: SPDGrid.x2,
            ),
            Text('Total Balance'),
            const SizedBox(
              height: 2.0,
            ),
            Text(
              widget.balance != null ? '\$${widget.balance}' : '-',
              style: SPDFont.shared.headline2.medium(),
            ),
          ],
        ),
      ),
    );
  }
}