/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../themes/fonts/font.dart';


/// [TextStyle] Extensions
/// ------------------------------------------------------------------------------------------------

extension SPDTextStyleExtension on TextStyle {
  
  /// Returns a copy of this text style with a new font [color] value.
  TextStyle setColor(final Color color) {
    return copyWith(color: color);
  }

  /// Returns a copy of this text style with a `light` font weight and optional [color] value.
  TextStyle light({ final Color? color }) {
    return copyWith(color: color, fontWeight: FontWeight.w300);
  }

  /// Returns a copy of this text style with a `regular` font weight and optional [color] value.
  TextStyle regular({ final Color? color }) {
    return copyWith(color: color, fontWeight: FontWeight.w400);
  }

  /// Returns a copy of this text style with a `medium` font weight and optional [color] value.
  TextStyle medium({ final Color? color }) {
    return copyWith(color: color, fontWeight: FontWeight.w500);
  }

  /// Returns a copy of this text style with a `semi-bold` font weight and optional [color] value.
  TextStyle semiBold({ final Color? color }) {
    return copyWith(color: color, fontWeight: FontWeight.w600);
  }

  /// Returns a copy of this text style with a `bold` font weight and optional [color] value.
  TextStyle bold({ final Color? color }) {
    return copyWith(color: color, fontWeight: FontWeight.w700);
  }

  /// Returns a copy of this text style with a font height of [SPDFont.shared.adjustedHeight].
  TextStyle withAdjustedHeight() {
    return copyWith(height: SPDFont.shared.adjustedHeight);
  }
}