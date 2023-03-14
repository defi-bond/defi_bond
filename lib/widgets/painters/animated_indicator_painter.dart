/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'animated_custom_painter.dart';


/// Animated Indicator Painter
/// ------------------------------------------------------------------------------------------------

class SPDAnimatedIndicatorPainter extends SPDAnimatedCustomPainter {

  /// Draws an animated progress indicator.
  const SPDAnimatedIndicatorPainter({
    required Animation<double> animation,
    Color? color,
    this.transformValue,
    this.borderRadius,
  }): assert(transformValue == null || (transformValue >= 0.0 && transformValue <= 1.0)),
      super(
        animation: animation,
        color: color, 
        style: PaintingStyle.fill,
      );

  /// The animation value that transforms the indicator dots into a rounded rectangle.
  final double? transformValue;

  /// The indicator's corner radius when it is rendered as a rounded rectangle.
  final double? borderRadius;

  /// Return the transformation animation value.
  double get _transformValue {
    return transformValue ?? 0.0;
  }

  /// Return a copy of `this` instance, replacing the current values with the given values.
  /// @params [*]: Optional values to overwrite the existing properties.
  @override
  SPDAnimatedIndicatorPainter copyWith({ final Color? color, final double? strokeWidth }) {
    return SPDAnimatedIndicatorPainter(
      animation: animation,
      color: color ?? this.color,
      transformValue: transformValue,
      borderRadius: borderRadius,
    );
  }

  /// Build the top-left indicator dot for the current animation frame.
  /// @param [size]: The canvas size.
  /// @param [value]: The transform animation value.
  RRect _buildRect({ required Size size, required double value }) {

    final double maxDiameter = size.shortestSide;
    final double minRadius = (maxDiameter * 0.208333).roundToDouble();
    final double maxRadius = borderRadius ?? (maxDiameter * 0.333333).roundToDouble();
    final double radius = minRadius + (maxRadius - minRadius) * value;

    final double minDiameter = minRadius * 2.0;
    final double width = minDiameter + (size.width - minDiameter) * value;
    final double height = minDiameter + (size.height - minDiameter) * value;

    final Rect rect = Rect.fromLTWH(0.0, 0.0, width, height);
    return RRect.fromRectXY(rect, radius, radius);
  }

  /// Draw the widget's content for the current frame on the canvas.
  /// @param [canvas]: The drawing canvas.
  /// @param [size]: The canvas size.
  @override
  void paint(Canvas canvas, Size size) {

    final RRect rRect = _buildRect(size: size, value: _transformValue);
    final double xTranslation = size.width - rRect.width;
    final double yTranslation = size.height - rRect.height;
    final double xOffset = animation.value * xTranslation;
    final double yOffset = animation.value * yTranslation;

    final Paint paint = painter();
    canvas.drawRRect(rRect.shift(Offset(xOffset, 0.0)), paint);
    canvas.drawRRect(rRect.shift(Offset(0.0, yTranslation - yOffset)), paint);
    canvas.drawRRect(rRect.shift(Offset(xTranslation - xOffset, yTranslation)), paint);
    canvas.drawRRect(rRect.shift(Offset(xTranslation, yOffset)), paint);
  }

  /// Redraw the widget each time the [transformValue] changes.
  /// @param [oldDelegate]: The widget's previous state.
  @override
  bool shouldRepaint(covariant SPDAnimatedIndicatorPainter oldDelegate) {
    return super.shouldRepaint(oldDelegate) 
      || transformValue != oldDelegate.transformValue;
  }
}