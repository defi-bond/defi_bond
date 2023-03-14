/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:ui';
import 'custom_painter.dart';


/// Cross Painter
/// ------------------------------------------------------------------------------------------------

class SPDCrossPainter extends SPDCustomPainter {

  /// Draws a cross icon (X).
  const SPDCrossPainter({
    Color? color,
    double? strokeWidth,
  }): super(
        color: color, 
        strokeWidth: strokeWidth,
      );

  /// Return a copy of `this` instance, replacing the current values with the given values.
  /// @params [*]: Optional values to overwrite the existing properties.
  @override
  SPDCrossPainter copyWith({ Color? color, double? strokeWidth }) {
    return SPDCrossPainter(
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth, 
    );
  }

  /// Draw the widget's content on the canvas.
  /// @param [canvas]: The drawing canvas.
  /// @param [size]: The canvas size.
  @override
  void paint(Canvas canvas, Size size) {

    final Rect rect = this.rect(size);
    
    final Path path = Path()
      ..moveTo(rect.topLeft.dx, rect.topLeft.dy)
      ..lineTo(rect.bottomRight.dx, rect.bottomRight.dy)
      ..moveTo(rect.topRight.dx, rect.topRight.dy)
      ..lineTo(rect.bottomLeft.dx, rect.bottomLeft.dy);

    canvas.drawPath(path, painter());
  }
}