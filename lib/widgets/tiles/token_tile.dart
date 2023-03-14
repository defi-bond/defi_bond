/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../../extensions/text_style.dart';
import '../../layouts/grid.dart';
import '../../models/token.dart';
import '../../providers/price_provider.dart';
import '../../themes/fonts/font.dart';


/// Token Tile
/// ------------------------------------------------------------------------------------------------

class SPDTokenTile extends StatelessWidget {
  
  /// Creates a list item to display a [token]'s balance.
  const SPDTokenTile({ 
    Key? key,
    required this.title,
    required this.token,
    required this.amount,
    this.textStyle,
  }): super(key: key);

  /// The tile's title.
  final String title;

  /// The token information.
  final SPDToken token;

  /// The token amount.
  final double? amount;

  /// The text style.
  final TextStyle? textStyle;

  /// Build a row to display the given [amount].
  Widget _buildRow({
    required final String title,
    required final String amount,
    final TextStyle? textStyle,
  }) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: textStyle,
      ),
      const SizedBox(
        width: SPDGrid.x2,
      ),
      Text(
        amount,
        style: textStyle,
      ),
    ],
  );

  /// Build the final widget.
  @override
  Widget build(final BuildContext context) {
    final double? balance = amount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: SPDFont.shared.body2.medium(),
        ),
        const SizedBox(
          height: SPDGrid.x1,
        ),
        _buildRow(
          title: token.symbol, 
          amount: balance != null ? '\$${(balance * PriceProvider.shared.price).toStringAsFixed(2)}' : '-',
          textStyle: SPDFont.shared.headline2.medium(),
        ),
        const SizedBox(
          height: 2.0,
        ),
        _buildRow(
          title: token.label, 
          amount: balance != null ? '$balance ${token.symbol}' : '-',
        ),
      ],
    );
  }
}