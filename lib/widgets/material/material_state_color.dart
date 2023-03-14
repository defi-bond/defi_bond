/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart' show Color, MaterialState, MaterialStateColor;
import 'package:stake_pool_lotto/mixin/material_state.dart';


/// Material State Color
/// ------------------------------------------------------------------------------------------------

class SPDMaterialStateColor extends MaterialStateColor with SPDMaterialState {
  
  /// Defines the [Color] values for each [MaterialState].
  const SPDMaterialStateColor(
    super.value, {
    this.disabled,
    this.pressed,
  });

  /// The color's disabled state color.
  final Color? disabled;

  /// The color's pressed state color.
  final Color? pressed;

  /// Return the color value for the [MaterialState.disabled] state.
  /// @param [color]: The default color value.
  @override
  Color disabledColor(Color color) {
    return disabled ?? super.disabledColor(color);
  }

  /// Return the color value for the [MaterialState.pressed] state.
  /// @param [color]: The default color value.
  @override
  Color pressedColor(Color color) {
    return pressed ?? super.pressedColor(color);
  }

  /// Create an instance of [SPDMaterialStateColor] for the given [color].
  /// @param [color]: The color to create a state object for.
  static SPDMaterialStateColor? color(Color? color) {
    return color != null ? SPDMaterialStateColor(color.value) : null;
  }

  /// Return the [Color] value for the given [states].
  /// @param [states]: The states to resolve the color [value] for.
  @override
  Color resolve(Set<MaterialState> states) {
    final Color color = Color(value);
    return stateColor(color, states: states) ?? color;
  }
}