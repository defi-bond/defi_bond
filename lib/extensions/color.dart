/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:math' show min, max;
import 'package:flutter/material.dart' show Color;


/// [Color] Extensions
/// ------------------------------------------------------------------------------------------------

extension SPDColorExtension on Color {

  /// Returns the colour's luminance value (range: 0.0 to 255.0).
  double get luminance {
    return (0.2126 * red) + (0.7152 * green) + (0.0722 * blue);
  }

  /// Returns the colour's brightness value (range: 0 to 100) - i.e. the luminance value clamped 
  /// between the range of 0 to 100.
  int get brightness {
    return (100 * (luminance / 255.0)).round();
  }

  /// Returns a copy of this colour with its brightness value decreased by [value].
  Color darken([final int value = 10]) {
    return withBrightness(max(0, brightness - value));
  }

  /// Returns a copy of this colour with its brightness value increased by [value].
  Color lighten([final int value = 10]) {
    return withBrightness(min(100, brightness + value));
  }

  /// Returns a copy of this colour with its brightness value set to [value].
  Color withBrightness(final int value) {
    assert(value >= 0 && value <= 100);
    final double multiplier = value / max(1, brightness);
    final int r = (red   * multiplier).round().clamp(0, 255);
    final int g = (green * multiplier).round().clamp(0, 255);
    final int b = (blue  * multiplier).round().clamp(0, 255);
    return Color.fromARGB(alpha, r, g, b);
  }
}