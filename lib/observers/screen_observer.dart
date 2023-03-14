/// Imports
/// ------------------------------------------------------------------------------------------------

import '../mixin/screen_aware.dart';


/// Types
/// ------------------------------------------------------------------------------------------------

typedef _SPDNotifyCallback = void Function(SPDScreenAware screenAware);


/// Screen Observer
/// ------------------------------------------------------------------------------------------------

class SPDScreenObserver<T extends SPDScreenAware> {

  /// The [SPDScreenAware] listeners to notify of screen changes.
  final Set<SPDScreenAware> _listeners = <SPDScreenAware>{};

  /// Subscribe [screenAware] to receive screen change notifications.
  /// @param [screenAware]: The widget to register for screen change notifications.
  void subscribe(final SPDScreenAware screenAware) {
    _listeners.add(screenAware);
  }

  /// Unsubscribe [screenAware].
  /// @param [screenAware]: The widget to unregister from screen change notifications.
  void unsubscribe(final SPDScreenAware screenAware) {
    _listeners.remove(screenAware);
  }

  /// Notify all listeners that the screen has become the top-most view.
  void didAppear() {
    _notifyListeners((final SPDScreenAware screenAware) => screenAware.didAppear());
  }

  /// Notify all listeners that the screen is no longer the top-most view.
  void didDisappear() {
    _notifyListeners((final SPDScreenAware screenAware) => screenAware.didDisappear());
  }

  /// Notify all listeners that the screen's navigation button has been pressed while it's the 
  /// top-most view.
  void didFocus() {
    _notifyListeners((final SPDScreenAware screenAware) => screenAware.didFocus());
  }

  /// Run [callback] for each of the [_listeners].
  /// @param [callback]: The operation to perform on each listener.
  void _notifyListeners(final _SPDNotifyCallback callback) {
    final List<SPDScreenAware> listeners = _listeners.toList(growable: false);
    for (final SPDScreenAware screenAware in listeners) {
      callback.call(screenAware);
    }
  }

  /// Dispose of all listeners.
  void dispose() {
    _listeners.clear();
  }
}