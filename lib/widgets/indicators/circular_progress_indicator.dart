/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../../layouts/grid.dart';
import '../../layouts/line_weight.dart';
import '../../themes/colors/color.dart';


/// Circular Progress Indicator
/// ------------------------------------------------------------------------------------------------

class SPDCircularProgressIndicator extends StatelessWidget {

  /// Creates a circular progress indicator.
  const SPDCircularProgressIndicator({
    super.key,
    this.colour,
    this.radius,
    this.strokeWidth = SPDLineWeight.w1,
    this.value,
  });

  /// The line colour (default: [SPDColor.shared.brand]).
  final Color? colour;

  /// The indicator's radius (default: [SPDGrid.x3]).
  final double? radius;

  /// The line width (default: [SPDLineWeight.w1]).
  final double strokeWidth;

  /// A value between 0.0 and 1.0 that defines the amount of progress. If `null`, the indicator 
  /// spins continuously.
  final double? value;

  /// Build the final widget.
  /// @param [context]: The current build context.
  @override
  Widget build(BuildContext context) {
    final double strokeWidthRadius = strokeWidth * 0.5;
    final double radius = this.radius ?? SPDGrid.x3;
    return Center(
      child: SizedBox.fromSize(
        size: Size.fromRadius(radius - strokeWidthRadius),
        child: CircularProgressIndicator(
          value: value,
          strokeWidth: strokeWidth,
          color: colour ?? SPDColor.shared.brand,
          backgroundColor: SPDColor.shared.primary,
        ),
      ),
    );
  }
}