/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart' show Brightness, Color, ColorSwatch;


/// Status Colour
/// ------------------------------------------------------------------------------------------------

class SPLStatusColor extends ColorSwatch<int> {

  /// Create a [ColorSwatch] for the application's status colours.
  /// @param [primary]: The default colour value.
  /// @param [swatch]: The colour shades.
  const SPLStatusColor(
    int primary, 
    Map<int, Color> swatch,
  ): super(primary, swatch);

  /// Create an [SPLStatusColor] swatch for the given theme.
  /// @param [brightness]: The theme to create the swatch for.
  factory SPLStatusColor.apply(final Brightness brightness) {
    return brightness == Brightness.dark 
      ? SPLStatusColor.dark() 
      : SPLStatusColor.light();
  }

  /// Create an [SPLStatusColor] swatch for the application's dark theme.
  factory SPLStatusColor.dark() {
    return const SPLStatusColor(
      0xFFFFFFFF, {
      1: Color(0xFF33FFFF),
      2: Color(0xFFFFDD33),
      3: Color(0xFFFF3355),
      4: Color(0xFF33FF99),
    });
  }

  /// Create an [SPLStatusColor] swatch for the application's light theme.
  factory SPLStatusColor.light() {
    return const SPLStatusColor(
      0xFF000000, {
      1: Color(0xFF2EE8E8),
      2: Color(0xFFE8C92E),
      3: Color(0xFFE82E4D),
      4: Color(0xFF2EE88B),
    });
  }

  /// The information status colour. 
  Color get information => this[1]!;

  /// The warning status colour.
  Color get warning => this[2]!;

  /// The error status colour.
  Color get error => this[3]!;

  /// The success status colour.
  Color get success => this[4]!;
}