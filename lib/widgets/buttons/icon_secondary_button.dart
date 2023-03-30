/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../buttons/secondary_button.dart';
import '../../widgets/buttons/icon_button.dart';


/// Icon Secondary Button
/// ------------------------------------------------------------------------------------------------

class SPDIconSecondaryButton extends SPLIconButton {
  
  /// Creates an icon button.
  SPDIconSecondaryButton({
    super.key,
    super.child,
    required super.icon,
    super.iconSize,
    required super.onPressed,
    super.onPressedDisabled,
    super.focusNode,
    super.autofocus,
    super.enabled,
    final ButtonStyle? style,
    super.targetPadding,
  }): super(
    style: style ?? SPDSecondaryButton.styleFrom(),
  );
}