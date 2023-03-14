/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:stake_pool_lotto/widgets/tiles/amount_tile.dart';


/// Token Amount Tile
/// ------------------------------------------------------------------------------------------------

class SPLTokenAmountTile extends StatelessWidget {

  const SPLTokenAmountTile({
    super.key,
    required this.label,
    required this.amount,
    required this.symbol,
    this.textStyle,
  });

  final String label;

  final int amount;

  final String symbol;

  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return SPDAmountTile(
      label: label, 
      amount: '$amount $symbol',
      textStyle: textStyle,
    );
  }
}