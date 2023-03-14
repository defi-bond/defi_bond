/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart' show Brightness, Color;
import 'brand_color.dart';
import 'theme_color.dart';
import 'status_color.dart';
import '../../extensions/color.dart';


/// Color
/// ------------------------------------------------------------------------------------------------

class SPDColor {

  /// Creates the application's colour palette for the provided theme [brightness].
  SPDColor._(
    Brightness brightness,
  ):  brand = SPDBrandColor.apply(brightness),
      primary = SPLThemeColor.apply(brightness),
      secondary = brightness == Brightness.light 
        ? SPLThemeColor.apply(Brightness.dark)
        : SPLThemeColor.apply(Brightness.light),
      status = SPLStatusColor.apply(brightness);

  /// The [SPDColor] class' singleton instance.
  static SPDColor shared = SPDColor._(Brightness.light);

  /// Sets the application's colour palette for the provided theme [brightness].
  SPDColor apply(Brightness brightness) {
    return shared = SPDColor._(brightness);
  }

  /// Sets the application's dark theme colour palette.
  SPDColor dark() {
    return shared = SPDColor._(Brightness.dark);
  }
  
  /// Sets the application's light theme colour palette.
  SPDColor light() {
    return shared = SPDColor._(Brightness.light);
  }

  /// The brand colour swatch.
  final SPDBrandColor brand;

  /// The primary colour swatch.
  final SPLThemeColor primary;

  /// The secondary colour swatch.
  final SPLThemeColor secondary;

  /// The status colour swatch.
  final SPLStatusColor status;

  /// Return the application's brand colour for the current theme.
  Color get brand1 => brand.shade1;

  /// Return the brand colour swatch's darkest shade for the current theme.
  Color get brand2 => brand.shade2;

  /// Return the primary colour swatch's first shade.
  Color get primary1 => primary.shade1;

  /// Return the primary colour swatch's second shade.
  Color get primary2 => primary.shade2;

  /// Return the primary colour swatch's third shade.
  Color get primary3 => primary.shade3;

  /// Return the primary colour swatch's fourth shade.
  Color get primary4 => primary.shade4;

  /// Return the primary colour swatch's fifth shade.
  Color get primary5 => primary.shade5;
  
  /// Return the primary colour swatch's sixth shade.
  Color get primary6 => primary.shade6;

  /// Return the primary colour swatch's seventh shade.
  Color get primary7 => primary.shade7;

  /// Return the primary colour swatch's eighth shade.
  Color get primary8 => primary.shade8;

  /// Return the secondary colour swatch's first shade.
  Color get secondary1 => secondary.shade1;

  /// Return the secondary colour swatch's second shade.
  Color get secondary2 => secondary.shade2;

  /// Return the secondary colour swatch's third shade.
  Color get secondary3 => secondary.shade3;

  /// Return the secondary colour swatch's fourth shade.
  Color get secondary4 => secondary.shade4;

  /// Return the secondary colour swatch's fifth shade.
  Color get secondary5 => secondary.shade5;

  /// Return the secondary colour swatch's sixth shade.
  Color get secondary6 => secondary.shade6;

  /// Return the secondary colour swatch's seventh shade.
  Color get secondary7 => secondary.shade7;

  /// Return the secondary colour swatch's eighth shade.
  Color get secondary8 => secondary.shade8;

  /// Return the information status colour.
  Color get information => status.information;

  /// Return the warning status colour.
  Color get warning => status.warning;

  /// Return the error status colour.
  Color get error => status.error;

  /// Return the success status colour.
  Color get success => status.success;

  /// Return the placeholder / watermark colour.
  Color get watermark => secondary6.darken();

  /// Return the overlay colour.
  Color get overlay => const Color(0xFF000000).withAlpha(8);

  /// Return the divider line colour.
  Color get divider => primary.shade2;

  /// Return the disabled colour.
  Color get disabled => primary.shade6;

  /// Return the default font colour.
  Color get font => secondary.shade1;
}