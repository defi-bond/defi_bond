/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../buttons/tertiary_button.dart';
import '../../widgets/buttons/icon_button.dart';


/// Icon Tertiary Button
/// ------------------------------------------------------------------------------------------------

class SPDIconTertiaryButton extends SPLIconButton {
  
  /// Creates an icon button with no background or border edge.
  SPDIconTertiaryButton({
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
  }): super(
    style: style ?? SPDTertiaryButton.styleFrom()
  );
}