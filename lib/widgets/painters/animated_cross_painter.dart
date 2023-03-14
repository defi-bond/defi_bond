/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'animated_custom_painter.dart';


/// Animated Cross Painter
/// ------------------------------------------------------------------------------------------------

class SPDAnimatedCrossPainter extends SPDAnimatedCustomPainter {

  /// Draws an animated cross icon (X).
  SPDAnimatedCrossPainter({
    required Animation<double> animation,
    Color? color,
    double? strokeWidth,
  }): super(
        animation: animation,
        color: color, 
        strokeWidth: strokeWidth,
      ) {
        _line0Animation = curvedAnimation(0.0, 0.5);
        _line1Animation = curvedAnimation(0.5, 1.0);
      }

  /// The animation for drawing the first diagonal line (\).
  late Animation<double> _line0Animation;

  /// The animation for drawing the second diagonalline (/).
  late Animation<double> _line1Animation;

  /// Return a copy of `this` instance, replacing the current values with the given values.
  /// @params [*]: Optional values to overwrite the existing properties.
  @override
  SPDAnimatedCrossPainter copyWith({ final Color? color, final double? strokeWidth }) {
    return SPDAnimatedCrossPainter(
      animation: animation,
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth, 
    );
  }

  /// Draw the widget's content for the current frame on the canvas.
  /// @param [canvas]: The drawing canvas.
  /// @param [size]: The canvas size.
  @override
  void paint(final Canvas canvas, final Size size) {

    final Rect rect = this.rect(size);
    final Offset line0 = this.linePoint(rect.topLeft, rect.bottomRight, _line0Animation.value);
    final Offset line1 = this.linePoint(rect.topRight, rect.bottomLeft, _line1Animation.value);
    
    final Path path = Path();

    if (line0 != rect.topLeft) {
      path..moveTo(rect.topLeft.dx, rect.topLeft.dy)
          ..lineTo(line0.dx, line0.dy);
    }

    if (line1 != rect.topRight) {
      path..moveTo(rect.topRight.dx, rect.topRight.dy)
          ..lineTo(line1.dx, line1.dy);
    }

    canvas.drawPath(path, painter());
  }
}