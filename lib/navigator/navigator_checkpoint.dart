/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../routes/route_settings.dart';


/// Navigator Checkpoint
/// ------------------------------------------------------------------------------------------------

class SPDNavigatorCheckpoint extends NavigatorObserver {

  /// Creates a [NavigatorObserver] that keeps track of the current [Route]s in the [Navigator]'s 
  /// stack. The function [save] is called each time a `checkpoint` [Route] is `pushed`, `popped` 
  /// or `removed` from the stack. Set [SPDRouteArguments.checkpoint] to create a checkpoint.
  /// 
  /// For example:
  /// 
  ///   OANavigator.shared.pushNamed(
  ///     context,
  ///     '/routeName',
  ///     arguments: OARouteArguments(
  ///       ...,
  ///       checkpoint: true,
  ///       ...,
  ///     ),
  ///   );
  SPDNavigatorCheckpoint({
    required this.save,
  }): super();

  /// The [Route]s in the navigation stack.
  final List<Route> _routes = [];

  /// The callback function to save the current state of the navigation stack.
  /// @param [routes]: The current navigation stack up to the last `checkpoint` [Route].
  final Future<void> Function(Iterable<Route> routes) save;

  /// DEBUGGING
  /// Print the [routes] settings.
  /// @param [label]: The description.
  /// @param [routes]: The routes (default: [_routes]).
  void _printRoutes(String label, [Iterable<Route>? routes]) {
    const String lineBreak = '\n\t';
    final Iterable<RouteSettings> settings = (routes ?? _routes).map((e) => e.settings);
    print('$label$lineBreak${settings.join(lineBreak)}');
  }

  /// Remove each contiguous `inactive` [Route] from the end of [_routes] and return the route 
  /// settings of the last inactive `checkpoint` [Route].
  RouteSettings? _clean() {

    RouteSettings? settings;
    
    while (_routes.isNotEmpty) {
    
      /// The last (top-most) route in the [_routes].
      final Route route = _routes.last;
      
      /// If the route is active, terminate the loop.
      if (route.isActive) {
        break;
      }

      /// Remove the inactive route from the end of the list.
      _routes.removeLast();
      
      /// Set [settings] to the last inactive `checkpoint` route in the list.
      if (settings == null) {
        final RouteSettings oldSettings = route.settings;
        if (oldSettings is SPDRouteSettings && oldSettings.checkpoint) { 
          settings = oldSettings; 
        }
      }
    }

    return settings;
  }

  /// Return true if [route] is a `checkpoint` [Route] (see [SPDRouteSettings.checkpoint]).
  bool _isCheckpoint(Route route) {
    final RouteSettings settings = route.settings;
    return settings is SPDRouteSettings && settings.checkpoint;
  }

  /// Append [route] to [_routes] and return its [RouteSettings].
  /// @param [route]?: The [Route] pushed onto the [Navigator]s stack.
  RouteSettings? _add(Route? route) {
    if (route != null) {
      assert(!_routes.contains(route));
      _routes.add(route);
      return route.settings;
    }
    return null;
  }

  /// Remove [route] from [_routes] and return its [RouteSettings].
  /// @param [route]?: The [Route] removed from the [Navigator]s stack.
  RouteSettings? _remove(Route? route) {
    final int index = _routes.lastIndexWhere((item) => item == route);
    return index < 0 ? null : _routes.removeAt(index).settings as RouteSettings;
  }

  /// Call [save] to store the current navigation state.
  /// @param [routes]: The current navigation stack.
  Future<void> _save(final List<Route> routes) {
    final int index = routes.lastIndexWhere(_isCheckpoint);
    final Iterable<Route> routesCheckpoint = routes.getRange(0, index + 1);
    /// TODO: Save the list to storage.
    _printRoutes('(NAV CHP) SAVE NAVIGATOR CHECKPOINT', routesCheckpoint);
    return save(routesCheckpoint);
  }

  /// Save the [Navigator]'s current state if a `checkpoint` [Route] has been `pushed`, `popped` or 
  /// `removed` from the [Navigator]'s stack.
  /// @param [newSettings]?: The settings of the [Route] added to [_routes].
  /// @param [oldSettings]?: The settings of the [Route] removed from [_routes].
  void _onChanged({ RouteSettings? newSettings, RouteSettings? oldSettings }) {
    if ((newSettings is SPDRouteSettings && newSettings.checkpoint && !newSettings.restored) 
      || (oldSettings is SPDRouteSettings && oldSettings.checkpoint)) {
      _save(List.from(_routes));
    }
  }

  /// The function that's called when the [Navigator] pushes a [route] onto the stack.
  /// @param [route]: The [Route] that has been pushed onto the stack.
  /// @param [previousRoute]?: The [Route] below [route], i.e. the previously active [Route].
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    /// If [didPush] has been triggered as part of a `push and remove` operation, the list will 
    /// contain inactive routes until [didRemove] is called. Clearing the list of these routes will 
    /// ensure [_routes] is in a consistent state before handling the push operation.
    final RouteSettings? oldSettings = _clean();
    final RouteSettings? newSettings = _add(route);
    _printRoutes('(NAV CHP) DID PUSH - ${newSettings?.name}');
    _onChanged(newSettings: newSettings, oldSettings: oldSettings);
  }

  /// The function that's called when the [Navigator] pops a [route] from the stack.
  /// @param [route]: The [Route] that has been popped from the stack.
  /// @param [previousRoute]?: The [Route] below [route], and thus the newly active [Route].
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final RouteSettings? settings = _remove(route);
    _printRoutes('(NAV CHP) DID POP - ${settings?.name}');
    _onChanged(oldSettings: settings);
  }
  
  /// The function that's called when the [Navigator] removes a [route] from the stack. If multiple 
  /// [Routes] are being removed, this function will be called once for each [Route].
  /// @param [route]: The [Route] that has been removed from the stack.
  /// @param [previousRoute]?: The [Route] below the last removed [Route]. If multiple [Route]s are
  /// being removed, then this is the route below the bottom-most route. 
  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final RouteSettings? settings = _remove(route);
    _printRoutes('(NAV CHP) DID REMOVE - ${settings?.name}');
    _onChanged(oldSettings: settings);
  }

  /// The function that's called when the [Navigator] replaces an existing route in the stack.
  /// @param [newRoute]?: The [Route] being added to the stack.
  /// @param [oldRoute]?: The [Route] being removed from the stack.
  @override
  void didReplace({ Route<dynamic>? newRoute, Route<dynamic>? oldRoute }) {
    final RouteSettings? oldSettings = _remove(oldRoute);
    final RouteSettings? newSettings = _add(newRoute);
    _printRoutes('(NAV CHP) DID REPLACE - (old) ${oldSettings?.name} / (new) ${newSettings?.name}');
    _onChanged(newSettings: newSettings, oldSettings: oldSettings);
  }
}