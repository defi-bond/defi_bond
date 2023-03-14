/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../widgets/buttons/button.dart';


/// Tertiary Button Style Mixin
/// ------------------------------------------------------------------------------------------------

mixin SPDTertiaryButtonStyle on SPDButton {

  /// Define the appearance of a `tertiary` button for each [MaterialState].
  /// @param [context]: The current build context.
  @override
  ButtonStyle style(final BuildContext context) {
    return super.style(context).copyWith(
      minimumSize: MaterialStateProperty.all<Size>(Size(0.0, minRadius)),
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      padding: MaterialStateProperty.all(EdgeInsets.zero),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
    );
  }
}