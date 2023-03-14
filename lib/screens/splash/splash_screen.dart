/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:stake_pool_lotto/themes/colors/color.dart';
import 'package:stake_pool_lotto/widgets/indicators/circular_progress_indicator.dart';


/// Splash Screen
/// ------------------------------------------------------------------------------------------------

class SPDSplashScreen extends StatelessWidget {

  /// Creates a loading screen.
  const SPDSplashScreen({
    super.key,
  });

  /// Navigator route name.
  static const String routeName = 'splashs/splash';

  /// Serialise this class into a json object.
  Map<String, dynamic> toJson() => {};

  /// Create an instance of this class from the given json object.
  /// @param [json]: A map containing the class' constructor parameters.
  factory SPDSplashScreen.fromJson(final Map<String, dynamic> json) => const SPDSplashScreen();
 
  /// Build the final widget.
  /// @param [context]: The current build context.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SPDColor.shared.brand1,
      body: Center(
        child: SPDCircularProgressIndicator(),
      ),
    );
  }
}