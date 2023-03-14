/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../../widgets/buttons/icon_button.dart';
import '../../mixin/secondary_button_style.dart';


/// Icon Secondary Button
/// ------------------------------------------------------------------------------------------------

class SPDIconSecondaryButton extends SPLIconButton with SPDSecondaryButtonStyle {
  
  /// Create an icon button with a border edge.
  const SPDIconSecondaryButton({
    Key? key,
    Widget? child,
    required IconData? icon,
    double? iconSize,
    required VoidCallback? onPressed,
    VoidCallback? onPressedDisabled,
    FocusNode? focusNode,
    bool autofocus = false,
    bool enabled = true,
    EdgeInsets? padding,
    EdgeInsets? targetPadding,
    double? minHeight,
    Color? color,
    Color? backgroundColor,
  }) : super(
        key: key,
        child: child,
        icon: icon,
        iconSize: iconSize,
        onPressed: onPressed,
        onPressedDisabled: onPressedDisabled,
        focusNode: focusNode,
        autofocus: autofocus,
        enabled: enabled,
        padding: padding,
        targetPadding: targetPadding,
        minHeight: minHeight,
        color: color,
      );
}