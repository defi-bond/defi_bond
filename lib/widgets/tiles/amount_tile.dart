/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../../layouts/grid.dart';


/// Amount Tile
/// ------------------------------------------------------------------------------------------------

class SPDAmountTile extends StatelessWidget {

  const SPDAmountTile({
    super.key,
    required this.label,
    required this.amount,
    this.textStyle,
  });

  final String label;

  final String amount;

  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
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
  }
}