/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../../layouts/grid.dart';
import '../../widgets/buttons/button.dart';


/// Icon Button
/// ------------------------------------------------------------------------------------------------

abstract class SPLIconButton extends SPDButton {
  
  /// Create an icon button that is rendered using the defined [style].
  const SPLIconButton({
    Key? key,
    Widget? child,
    required this.icon,
    this.iconSize,
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
        onPressed: onPressed,
        onPressedDisabled: onPressedDisabled,
        focusNode: focusNode,
        autofocus: autofocus,
        enabled: enabled,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: SPDGrid.x2),
        targetPadding: targetPadding,
        minHeight: minHeight,
        color: color,
        backgroundColor: backgroundColor,
      );

  /// The icon painter.
  final IconData? icon;

  /// The icon's size (default: `1/2`).
  final double? iconSize;

  /// Build the button's icon. This method is called each time the widget is built.
  /// @param [context]: The current build context.
  /// @param [color]?: The content color ([color] or [ButtonStyle.foregroundColor]) for the 
  /// current state. 
  @override
  Widget? builder(BuildContext context, Color? color) {
    return Icon(
      icon,
      color: color,
      size: iconSize ?? minRadius,
    );
  }
}