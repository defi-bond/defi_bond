/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'button.dart';
import '../../mixin/tertiary_button_style.dart';


/// Tertiary Button
/// ------------------------------------------------------------------------------------------------

class SPDTertiaryButton extends SPDButton with SPDTertiaryButtonStyle {
  
  /// Create a button with no background or border edge.
  const SPDTertiaryButton({
    Key? key,
    required Widget? child,
    required VoidCallback? onPressed,
    VoidCallback? onPressedDisabled,
    FocusNode? focusNode,
    bool autofocus = false,
    bool enabled = true,
    EdgeInsets? padding,
    double minHeight = 0.0,
    Color? color,
    TextStyle? style,
  }) : super(
        key: key,
        child: child,
        onPressed: onPressed,
        onPressedDisabled: onPressedDisabled,
        focusNode: focusNode,
        autofocus: autofocus,
        enabled: enabled,
        targetPadding: padding,
        minHeight: minHeight,
        color: color,
        textStyle: style,
      );
}