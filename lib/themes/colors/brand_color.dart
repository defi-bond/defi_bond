/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart' show Brightness, Color, ColorSwatch;


/// Brand Color
/// ------------------------------------------------------------------------------------------------

class SPDBrandColor extends ColorSwatch<int> {

  /// Create a [ColorSwatch] for the application's brand colours.
  /// @param [primary]: The default colour value.
  /// @param [swatch]: The colour shades.
  const SPDBrandColor(
    int primary, 
    Map<int, Color> swatch,
  ): super(primary, swatch);

  /// Create an [SPDBrandColor] swatch for the given theme.
  /// @param [brightness]: The theme to create the swatch for.
  factory SPDBrandColor.apply(final Brightness brightness) {
    return brightness == Brightness.dark 
      ? SPDBrandColor.dark() 
      : SPDBrandColor.light();
  }

  /// Create an [SPDBrandColor] swatch for the application's dark theme.
  factory SPDBrandColor.dark() {
    return const SPDBrandColor(
      0xFF66FFED, {
      1: Color(0xFF66FFED),
    });
  }

  /// Create an [SPDBrandColor] swatch for the application's light theme.
  factory SPDBrandColor.light() {
    return const SPDBrandColor(
      0xFF66FFED, {
      1: Color(0xFF66FFED),
    });
  }

  /// The lightest shade. 
  Color get shade1 => this[1]!;
}