/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:math' show pi;


/// Radian
/// ------------------------------------------------------------------------------------------------

class SPDRadian {

  /// Provides properties and methods for converting degrees to radians.
  const SPDRadian._();

  /// The [SPDRadian] class' singleton instance.
  static const shared = SPDRadian._();

  /// Return 45 degrees in radians.
  static double get r45  => pi * 0.25;

  /// Return 90 degrees in radians.
  static double get r90  => pi * 0.50;

  /// Return 180 degrees in radians.
  static double get r180 => pi;

  /// Return 270 degrees in radians.
  static double get r270 => pi * 1.50;

  /// Return 360 degrees in radians.
  static double get r360 => pi * 2.00;

  /// Convert radians to degrees.
  /// @param [radians]: The value in radians.
  double degrees(double radians) {
    return radians * 180 / pi;
  }

  /// Convert degrees to radians.
  /// @param [degrees]: The value in degrees.
  double radians(double degrees) {
    return degrees * pi / 180;
  }
}