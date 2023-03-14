/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:stake_pool_lotto/widgets/buttons/icon_button.dart';
import '../../mixin/primary_button_style.dart';


/// Icon Primary Button
/// ------------------------------------------------------------------------------------------------

class SPDIconPrimaryButton extends SPLIconButton with SPDPrimaryButtonStyle {
  
  /// Create an icon button with an opaque background.
  const SPDIconPrimaryButton({
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
        padding: padding ?? EdgeInsets.zero,
        targetPadding: targetPadding,
        minHeight: minHeight,
        color: color,
        backgroundColor: backgroundColor,
      );
}