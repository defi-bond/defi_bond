/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';


/// Permission Screen
/// ------------------------------------------------------------------------------------------------

class SPDPermissionScreen extends StatelessWidget {

  /// Creates a screen that asks the user to grant permission for a [device].
  const SPDPermissionScreen({
    super.key,
    required this.device,
  });

  /// The name of the device that the permission is being requested for (e.g. 'camera').
  final String device;

  /// Navigator route name.
  static const String routeName = 'permissions/permission';

  /// Serialise this class into a json object.
  Map<String, dynamic> toJson() {
    return {
      'device': device,
    };
  }

  /// Create an instance of this class from the given json object.
  /// @param [json]: A map containing the class' constructor parameters.
  factory SPDPermissionScreen.fromJson(Map<String, dynamic> json) {
    return SPDPermissionScreen(
      device: json['device'],
    );
  }
 
  /// Build the final widget.
  /// @param [context]: The current build context.
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('PERMISSION SCREEN')),
    );
  }
}