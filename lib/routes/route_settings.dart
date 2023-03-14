/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/widgets.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart' show SerializableMixin;
import '../navigator/navigator_transition.dart';
import 'route_arguments.dart';


/// Route Settings
/// ------------------------------------------------------------------------------------------------

class SPDRouteSettings extends RouteSettings with SerializableMixin {

  /// Stores the settings ([name] and [arguments]) of a navigator [Route]. The class is a sub class 
  /// of [RouteSettings], which forces [arguments] to be of type [SPDRouteArguments].
  const SPDRouteSettings({
    String? name,
    SPDRouteArguments? arguments,
  }): super(name: name, arguments: arguments);

  /// Cast [arguments] to [SPDRouteArguments].
  @override
  SPDRouteArguments? get arguments {
    return super.arguments as SPDRouteArguments?;
  }

  /// Return the [Route]'s parameters (i.e. constructor parameters).
  Map<String, dynamic>? get parameters {
    return arguments?.parameters;
  }

  /// Return the [Route]'s transition style.
  SPDNavigatorTransition? get transition {
    return arguments?.transition;
  }

  /// Return true if the [Route] is a checkpoint.
  bool get checkpoint {
    return arguments?.checkpoint == true;
  }

  /// Return true if the [Route] being replaced by this one should be kept in memory.
  bool get maintainState {
    return arguments?.maintainState == true;
  }

  /// Return true if the [Route] should be displayed as a full screen dialog.
  bool get fullscreenDialog {
    return arguments?.fullscreenDialog == true;
  }

  /// Return true if the [Route] has been loaded from storage.
  bool get restored {
    return arguments?.restored == true;
  }

  /// Serialise this class into a json object.
  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'arguments': arguments,
    };
  }

  /// Create an instance of this class from the given json object.
  /// @param [json]: A map containing the class' constructor parameters.
  static SPDRouteSettings fromJson(Map<String, dynamic> json) {
    return SPDRouteSettings(
      name: json['name'],
      arguments: SPDRouteArguments.fromJson(json['arguments'] ?? {}),
    );
  }

  /// Create an instance of this class from the given [RouteSettings].
  /// @param [settings]: The [RouteSettings] instance to copy the values from.
  static SPDRouteSettings fromRouteSettings(RouteSettings settings) {
    return SPDRouteSettings(
      name: settings.name, 
      arguments: settings.arguments as SPDRouteArguments?,
    );
  }
  
  /// Return a copy of `this` instance, replacing the current values with the given values.
  /// @params [*]: Optional values to overwrite the existing properties.
  @override
  SPDRouteSettings copyWith({
    final String? name,
    final Object? arguments,
  }) {
    return SPDRouteSettings(
      name: name ?? this.name,
      arguments: (arguments as SPDRouteArguments?) ?? this.arguments,
    );
  }
}