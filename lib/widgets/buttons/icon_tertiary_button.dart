/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:stake_pool_lotto/mixin/tertiary_button_style.dart';
import 'package:stake_pool_lotto/widgets/buttons/icon_button.dart';
import '../../layouts/grid.dart';


/// Icon Tertiary Button
/// ------------------------------------------------------------------------------------------------

class SPDIconTertiaryButton extends SPLIconButton with SPDTertiaryButtonStyle {
  
  /// Create an icon button with no background or border edge.
  const SPDIconTertiaryButton({
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
    double? minHeight,
    Color? color,
  }) : super(
        key: key,
        child: child,
        icon: icon,
        iconSize: iconSize ?? SPDGrid.x1,
        onPressed: onPressed,
        onPressedDisabled: onPressedDisabled,
        focusNode: focusNode,
        autofocus: autofocus,
        enabled: enabled,
        targetPadding: padding,
        minHeight: minHeight ?? SPDGrid.x1 * 2.0,
        color: color,
      );
}