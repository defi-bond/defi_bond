/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../colors/color.dart';
import '../../extensions/text_style.dart';


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

  /// The largest display font style.
  TextStyle get displayLarge => medium(52.0);

  /// The regular display font style.
  TextStyle get displayMedium=> medium(48.0);

  /// The smallest display font style.
  TextStyle get displaySmall => medium(44.0);

  /// The largest headline font style.
  TextStyle get headlineLarge => medium(40.0);

  /// The regular headline font style.
  TextStyle get headlineMedium=> medium(36.0);

  /// The smallest headline font style.
  TextStyle get headlineSmall => medium(32.0);

  /// The largest title font style.
  TextStyle get titleLarge => medium(28.0);

  /// The regular title font style.
  TextStyle get titleMedium=> medium(24.0);

  /// The smallest title font style.
  TextStyle get titleSmall => medium(20.0);

  /// The largest body font style.
  TextStyle get bodyLarge => medium(18.0);

  /// The regular body font style.
  TextStyle get bodyMedium=> medium(16.0);

  /// The smallest body font style.
  TextStyle get bodySmall => medium(14.0);

  /// The largest label font style.
  TextStyle get labelLarge => regular(16.0);

  /// The regular label font style.
  TextStyle get labelMedium=> regular(14.0);

  /// The smallest label font style.
  TextStyle get labelSmall => regular(12.0);

  /// Return the application's button font style.
  TextStyle get button => bodyMedium.withAdjustedHeight();

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