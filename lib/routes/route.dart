/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stake_pool_lotto/screens/discover/discover_screen.dart';
import 'package:stake_pool_lotto/screens/discover/faqs_screen.dart';
import 'package:stake_pool_lotto/screens/scaffolds/app_scaffold.dart';
import 'package:stake_pool_lotto/screens/stake/stake_screen.dart';
import 'package:stake_pool_lotto/screens/swap/swap_screen.dart';
import '../navigator/navigator.dart';
import '../routes/route_arguments.dart';
import '../routes/route_settings.dart';
import '../screens/errors/404_screen.dart';
import '../screens/home/home_screen.dart';
import '../storage/user_data_storage.dart';
import '../storage/storage_key.dart';


/// Route
/// ------------------------------------------------------------------------------------------------

class SPDRoute {

  /// Provides properties and methods for generating [Route]s.
  const SPDRoute._();

  /// The [SPDRoute] class' singleton instance.
  static const SPDRoute shared = SPDRoute._();

  /// The [Route]s displayed when the appplication first launches (see [onGenerateInitialRoutes]).
  static final List<Route> _initialRoutes = [];

  /// Return the storage key used to save [Route]s to persistent storage.
  String get _storageKey {
    return SPDStorageKey.routes;
  }

  /// Load the application's saved [Route]s.
  Future<void> initialise() async {
    final List<String>? routes = SPDUserDataStorage.shared.getStringList(_storageKey);
    _initialRoutes..clear()..addAll(routes?.map(_decodeRoute) ?? const []);
  }

  /// Save [routes] to persistent storage.
  /// @param [routes]: The current navigation stack.
  Future<bool> save(Iterable<Route> routes) async {
    final Iterable<String> settings = routes.where(_filterRoute).map(_encodeRoute);
    return SPDUserDataStorage.shared.setStringList(_storageKey, settings);
  }

  /// Return true if [route] is a `named` [Route].
  /// @param [route]: Any [Route].
  bool _filterRoute(Route route) {
    return route.settings.name != null;
  }

  /// Serialise [route] to a [String].
  /// @param [route]: Any [Route].
  String _encodeRoute(Route route) {
    return json.encode((route.settings as SPDRouteSettings).toJson());
  }

  /// Deserialise [data] to a [Route].
  /// @param [data]: The [Route]'s serialised settings.
  Route _decodeRoute(String data) {
    final SPDRouteSettings settings = SPDRouteSettings.fromJson(json.decode(data));
    final SPDRouteArguments? arguments = settings.arguments?.copyWith(restored: true);
    return onGenerateRoute(settings.copyWith(arguments: arguments));
  }

  /// Create the screen that corresponds to the route [settings.name]. Return a `404` error screen 
  /// if [settings.name] does not correspond to an existing screen.
  /// @param [settings]: The screen's [Route] settings.
  Widget screen(SPDRouteSettings settings) {
    final Map<String, dynamic> json = settings.parameters ?? {};
    switch(settings.name) {
      case SPDAppScaffold.routeName:
        return const SPDAppScaffold();
      case SPDHomeScreen.routeName:
        return const SPDHomeScreen();
      case SPDSwapScreen.routeName:
        return const SPDSwapScreen();
      case SPDStakeScreen.routeName:
        return const SPDStakeScreen();
      case SPDDiscoverScreen.routeName:
        return const SPDDiscoverScreen();
      case SPDFAQsScreen.routeName:
        return const SPDFAQsScreen();
      default:
        return const SPD404Screen();
    }
  }

  /// Return the [Route]s that will be loaded when the app first launches. 
  /// @param [route]: The default initial route name (see [MaterialApp.initialRoute]).
  List<Route<dynamic>> onGenerateInitialRoutes(String route) {
    return _initialRoutes.isEmpty 
      ? [onGenerateRoute(SPDRouteSettings(name: route))] 
      : _initialRoutes;
  }

  /// Create the `named` [Route] that corresponds to the given [RouteSettings]. If [settings.name] 
  /// does not refer to a named [Route], return a `404` error screen.
  /// @param [settings]: The screen's [Route] settings.
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final SPDRouteSettings routeSettings = SPDRouteSettings.fromRouteSettings(settings);
    return SPDNavigator.shared.buildRoute(
      (BuildContext context) => screen(routeSettings), 
      settings: routeSettings,
    );
  }
}