/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../../layouts/grid.dart';
import '../../layouts/line_weight.dart';
import '../../themes/colors/color.dart';


/// Refresh Indicator
/// ------------------------------------------------------------------------------------------------

class SPLRefreshIndicator extends RefreshIndicator {

  /// A wrapper around [RefreshIndicator] to set default styling.
  SPLRefreshIndicator({ 
    Key? key,
    required Widget child,
    double displacement = SPDGrid.x1 * 2.0,
    required RefreshCallback onRefresh,
    Color? colour,
    Color? backgroundColour,
    double strokeWidth = SPDLineWeight.w1,
  }): super(
        key: key,
        child: child,
        displacement: displacement,
        onRefresh: onRefresh,
        color: colour ?? SPDColor.shared.brand1,
        backgroundColor: colour ?? SPDColor.shared.primary1,
        strokeWidth: strokeWidth,
      );
}