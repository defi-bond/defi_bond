/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'button.dart';
import '../buttons/primary_button.dart';
import '../../themes/colors/color.dart';


/// Secondary Button
/// ------------------------------------------------------------------------------------------------

class SPDSecondaryButton extends SPDButton {
  
  SPDSecondaryButton({
    super.key,
    required super.child,
    required super.onPressed,
    super.onPressedDisabled,
    super.focusNode,
    super.autofocus = false,
    super.enabled = true,
    super.expand = false,
    final ButtonStyle? style,
    super.targetPadding,
  }): super(
    style: style ?? SPDSecondaryButton.styleFrom()
  );

  static ButtonStyle styleFrom({
    final Color? backgroundColor,
    final Color? foregroundColor,
  }) => SPDPrimaryButton.styleFrom(
    backgroundColor: backgroundColor ?? SPDColor.shared.primary2,
    foregroundColor: foregroundColor ?? SPDColor.shared.secondary1,
  );
}