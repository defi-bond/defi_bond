/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:stake_pool_lotto/extensions/text_style.dart';
import '../../layouts/grid.dart';
import '../../layouts/padding.dart';
import '../../themes/colors/color.dart';
import '../../themes/fonts/font.dart';
import '../material/material_state_color.dart';
import 'button.dart';
import '../../mixin/primary_button_style.dart';


/// Primary Button
/// ------------------------------------------------------------------------------------------------

class SPDPrimaryButton extends SPDButton with SPDPrimaryButtonStyle {
  
  /// Create a button with an opaque background.
  const SPDPrimaryButton({
    Key? key,
    required Widget? child,
    required VoidCallback? onPressed,
    VoidCallback? onPressedDisabled,
    FocusNode? focusNode,
    bool autofocus = false,
    bool enabled = true,
    bool expand = false,
    EdgeInsets? padding,
    EdgeInsets? targetPadding,
    double? minHeight,
    Color? color,
    Color? backgroundColor,
    TextStyle? style,
  }) : super(
        key: key,
        child: child,
        onPressed: onPressed,
        onPressedDisabled: onPressedDisabled,
        focusNode: focusNode,
        autofocus: autofocus,
        enabled: enabled,
        expand: expand,
        padding: padding,
        targetPadding: targetPadding,
        minHeight: minHeight,
        color: color,
        backgroundColor: backgroundColor,
        textStyle: style,
      );
  
  static ButtonStyle defaultStyle() {
    return TextButton.styleFrom(
      backgroundColor: SPDMaterialStateColor.color(
        SPDColor.shared.brand1
      ),
      foregroundColor: SPDMaterialStateColor(
        SPDColor.shared.primary1.value, 
        disabled: SPDColor.shared.watermark, 
        pressed: SPDColor.shared.primary1,
      ),
      shape: const StadiumBorder(),
      minimumSize: Size.square(SPDGrid.x6),
      padding: SPDEdgeInsets.shared.horizontal(),
      textStyle: SPDFont.shared.button.withAdjustedHeight(),
    );
  }

  static ButtonStyle defaultNoneStyle() {
    return TextButton.styleFrom(
      backgroundColor: SPDMaterialStateColor.color(
        Colors.transparent
      ),
      foregroundColor: SPDMaterialStateColor(
        Colors.transparent.value,
      ),
      shape: const StadiumBorder(),
      minimumSize: Size.square(SPDGrid.x1),
      padding: EdgeInsets.zero,
      textStyle: SPDFont.shared.button.withAdjustedHeight(),
    );
  }
}