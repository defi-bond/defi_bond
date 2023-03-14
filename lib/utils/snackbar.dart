/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:math' as math show max;
import 'package:flutter/material.dart';
import '../themes/colors/color.dart';


/// Snackbar
/// ------------------------------------------------------------------------------------------------

class SPLSnackbar {

  /// Provides properties and methods for displaying snackbar messages.
  const SPLSnackbar._();

  /// The [SPLSnackbar] class' singleton instance.
  static const SPLSnackbar shared = SPLSnackbar._();

  /// Show a snackbar message.
  /// @param [context]: The current build context.
  /// @param [content]: The message to display.
  /// @param [queue]: If `false`, remove the current message before adding the new message to the 
  /// queue (default: `false` - this will cause each new message to be displayed immediately).
  /// @param [duration]? The duration the display the message for (default: `4000+`).
  /// @param [backgroundColour]?: The background colour (default: [SPDColor.shared.brand1]).
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    BuildContext context, {
    required Widget content,
    bool queue = false,
    Duration? duration,
    Color? backgroundColour,
  }) {
    final ScaffoldMessengerState state = ScaffoldMessenger.of(context);

    if(!queue) {
      state.removeCurrentSnackBar(reason: SnackBarClosedReason.remove);
    }

    if(duration == null) {
      final double multiplier = content is Text ? (content.data?.length ?? 0) / 50.0 : 1.0;
      duration = Duration(milliseconds: (4000 * math.max(1.0, multiplier)).ceil());
    }

    return state.showSnackBar(
      SnackBar(
        content: content,
        duration: duration,
        backgroundColor: backgroundColour ?? SPDColor.shared.brand1,
      ),
    );
  }

  /// Show an `information` snackbar message.
  /// @param [context]: The current build context.
  /// @param [message]: The message to display.
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> info(
    BuildContext context, 
    String message,
  ) {
    return show(
      context, 
      content: Text(message), 
      backgroundColour: SPDColor.shared.information,
    );
  }

  /// Show a `success` snackbar message.
  /// @param [context]: The current build context.
  /// @param [message]: The message to display.
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> success(
    BuildContext context, 
    String message,
  ) {
    return show(
      context, 
      content: Text(message), 
      backgroundColour: SPDColor.shared.success,
    );
  }

  /// Show an `error` snackbar message.
  /// @param [context]: The current build context.
  /// @param [message]: The message to display.
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> error(
    BuildContext context, 
    String message,
  ) {
    return show(
      context, 
      content: Text(message), 
      backgroundColour: SPDColor.shared.error,
    );
  }
}