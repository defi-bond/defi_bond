/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../buttons/icon_button.dart';
import '../buttons/primary_button.dart';


/// Icon Primary Button
/// ------------------------------------------------------------------------------------------------

class SPDIconPrimaryButton extends SPLIconButton {
  
  /// Creates an icon button with an opaque background.
  SPDIconPrimaryButton({
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
    style: style ?? SPDPrimaryButton.styleFrom(),
  );
}