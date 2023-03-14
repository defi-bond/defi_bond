/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../colors/color.dart';


/// Font
/// ------------------------------------------------------------------------------------------------

class SPDFont {

  /// Defines the fonts and styles used by the application.
  const SPDFont._();

  /// The [SPDFont] class' singleton instance.
  static const SPDFont shared = SPDFont._();

  /// The application's main font family.
  final String fontFamily = 'Gilroy';

  /// The main font's adjusted height to vertically align text without any descenders (i.e. letters 
  /// that extend beyond the baseline).
  final double adjustedHeight = 1.1;

  /// The application's monospaced font family.
  final String monoFontFamily = 'Roboto';

  /// Return the application's largest headline font style.
  TextStyle get headline1 => bold(28.0);

  /// Return the application's second largest headline font style.
  TextStyle get headline2 => bold(24.0);

  /// Return the application's third largest headline font style.
  TextStyle get headline3 => bold(20.0);

  /// Return the application's fourth largest headline font style.
  TextStyle get headline4 => bold(18.0);

  /// Return the application's fifth largest headline font style.
  TextStyle get headline5 => bold(16.0);

  /// Return the application's largest body font style.
  TextStyle get body1 => regular(18.0);

  /// Return the application's second largest body font style.
  TextStyle get body2 => regular(16.0);

  /// Return the application's third largest body font style.
  TextStyle get body3 => regular(14.0);

  /// Return the application's fourth largest body font style.
  TextStyle get body4 => regular(12.0);

  /// Return the application's fifth largest body font style.
  TextStyle get body5 => regular(10.0);

  /// Return the application's smallest body font style.
  TextStyle get body6 => regular(8.0);

  /// Return the application's button font style.
  TextStyle get button => medium(16.0);

  /// Create a [TextStyle] instance from the given parameters.
  /// @param [size]: The font size.
  /// @param [color]?: The font color (default: [SPDColor.shared.secondary1]).
  /// @param [family]?: The font family name (default: `[fontFamily]`).
  /// @param [weight]?: The font weight (default: [FontWeight.w400]).
  TextStyle style(
    double size, { 
    Color? color, 
    String? family, 
    FontWeight? weight,
  }) {
    return TextStyle(
      fontSize: size,
      color: color ?? SPDColor.shared.font,
      fontFamily: family ?? fontFamily,
      fontWeight: weight ?? FontWeight.w400,
    );
  }

  /// Create a [TextStyle] instance with a `regular` font weight ([FontWeight.w400]).
  /// @param [size]: The font size.
  /// @param [color]?: The font color (default: [SPDColor.shared.secondary1]).
  TextStyle regular(double size, { Color? color }) {
    return style(size, color: color, weight: FontWeight.w400);
  }

  /// Create a [TextStyle] instance with a `medium` font weight ([FontWeight.w500]).
  /// @param [size]: The font size.
  /// @param [color]?: The font color (default: [SPDColor.shared.secondary1]).
  TextStyle medium(double size, { Color? color }) {
    return style(size, color: color, weight: FontWeight.w500);
  }
  
  /// Create a [TextStyle] instance with a `bold` font weight ([FontWeight.w700]).
  /// @param [size]: The font size.
  /// @param [color]?: The font color (default: [SPDColor.shared.secondary1]).
  TextStyle bold(double size, { Color? color }) {
    return style(size, color: color, weight: FontWeight.w700);
  }

  /// Create a [TextStyle] instance using the application's monospaced font family.
  /// @param [size]: The font size.
  /// @param [color]?: The font color (default: [SPDColor.shared.secondary1]).
  /// @param [weight]?: The font weight (default: [FontWeight.w400]).
  TextStyle mono(double size, { Color? color, FontWeight? weight }) {
    return style(size, color: color, family: monoFontFamily, weight: weight);
  }
}