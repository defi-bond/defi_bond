/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'button.dart';
import '../material/material_state_color.dart';
import '../../layouts/grid.dart';
import '../../layouts/padding.dart';
import '../../themes/colors/color.dart';
import '../../themes/fonts/font.dart';


/// Primary Button
/// ------------------------------------------------------------------------------------------------

class SPDPrimaryButton extends SPDButton {
  
  /// Creates a button with an opaque background.
  SPDPrimaryButton({
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
    style: style ?? SPDPrimaryButton.styleFrom(),
  );

  static ButtonStyle styleFrom({
    final Color? backgroundColor,
    final Color? foregroundColor,
  }) => ButtonStyle(
    backgroundColor: SPDMaterialStateColor.color(backgroundColor ?? SPDColor.shared.brand1),
    foregroundColor: SPDMaterialStateColor(
      (foregroundColor ?? SPDColor.shared.primary1).value,
      disabled: SPDColor.shared.watermark, 
    ),
    minimumSize: MaterialStatePropertyAll(Size.square(SPDGrid.x6)),
    overlayColor: MaterialStatePropertyAll(SPDColor.shared.overlay),
    padding: MaterialStatePropertyAll(SPDEdgeInsets.shared.horizontal()),
    shape: MaterialStatePropertyAll(const StadiumBorder()),
    textStyle: MaterialStatePropertyAll(SPDFont.shared.button),
  );
}