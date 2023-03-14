/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:math' show sin, cos;
import 'package:flutter/material.dart';
import '../../layouts/line_weight.dart';
import '../../themes/colors/color.dart';


/// Custom Paint
/// ------------------------------------------------------------------------------------------------

abstract class SPDCustomPainter extends CustomPainter {

  /// A wrapper around [CustomPainer] with predefined properties and methods.
  const SPDCustomPainter({
    this.color,
    this.repaint,
    double? strokeWidth, 
    this.style,
  }): strokeWidth = strokeWidth ?? SPDLineWeight.w1,
      super(repaint: repaint);

  /// The [painter]'s default color.
  final Color? color;

  /// The drawing animation.
  final Animation<double>? repaint;

  /// The [painter]'s default stroke width.
  final double strokeWidth;

  /// The [painter]'s default style.
  final PaintingStyle? style;

  /// Return a copy of `this` instance, replacing the current values with the given values.
  /// @params [*]: Optional values to overwrite the existing properties.
  SPDCustomPainter copyWith({ Color? color, double? strokeWidth });

  /// Return a [Rect] for the given [size].
  /// @param [size]: The size of the returned [Rect].
  /// @param [origin]: The top-left corner of the returned [Rect] (default: `(0,0)`).
  Rect rect(Size size, { Offset origin = Offset.zero }) {
    return origin & size;
  }

  /// Return a [Paint] instance with
  Paint painter() {
    return Paint()
      ..color = color ?? SPDColor.shared.brand
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = style ?? PaintingStyle.stroke;
  }

  /// Return the point between [start] and [end] at the given [time] (range: [0:1]).
  /// @param [start]: The start point.
  /// @param [end]: The end point.
  /// @param [time]: The time value between 0 and 1.
  Offset linePoint(Offset start, Offset end, double time) {
    return start + ((end - start) * time);
  }

  /// Return the point relative to [anchor] for the given [angle] and [length].
  /// @param [anchor]: The reference point.
  /// @param [angle]: The angle in `radians` relative to [point].
  /// @param [length]: The distance relative to [point].
  Offset relativePoint(Offset anchor, { required double angle, required double length }) {
    return Offset(length * sin(angle) + anchor.dx, length * cos(angle) + anchor.dy);
  }

  /// Return the point on the circle's circumference at the given [angle].
  /// @param [radius]: The circle's radius.
  /// @param [angle]: The angle in `radians` relative to the circle's top-centre point.
  /// @param [origin]: The top-left anchor point of the circle (default: `(0,0)`).
  Offset circlePoint(double radius, double angle, { Offset origin = Offset.zero }) {

    /// The starting point translated around the centre (radius, radius). The starting point is the
    /// top-centre point of the circle (radius, 0.0), therefore, the starting points translated
    /// arounds the centre point = (radius, 0.0) - (radius, radius).
    const double px = 0.0;
    final double py = -radius;

    /// Rotate the points.
    final double s = sin(angle);
    final double c = cos(angle);
    final double x = px * c - py * s;
    final double y = px * s + py * c;

    /// Translate the points back around the origin.
    return Offset(x + radius + origin.dx, y + radius + origin.dy);
  }

  /// Return the 2D rotation matrix for the given [angle].
  /// @param [angle]: The angle in `radians`.
  /// @param [origin]: The top-left anchor point of the object being rotated (default: `(0,0)`).
  Matrix4 rotate(double angle, { Offset origin = Offset.zero }) {
    
    if (angle == 0.0) {
      return Matrix4.identity();
    }

    if (origin == Offset.zero) {
      return Matrix4.rotationZ(angle);
    }

    return Matrix4.identity()
      ..translate(origin.dx, origin.dy)
      ..multiply(Matrix4.rotationZ(angle))
      ..translate(-origin.dx, -origin.dy);
  }

  /// Return `true` if the widget should be redrawn (default: `false`).
  /// @param [oldDelegate]: The widget's previous state.
  @override
  bool shouldRepaint(covariant SPDCustomPainter oldDelegate) => false;
}