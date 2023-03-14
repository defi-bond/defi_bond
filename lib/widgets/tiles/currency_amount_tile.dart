/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../../widgets/tiles/amount_tile.dart';


/// Currency Amount Tile
/// ------------------------------------------------------------------------------------------------

class SPLCurrencyAmountTile extends StatelessWidget {

  const SPLCurrencyAmountTile({
    super.key,
    required this.label,
    required this.amount,
    this.textStyle,
  });

  final String label;

  final int amount;

  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return SPDAmountTile(
      label: label, 
      amount: '\$$amount',
      textStyle: textStyle,
    );
  }
}