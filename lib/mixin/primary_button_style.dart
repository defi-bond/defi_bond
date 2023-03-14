/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart' show BuildContext, ButtonStyle, MaterialState;
import '../themes/colors/color.dart';
import '../widgets/buttons/button.dart';
import '../widgets/material/material_state_color.dart';


/// Primary Button Style Mixin
/// ------------------------------------------------------------------------------------------------

mixin SPDPrimaryButtonStyle on SPDButton {

  /// Define the appearance of a `primary` button for each [MaterialState].
  /// @param [context]: The current build context.
  @override
  ButtonStyle style(final BuildContext context) {
    return super.style(context).copyWith(
      backgroundColor: SPDMaterialStateColor.color(
        backgroundColor ?? SPDColor.shared.brand1
      ),
      foregroundColor: SPDMaterialStateColor(
        color?.value ?? SPDColor.shared.primary1.value, 
        disabled: SPDColor.shared.watermark, 
        pressed: SPDColor.shared.primary1,
      ),
    );
  }
}