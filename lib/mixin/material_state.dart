/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../extensions/color.dart';
import '../themes/colors/color.dart';


/// Material State Mixin
/// ------------------------------------------------------------------------------------------------

mixin SPDMaterialState<T extends MaterialStateProperty> {

  /// Return the color value for the [MaterialState.disabled] state.
  /// @param [color]: The default color.
  Color disabledColor(final Color color) {
    return SPDColor.shared.primary6;
  }
  
  /// Return the color value for the [MaterialState.error] state.
  /// @param [color]: The default color.
  Color errorColor(final Color color) {
    return SPDColor.shared.error;
  }
  
  /// Return the color value for the [MaterialState.pressed] state.
  /// @param [color]: The default color.
  Color pressedColor(final Color color) {
    return color.lighten();
  }

  /// Return the color value for the [MaterialState.selected] state.
  /// @param [color]: The default color.
  Color selectedColor(final Color color) {
    return color.lighten();
  }

  /// Return the [Color] for the given [states].
  /// @param [color]: The default color.
  /// @param [states]: The current states.
  Color? stateColor(final Color? color, { required final Set<MaterialState> states }) {

    /// If color is [null] or transparent, return the current value.
    if (color == null || color.value == 0) {
      return color;
    }

    if (states.contains(MaterialState.disabled)) {
      return disabledColor(color);
    }
    
    if (states.contains(MaterialState.error)) {
      return errorColor(color);
    }
    
    if (states.contains(MaterialState.pressed)) {
      return pressedColor(color);
    }
    
    if (states.contains(MaterialState.selected)) {
      return selectedColor(color);
    }

    return color;
  }
}