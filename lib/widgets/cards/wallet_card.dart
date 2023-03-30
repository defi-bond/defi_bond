/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import '../../extensions/text_style.dart';
import '../../icons/dream_drops_icons.dart';
import '../../layouts/grid.dart';
import '../../layouts/padding.dart';
import '../../providers/price_provider.dart';
import '../../themes/colors/color.dart';
import '../../themes/fonts/font.dart';
import '../../utils/format.dart';


/// Wallet Card
/// ------------------------------------------------------------------------------------------------

class SPDWalletCard extends StatelessWidget {

  const SPDWalletCard({
    super.key,
    required this.account,
    required this.balance,
  });

  final Account account;

  final double? balance;

  @override
  Widget build(final BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double price = PriceProvider.shared.price;
    final double? balance = this.balance;
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SPDGrid.x2),
      ),
      child: Padding(
        padding: SPDEdgeInsets.shared.card(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  '${account.label ?? "Wallet"}',
                  style: textTheme.labelMedium?.medium(),
                ),
                const SizedBox(
                  width: SPDGrid.x1,
                ),
                const Icon(
                  SPDIcons.chevrondown,
                ),
              ],
            ),
            const SizedBox(
              height: SPDGrid.x2,
            ),
            Text(
              'Total Balance',
              style: textTheme.labelLarge?.setColor(SPDColor.shared.secondary8),
            ),
            const SizedBox(
              height: SPDGrid.x1 * 0.5,
            ),
            Text(
              balance != null ? '\$${formatCurrency(balance * price)}' : '-',
              style: SPDFont.shared.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}