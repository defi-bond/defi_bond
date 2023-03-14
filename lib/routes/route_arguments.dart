/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../navigator/navigator_transition.dart';


/// Route Arguments
/// ------------------------------------------------------------------------------------------------

class SPDRouteArguments extends Object {

  /// Defines the [SPDRouteSettings.arguments] property.
  const SPDRouteArguments({
    this.parameters,
    this.transition,
    bool? checkpoint,
    bool? maintainState,
    bool? fullscreenDialog,
    bool? restored,
  }): checkpoint = checkpoint ?? false,
      maintainState = maintainState ?? false,
      fullscreenDialog = fullscreenDialog ?? false,
      restored = restored ?? false;

  /// The [Route]'s parameters (i.e. constructor parameters).
  final Map<String, dynamic>? parameters;
  
  /// The [Route]'s transition style.
  final SPDNavigatorTransition? transition;

  /// If true, the [Route] is a checkpoint (default: `false`).
  final bool checkpoint;

  /// If true, keep the route being replaced in memory (default: `false`).
  final bool maintainState;

  /// If true, the [Route] should be displayed as a full screen dialog (default: `false`).
  final bool fullscreenDialog;

  /// If true, the [Route] has been restored from storage (see [SPDRoute.onGenerateInitialRoutes]).
  final bool restored;

  /// Serialise this class into a json object.
  Map<String, dynamic> toJson() => {
    'parameters': parameters,
    'transition': transition,
    'checkpoint': checkpoint,
    'maintainState': maintainState,
    'fullscreenDialog': fullscreenDialog,
    'restored': restored,
  };

  /// Create an instance of this class from the given json object.
  /// @param [json]: A map containing the class' constructor parameters.
  static SPDRouteArguments fromJson(Map<String, dynamic> json) {
    return SPDRouteArguments(
      parameters: json['parameters'],
      transition: json['transition'],
      checkpoint: json['checkpoint'],
      maintainState: json['maintainState'],
      fullscreenDialog: json['fullscreenDialog'],
      restored: json['restored'],
    );
  }

  /// Return a copy of `this` instance.
  /// @params [*]: The values to overwrite the existing properties.
  SPDRouteArguments copyWith({
    Map<String, dynamic>? parameters,
    SPDNavigatorTransition? transition,
    bool? checkpoint,
    bool? maintainState,
    bool? fullscreenDialog,
    bool? restored,
  }) {
    return SPDRouteArguments(
      parameters: parameters ?? this.parameters,
      transition: transition ?? this.transition,
      checkpoint: checkpoint ?? this.checkpoint,
      maintainState: maintainState ?? this.maintainState,
      fullscreenDialog: fullscreenDialog ?? this.fullscreenDialog,
      restored: restored ?? this.restored,
    );
  }
}