/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart' show State, StatefulWidget, WidgetsBinding;


/// Screen Aware
/// ------------------------------------------------------------------------------------------------

mixin SPDScreenAware<T extends StatefulWidget> on State<T> {

  /// Register a callback to be triggered when the current frame (i.e. first frame) ends.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onPostFrameCallback);
  }

  /// Call [didAppear] when the widget's first frame ends.
  void _onPostFrameCallback(final Duration duration) {
    didAppear();
  }

  /// The callback function that's triggered when the screen becomes the top-most view.
  void didAppear() {}

  /// The callback function that's triggered when the screen is no longer the top-most view.
  void didDisappear() {}
  
  /// The callback functions that's triggered when the screen's navigation button has been pressed 
  /// while it's the top-most view.
  void didFocus() {}
}