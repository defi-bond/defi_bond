/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../../layouts/grid.dart';
import '../../themes/colors/color.dart';


/// Stake Account Logo
/// ------------------------------------------------------------------------------------------------

class SPDStakeAccountLogo extends StatelessWidget {
  
  const SPDStakeAccountLogo({
    super.key,
    this.size = SPDGrid.x3,
  });

  final double? size;

  @override
  Widget build(final BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: SPDColor.shared.brand,
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Text(
        'S',
        style: TextStyle(
          fontSize: 12,
          color: SPDColor.shared.primary,
        ),
      ),
    ),
  );
}