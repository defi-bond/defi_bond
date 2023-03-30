/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'button.dart';
import '../material/material_state_color.dart';
import '../../themes/colors/color.dart';
import '../../themes/fonts/font.dart';


/// Tertiary Button
/// ------------------------------------------------------------------------------------------------

class SPDTertiaryButton extends SPDButton {
  
  /// Creates a button with no background or border edge.
  SPDTertiaryButton({
    super.key,
    required super.child,
    required super.onPressed,
    super.onPressedDisabled,
    super.focusNode,
    super.autofocus = false,
    super.enabled = true,
    final ButtonStyle? style,
  }): super(
    style: style ?? SPDTertiaryButton.styleFrom(),
  );

  static ButtonStyle styleFrom({
    final Color? color,
    final Color? backgroundColor,
    final EdgeInsets? padding,
  }) => ButtonStyle(
    backgroundColor: SPDMaterialStateColor(
      (backgroundColor ?? Colors.transparent).value,
      disabled: Colors.transparent,
    ),
    foregroundColor: SPDMaterialStateColor(
      (color ?? SPDColor.shared.font).value,
      disabled: SPDColor.shared.watermark, 
    ),
    minimumSize: MaterialStateProperty.all<Size>(Size.zero),
    overlayColor: MaterialStateProperty.all<Color>(SPDColor.shared.overlay),
    padding: MaterialStateProperty.all<EdgeInsets>(padding ?? EdgeInsets.zero),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    textStyle: MaterialStatePropertyAll(SPDFont.shared.button),
    shape: MaterialStatePropertyAll(const StadiumBorder()),
  );
}