/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../../layouts/grid.dart';
import '../../layouts/padding.dart';
import '../../themes/colors/color.dart';
import 'button.dart';
import '../../mixin/secondary_button_style.dart';


/// Secondary Button
/// ------------------------------------------------------------------------------------------------

class SPDSecondaryButton extends SPDButton with SPDSecondaryButtonStyle {
  
  /// Create a button with a border edge.
  const SPDSecondaryButton({
    Key? key,
    required Widget? child,
    required VoidCallback? onPressed,
    VoidCallback? onPressedDisabled,
    FocusNode? focusNode,
    bool autofocus = false,
    bool enabled = true,
    bool expand = false,
    EdgeInsets? padding,
    EdgeInsets? targetPadding,
    double? minHeight,
    Color? color,
    Color? backgroundColor,
    TextStyle? style,
  }) : super(
        key: key,
        child: child,
        onPressed: onPressed,
        onPressedDisabled: onPressedDisabled,
        focusNode: focusNode,
        autofocus: autofocus,
        enabled: enabled,
        expand: expand,
        padding: padding,
        targetPadding: targetPadding,
        minHeight: minHeight,
        color: color,
        backgroundColor: backgroundColor,
        textStyle: style,
      );

  static ButtonStyle defaultStyle() {
    return TextButton.styleFrom(
      backgroundColor: SPDColor.shared.primary1,
      foregroundColor: SPDColor.shared.font,
      shape: const StadiumBorder(),
      minimumSize: Size.square(SPDGrid.x6),
      padding: SPDEdgeInsets.shared.horizontal(),
    );
  }
}