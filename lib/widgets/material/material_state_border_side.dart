/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart' show BorderSide, MaterialState, MaterialStateBorderSide;
import 'package:stake_pool_lotto/mixin/material_state.dart';


/// Material State Colour
/// ------------------------------------------------------------------------------------------------

class SPDMaterialStateBorderSide extends MaterialStateBorderSide with SPDMaterialState {
  
  /// Defines the [BorderSide] styling for each [MaterialState].
  const SPDMaterialStateBorderSide(this.value);
  
  /// The default [BorderSide] value.
  final BorderSide value;

  /// Create an instance of [SPDMaterialStateBorderSide] for the given [side].
  /// @param [side]: The border side to create a state object for.
  static SPDMaterialStateBorderSide? side(BorderSide? side) {
    return side != null ? SPDMaterialStateBorderSide(side) : null;
  }

  /// Return the [BorderSide] value for the given [states].
  /// @param [states]: The states to resolve the border side [value] for.
  @override
  BorderSide? resolve(Set<MaterialState> states) {
    return value.copyWith(color: stateColor(value.color, states: states));
  }
}