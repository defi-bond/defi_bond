/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../tiles/list_tile.dart';
import '../../models/token.dart';
import '../../providers/price_provider.dart';
import '../../utils/format.dart';


/// Token Tile
/// ------------------------------------------------------------------------------------------------

class SPDTokenTile extends StatelessWidget {
  
  /// Creates a list item to display a [token]'s balance.
  const SPDTokenTile({ 
    super.key,
    required this.icon,
    required this.token,
    required this.amount,
    this.amountLabel,
  });

  final Widget icon;

  /// The token information.
  final SPDToken token;

  /// The token amount.
  final double? amount;

  final String? amountLabel;

  /// Build the final widget.
  @override
  Widget build(final BuildContext context) {
    final double? amount = this.amount;
    final double? balance = amount != null ? amount * PriceProvider.shared.price : null;
    return SPDListTile(
      leading: icon,
      title: Text(token.symbol),
      titleTrailing: Text(amount != null ? '${amountLabel ?? formatNumber(amount)}' : '-'),
      subtitle: Text(token.name),
      subtitleTrailing: Text(balance != null ? '\$${formatCurrency(balance)}' : '-'),
    );
  }
}