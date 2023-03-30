/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/widgets.dart';
import '../../utils/duration.dart';


/// Fade and Size Switcher
/// ------------------------------------------------------------------------------------------------

class SPDFadeAndSizeSwitcher extends AnimatedSwitcher {

  /// An [AnimatedSwitcher] widget with a custom [transitionBuilder] that `fades` and `resizes` the 
  /// [child] widget in and out of view.
  SPDFadeAndSizeSwitcher({
    Key? key,
    Duration? duration,
    required Widget? child,
    Axis axis = Axis.vertical,
    double axisAlignment = 0.0,
  }): super(
    key: key,
    child: child,
    duration: duration ?? SPDDuration.normal,
    transitionBuilder: (
      final Widget child, 
      final Animation<double> animation,
    ) => SizeTransition(
      axis: axis,
      axisAlignment: axisAlignment,
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    ),
  );
}