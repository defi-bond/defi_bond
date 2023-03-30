/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'navigator_result.dart';
import 'navigator_transition.dart';
import '../routes/route_arguments.dart';
import '../routes/route_settings.dart';
import '../screens/permissions/permission_screen.dart';


/// Navigator
/// ------------------------------------------------------------------------------------------------

class SPDNavigator {

  /// Provides properties and methods for navigating through the application.
  const SPDNavigator._();

  /// The [SPDNavigator] class' singleton instance.
  static const SPDNavigator shared = SPDNavigator._();
  
  /// Return true if the [Route] at the top of the stack can be popped.
  bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  /// Push the [SSPPermissionScreen] onto the stack.
  /// @param [context]: The build context.
  /// @param [device]: The name of the device that permission is being requested for.
  @optionalTypeArgs
  Future<SPDNavigatorResult<T>?> permission<T extends Object>(
    BuildContext context, {
    required String device,
  }) {
    return push<T>(
      context,
      builder: (_) => SPDPermissionScreen(device: device),
      arguments: const SPDRouteArguments(
        transition: SPDNavigatorTransition.vertical,
      ),
    );
  }

  /// Pop the [Route] at the top of the stack for the given [context].
  /// @param [context]: The build context.
  /// @param [data]?: The data to return to the original caller ([SPDNavigatorResult.data]).
  /// @param [error]?: The error to return to the original caller ([SPDNavigatorResult.error]).
  @optionalTypeArgs
  void pop<T extends Object>(
    BuildContext context, {
    T? data,
    dynamic error,    
  }) {
    if (Navigator.canPop(context)) {
      final SPDNavigatorResult<T> result = SPDNavigatorResult<T>(data: data, error: error);
      return Navigator.pop<SPDNavigatorResult<T>?>(context, result.hasResult ? result : null);
    }
  }

  /// Remove the [Route] at the top of the stack for the given [context]. Then push the [Route] 
  /// identified by [routeName] onto the stack.
  /// @param [context]: The build context.
  /// @param [routeName]: The navigator route's name.
  /// @param [result]?: The result to return to the original caller ([SPDNavigatorResult]).
  /// @param [arguments]?: The arguments passed to the route being pushed.
  @optionalTypeArgs
  Future<SPDNavigatorResult<T>?> popAndPushNamed<T extends Object, TO extends Object>(
    BuildContext context, 
    String routeName, {
    SPDNavigatorResult<TO>? result,
    SPDRouteArguments? arguments,
  }) {
    return Navigator.popAndPushNamed<SPDNavigatorResult<T>?, SPDNavigatorResult<TO>>(
      context, 
      routeName, 
      result: result, 
      arguments: arguments,
    );
  }

  /// Push the [Route] returned by [builder] onto the stack for the given [context].
  /// @param [context]: The build context.
  /// @param [builder]: The callback function that builds the route's contents.
  /// @param [arguments]?: The arguments passed to the route being pushed.
  @optionalTypeArgs
  Future<SPDNavigatorResult<T>?> push<T extends Object>(
    BuildContext context, { 
    required WidgetBuilder builder,
    SPDRouteArguments? arguments,
  }) {
    return Navigator.push<SPDNavigatorResult<T>?>(
      context, 
      buildRoute<T>(builder, settings: SPDRouteSettings(arguments: arguments)),
    );
  }

  /// Push the [Route] returned by [builder] onto the stack for the given [context]. Then remove all 
  /// previous [Route]s until the [predicate] returns `true`.
  /// @param [context]: The build context.
  /// @param [builder]: The callback function that builds the route's contents.
  /// @param [predicate]?: The callback function that's passed each of the previous routes and 
  /// returns `true` if the route should be kept and `false` if the route should be removed 
  /// (default: `false` - i.e. remove all previous routes).
  /// @param [arguments]?: The arguments passed to the route being pushed.
  @optionalTypeArgs
  Future<SPDNavigatorResult<T>?> pushAndRemoveUntil<T extends Object>(
    BuildContext context, { 
    required WidgetBuilder builder,
    bool Function(Route)? predicate,
    SPDRouteArguments? arguments,
  }) {
    return Navigator.pushAndRemoveUntil<SPDNavigatorResult<T>?>(
      context,
      buildRoute<T>(builder, settings: SPDRouteSettings(arguments: arguments)),
      predicate ?? (Route<dynamic> _) => false,
    );
  }

  /// Push the [Route] identified by [routeName] onto the stack for the given [context].
  /// @param [context]: The build context.
  /// @param [routeName]: The navigator route's name.
  /// @param [arguments]?: The arguments passed to the route being pushed.
  @optionalTypeArgs
  Future<SPDNavigatorResult<T>?> pushNamed<T extends Object>(
    BuildContext context, 
    String routeName, {
    SPDRouteArguments? arguments,
  }) {
    return Navigator.pushNamed<SPDNavigatorResult<T>?>(
      context, 
      routeName, 
      arguments: arguments,
    );
  }

  /// Push the [Route] identified by [routeName] onto the stack for the given [context]. Then remove 
  /// all previous [Route]s until the [predicate] returns `true`.
  /// @param [context]: The build context.
  /// @param [routeName]: The navigator route's name.
  /// @param [predicate]?: The callback function that's passed each of the previous routes and 
  /// returns `true` if the route should be kept and `false` if the route should be removed 
  /// (default: `false` - i.e. remove all previous routes).
  /// @param [arguments]?: The arguments passed to the route being pushed.
  @optionalTypeArgs
  Future<SPDNavigatorResult<T>?> pushNamedAndRemoveUntil<T extends Object>(
    BuildContext context, 
    String routeName, {
    bool Function(Route<dynamic>)? predicate, 
    SPDRouteArguments? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil<SPDNavigatorResult<T>?>(
      context, 
      routeName,
      predicate ?? (Route<dynamic> _) => false,
      arguments: arguments,
    );
  }

  /// Push the [Route] returned by [builder] onto the stack for the given [context]. Then remove the 
  /// previous [Route] once the new route has finished animating into view.
  /// @param [context]: The build context.
  /// @param [builder]: The callback function that builds the route's contents.
  /// @param [result]?: The result to return to the caller ([SPDNavigatorResult]).
  /// @param [arguments]?: The arguments passed to the route being pushed.
  @optionalTypeArgs
  Future<SPDNavigatorResult<T>?> pushReplacement<T extends Object, TO extends Object>(
    BuildContext context, {
    required WidgetBuilder builder,
    SPDNavigatorResult<TO>? result,
    SPDRouteArguments? arguments,
  }) {
    return Navigator.pushReplacement<SPDNavigatorResult<T>?, SPDNavigatorResult<TO>>(
      context,
      buildRoute<T>(builder, settings: SPDRouteSettings(arguments: arguments)),
      result: result,
    );
  }

  /// Push the [Route] identified by [routeName] onto the stack for the given [context]. Then remove 
  /// the previous [Route] once [routeName] has finished animating into view.
  /// @param [context]: The build context.
  /// @param [routeName]: The navigator route's name.
  /// @param [result]?: The result to return to the original caller ([SPDNavigatorResult]).
  /// @param [arguments]?: The arguments passed to the route being pushed.
  @optionalTypeArgs
  Future<SPDNavigatorResult<T>?> pushReplacementNamed<T extends Object, TO extends Object>(
    BuildContext context, 
    String routeName, {
    SPDNavigatorResult<TO>? result,
    SPDRouteArguments? arguments,
  }) {
    return Navigator.pushReplacementNamed<SPDNavigatorResult<T>?, SPDNavigatorResult<TO>>(
      context, 
      routeName, 
      result: result, 
      arguments: arguments,
    );
  }

  /// Build a [Route] for the [Widget] returned by [builder].
  /// @param [builder]: The callback function that builds the route's contents.
  /// @param [settings]: The [Route]'s settings.
  @optionalTypeArgs
  Route<SPDNavigatorResult<T>?> buildRoute<T extends Object>(
    WidgetBuilder builder, {
    SPDRouteSettings? settings,
  }) {
    settings ??= const SPDRouteSettings();
    final SPDNavigatorTransition transition = settings.transition 
      ?? SPDNavigatorTransition.horizontal;
    switch(transition) {
      case SPDNavigatorTransition.vertical:
        return MaterialPageRoute<SPDNavigatorResult<T>?>(
          builder: builder,
          settings: settings,
          maintainState: settings.maintainState,
          fullscreenDialog: settings.fullscreenDialog,
        );
      case SPDNavigatorTransition.horizontal:
        return CupertinoPageRoute<SPDNavigatorResult<T>?>(
          builder: builder,
          settings: settings,
          maintainState: settings.maintainState,
          fullscreenDialog: settings.fullscreenDialog,
        );
    }
  }
}