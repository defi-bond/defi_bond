/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart' show BuildContext, ButtonStyle, BorderSide, MaterialState;
import '../layouts/line_weight.dart';
import '../themes/colors/color.dart';
import '../widgets/buttons/button.dart';
import '../widgets/material/material_state_border_side.dart';


/// Secondary Button Style Mixin
/// ------------------------------------------------------------------------------------------------

mixin SPDSecondaryButtonStyle on SPDButton {

  /// Define the appearance of a `secondary` button for each [MaterialState].
  /// @param [context]: The current build context.
  @override
  ButtonStyle style(final BuildContext context) {
    return super.style(context).copyWith(
      side: SPDMaterialStateBorderSide(
        BorderSide(
          color: SPDColor.shared.font, 
          width: SPDLineWeight.w1,
        ),
      ),
    );
  }
}