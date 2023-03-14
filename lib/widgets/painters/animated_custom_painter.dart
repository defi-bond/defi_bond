/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'custom_painter.dart';


/// Animated Custom Paint
/// ------------------------------------------------------------------------------------------------

abstract class SPDAnimatedCustomPainter extends SPDCustomPainter {

  /// A wrapper around [SPDCustomPainter] with predefined properties and methods for performing 
  /// drawing animations.
  const SPDAnimatedCustomPainter({
    required this.animation,
    Color? color,
    double? strokeWidth, 
    PaintingStyle? style,
  }): super(
        repaint: animation,
        color: color,
        strokeWidth: strokeWidth,
        style: style,
      );

  /// The drawing animation.
  final Animation<double> animation;

  /// Return a [CurvedAnimation] instance for the defined duration ([begin] and [end]).
  /// @param [begin]: The interval's start time.
  /// @param [end]: The interval's end time.
  /// @param [curve]: The animation curve.
  CurvedAnimation curvedAnimation(
    final double begin, 
    final double end, { 
    final Curve curve = Curves.linear,
  }) {
    return CurvedAnimation(
      parent: animation, 
      curve: Interval(begin, end, curve: curve),
    );
  }
}