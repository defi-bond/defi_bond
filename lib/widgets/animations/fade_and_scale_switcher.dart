/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/widgets.dart';
import '../../utils/duration.dart';


/// Fade And Scale Switcher
/// ------------------------------------------------------------------------------------------------

class SPDFadeAndScaleSwitcher extends AnimatedSwitcher {

  /// An [AnimatedSwitcher] widget with a custom [transitionBuilder] that `fades` and `scales` the 
  /// [child] widget in and out of view.
  SPDFadeAndScaleSwitcher({
    Key? key,
    Duration? duration,
    required Widget? child,
    Alignment alignment = Alignment.center
  }): super(
        key: key,
        child: child,
        duration: duration ?? SPDDuration.normal,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return Align(
            alignment: Alignment.centerLeft,
            child: ScaleTransition(
              scale: animation,
              alignment: alignment,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            ),
          );
        }
      );
}