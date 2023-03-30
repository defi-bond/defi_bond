/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../../icons/dream_drops_icons.dart';
import '../../layouts/grid.dart';
import '../../themes/colors/color.dart';


/// Logo
/// ------------------------------------------------------------------------------------------------

class SPDLogo extends StatelessWidget {
  
  const SPDLogo({
    super.key,
    this.size = SPDGrid.x3,
  });

  final double? size;

  @override
  Widget build(final BuildContext context) => Icon(
    SPDIcons.logofill,
    size: SPDGrid.x3,
    color: SPDColor.shared.brand,
  );
}