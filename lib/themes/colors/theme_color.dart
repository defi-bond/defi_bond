/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart' show Brightness, Color, ColorSwatch;


/// Theme Colour
/// ------------------------------------------------------------------------------------------------

class SPLThemeColor extends ColorSwatch<int> {

  /// Create a [ColorSwatch] for the application's theme.
  /// @param [primary]: The default colour value.
  /// @param [swatch]: The colour shades.
  const SPLThemeColor(
    int primary, 
    Map<int, Color> swatch,
  ): super(primary, swatch);
  
  /// Create an [SPLThemeColor] swatch for the given theme.
  /// @param [brightness]: The theme to create the swatch for.
  factory SPLThemeColor.apply(final Brightness brightness) {
    return brightness == Brightness.dark 
      ? SPLThemeColor.dark() 
      : SPLThemeColor.light();
  }

  /// Create an [SPLThemeColor] swatch for the application's dark theme.
  factory SPLThemeColor.dark() {
    return const SPLThemeColor(
      0xFF1E1E1F, {
      1: Color(0xFF1E1E1F),
      2: Color(0xFF2D2D2E),
      3: Color(0xFF343536),
      4: Color(0xFF3C3C3D),
      5: Color(0xFF434445),
      6: Color(0xFF4B4C4D),
      7: Color(0xFF5B5F63),
      8: Color(0xFF71757A),
    });
  }

  /// Create an [SPLThemeColor] swatch for the application's light theme.
  factory SPLThemeColor.light() {
    return const SPLThemeColor(
      0xFFFFFFFF, {
      1: Color(0xFFFFFFFF),
      2: Color(0xFFF5F7FA),
      3: Color(0xFFEDEFF2),
      4: Color(0xFFE6E8EB),
      5: Color(0xFFDEE0E3),
      6: Color(0xFFD7D9DB),
      7: Color(0xFFB5BBC4),
      8: Color(0xFFA0A5AD),
    });
  }

  /// The lightest shade (when light theme) or darkest shade (when dark theme). 
  Color get shade1 => this[1]!;

  /// The second lightest shade (when light theme) or second darkest shade (when dark theme). 
  Color get shade2 => this[2]!;

  /// The third lightest shade (when light theme) or third darkest shade (when dark theme).
  Color get shade3 => this[3]!;

  /// The fourth lightest shade (when light theme) or fourth darkest shade (when dark theme).
  Color get shade4 => this[4]!;

  /// The fifth lightest shade (when light theme) or fifth darkest shade (when dark theme). 
  Color get shade5 => this[5]!;

  /// The sixth lightest shade (when light theme) or sixth darkest shade (when dark theme). 
  Color get shade6 => this[6]!;

  /// The seventh lightest shade (when light theme) or seventh darkest shade (when dark theme). 
  Color get shade7 => this[7]!;

  /// The darkest shade (when light theme) or lightest shade (when dark theme). 
  Color get shade8 => this[8]!;
}