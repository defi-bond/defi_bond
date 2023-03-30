/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome, SystemUiOverlayStyle;
import 'colors/color.dart';
import 'fonts/font.dart';
import '../extensions/text_style.dart';
import '../layouts/grid.dart';
import '../layouts/line_weight.dart';
import '../layouts/padding.dart';


/// Theme
/// ------------------------------------------------------------------------------------------------

class SPDTheme {

  /// Defines the application's current theme.
  const SPDTheme._();

  /// The [SPDTheme] class' singleton instance.
  static const shared = SPDTheme._();

  /// Return the device's current brightness.
  Brightness get _brightness {
    return SchedulerBinding.instance.window.platformBrightness;
  }

  /// Create the application's theme for the given [brightness].
  /// @param [brightness]: The application's current theme.
  ThemeData apply([Brightness? brightness]) {
    
    /// Apply the default [_brightness] if [brightness] is `null`.
    brightness ??= _brightness;

    /// Set the application's colour scheme. This `must be set first` as it is a dependency of other 
    /// singleton classes.
    SPDColor.shared.apply(brightness);

    /// Portrait only.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    /// Get the inverse brightness value.
    Brightness contrastBrightness = brightness == Brightness.dark 
      ? Brightness.light 
      : Brightness.dark;

    /// Set the status/navigation bar styling.
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: SPDColor.shared.primary1,
        statusBarIconBrightness: contrastBrightness,
        systemNavigationBarColor: SPDColor.shared.primary1,
        systemNavigationBarIconBrightness: contrastBrightness,
      ),
    );

    /// Define the application's text theme.
    final TextTheme textTheme = TextTheme(
      displayLarge: SPDFont.shared.displayLarge,
      displayMedium: SPDFont.shared.displayMedium,
      displaySmall: SPDFont.shared.displaySmall,
      headlineLarge: SPDFont.shared.headlineLarge,
      headlineMedium: SPDFont.shared.headlineMedium,
      headlineSmall: SPDFont.shared.headlineSmall,
      titleLarge: SPDFont.shared.titleLarge,
      titleMedium: SPDFont.shared.titleMedium,
      titleSmall: SPDFont.shared.titleSmall,
      bodyLarge: SPDFont.shared.bodyLarge,
      bodyMedium: SPDFont.shared.bodyMedium,
      bodySmall: SPDFont.shared.bodySmall,
      labelLarge: SPDFont.shared.labelLarge,
      labelMedium: SPDFont.shared.labelMedium,
      labelSmall: SPDFont.shared.labelSmall,
    );

    /// The text style for tabs.
    final TextStyle tabStyle = SPDFont.shared.labelMedium.withAdjustedHeight();
    
    /// Return the application's theme data.
    return ThemeData(
      brightness: brightness,
      progressIndicatorTheme: ProgressIndicatorThemeData(
        circularTrackColor: SPDColor.shared.brand,
        color: SPDColor.shared.primary1,
      ),
      colorScheme: ColorScheme.dark(
        primary: SPDColor.shared.primary1,
        secondary: SPDColor.shared.secondary1,
        error: SPDColor.shared.error,
      ),
      disabledColor: SPDColor.shared.disabled,
      dividerColor: SPDColor.shared.divider,
      dividerTheme: DividerThemeData(
        color: SPDColor.shared.divider,
        space: 0.0,
        thickness: 2.0,
      ),
      focusColor: SPDColor.shared.overlay,
      hoverColor: SPDColor.shared.overlay,
      highlightColor: SPDColor.shared.overlay,
      hintColor: SPDColor.shared.watermark,
      indicatorColor: SPDColor.shared.brand,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(SPDGrid.x3),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: SPDColor.shared.brand1),
          borderRadius: BorderRadius.circular(SPDGrid.x3),
        ),
        contentPadding: SPDEdgeInsets.shared.horizontal(),
        errorStyle: SPDFont.shared.bodySmall.medium(color: SPDColor.shared.error),
        fillColor: SPDColor.shared.primary2,
        filled: true,
        hintStyle: SPDFont.shared.bodyMedium.setColor(SPDColor.shared.watermark),
        labelStyle: textTheme.bodyMedium,
      ),
      primaryTextTheme: textTheme,
      scaffoldBackgroundColor: SPDColor.shared.primary1,
      snackBarTheme: SnackBarThemeData(
        actionTextColor: SPDColor.shared.primary1,
        backgroundColor: SPDColor.shared.brand1,
        contentTextStyle: SPDFont.shared.bodyMedium.setColor(SPDColor.shared.primary1),
        disabledActionTextColor: SPDColor.shared.watermark,
      ),
      splashColor: SPDColor.shared.overlay,
      tabBarTheme: TabBarTheme(
        labelStyle: tabStyle.medium(),
        labelColor: SPDColor.shared.brand1,
        unselectedLabelStyle: tabStyle,
        unselectedLabelColor: SPDColor.shared.watermark,
        labelPadding: const EdgeInsets.symmetric(
          horizontal: SPDGrid.x2, 
        ),
        indicator: BoxDecoration(
          border: Border.all(
            color: SPDColor.shared.brand1,
            width: SPDLineWeight.w1,
          ),
          borderRadius: BorderRadius.circular(SPDGrid.x2),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: SPDColor.shared.secondary6,
        selectionColor: SPDColor.shared.primary4,
        selectionHandleColor: SPDColor.shared.brand1,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: SPDColor.shared.primary2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SPDGrid.x1),
        ),
      ),
      iconTheme: IconThemeData(
        size: SPDGrid.x2,
        color: SPDColor.shared.font,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.zero,
        horizontalTitleGap: SPDGrid.x2,
        minVerticalPadding: 0.0,
        visualDensity: VisualDensity.compact,
        minLeadingWidth: SPDGrid.x3,
      ),
      textTheme: textTheme,
    );
  }
}