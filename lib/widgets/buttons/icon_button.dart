/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:stake_pool_lotto/layouts/grid.dart';
import '../../widgets/buttons/button.dart';


/// Icon Button
/// ------------------------------------------------------------------------------------------------

abstract class SPLIconButton extends SPDButton {
  
  /// Creates an icon button that is rendered using the defined [style].
  const SPLIconButton({
    super.key,
    super.child,
    required this.icon,
    this.iconSize = SPDGrid.x2,
    required super.onPressed,
    super.onPressedDisabled,
    super.focusNode,
    super.autofocus = false,
    super.enabled = true,
    required super.style,
    super.targetPadding,
  });

  /// The icon painter.
  final IconData icon;

  /// The icon's size (default: `1/2`).
  final double iconSize;

  @override
  Widget? builder(
    final BuildContext context, 
    final Size? minSize, 
    final Color? color,
  ) => Icon(
    icon,
    color: color,
    size: iconSize,
  );
}