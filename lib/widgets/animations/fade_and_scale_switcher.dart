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
    transitionBuilder: (
      final Widget child, 
      final Animation<double> animation,
    ) => Align(
        alignment: Alignment.topCenter,
        child: ScaleTransition(
          scale: animation,
          alignment: alignment,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
      ),
    );
}