/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../errors/404_screen.dart';
import '../../icons/stake_pool_drops_icons.dart';
import '../../mixin/screen_aware.dart';
import '../../models/nav_bar_item.dart';
import '../../observers/screen_observer.dart';
import '../../screens/home/home_screen.dart';
import '../../storage/storage_key.dart';
import '../../storage/user_data_storage.dart';
import '../../widgets/bars/nav_bar.dart';


/// Application Scaffold
/// ------------------------------------------------------------------------------------------------

class SPDAppScaffold extends StatefulWidget {
  
  /// The application's main structure (nav bar and screens).
  const SPDAppScaffold({ 
    Key? key,
  }): super(key: key);

  /// Navigator route name.
  static const String routeName = '/';

  /// The navigation route observer. This must be registered with a [Navigator].
  /// For example: MaterialApp(navigatorObservers: [SPDAppScaffold.observer, ...]).
  static final RouteObserver<ModalRoute> observer = RouteObserver();

  /// Serialise this class into a json object.
  Map<String, dynamic> toJson() => {};

  /// Create an instance of this class from the given json object.
  /// @param [json]: A map containing the class' constructor parameters.
  factory SPDAppScaffold.fromJson(Map<String, dynamic> json) {
    return const SPDAppScaffold();
  }

  /// Create an instance of the class' state widget.
  @override
  SPDAppScaffoldState createState() => SPDAppScaffoldState();
}


/// Application Scaffold State
/// ------------------------------------------------------------------------------------------------

class SPDAppScaffoldState extends State<SPDAppScaffold> with RouteAware {

  /// The index position of the active screen.
  late int _index;

  /// The [PageView]'s scroll controller.
  late PageController _controller;

  /// The screen observers that get notified when a change happens.
  final Map<int, SPDScreenObserver> _observers = {};

  /// Return the storage key used to save/restore the active screens index position.
  String get _storageKey {
    return SPDStorageKey.screenIndex;
  }

  /// Return the [SPDUserDataStorage] singleton instance.
  SPDUserDataStorage get _prefs {
    return SPDUserDataStorage.shared;
  }

  /// Initialise the widget's state.
  @override
  void initState() {
    super.initState();
    _index = _prefs.getInt(_storageKey) ?? 0;
    _controller = PageController(initialPage: _index);
  }

  /// Dispose of all acquired resources.
  @override
  void dispose() {
    SPDAppScaffold.observer.unsubscribe(this);
    _controller.dispose();
    _disposeObservers();
    super.dispose();
  }

  /// Dispose of all screen observer ([_observers]).
  void _disposeObservers() {
    for (final observer in _observers.values) {
      observer.dispose();
    }
    _observers.clear();
  }

  /// Subscribe to the [RouteObserver].
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SPDAppScaffold.observer.subscribe(this, ModalRoute.of(context)!);
  }

  /// Called when the current route has been popped off.
  @override
  void didPop() {
    _didDisappear(_index);
  }

  // Called when the top route has been popped off, and the current route shows up.
  @override
  void didPopNext() {
    _didAppear(_index);
  }

  /// Called when the current route has been pushed.
  @override
  void didPush() {
    _didAppear(_index);
  }

  /// Called when a new route has been pushed, and the current route is no longer visible.
  @override
  void didPushNext() {
    _didDisappear(_index);
  }

  /// Notify all listeners of screen [index] that it has become the top-most view.
  void _didAppear(int index) {
    _observers[index]?.didAppear();
  }

  /// Notify all listeners of screen [index] that it is no longer the top-most view.
  void _didDisappear(int index) {
    _observers[index]?.didDisappear();
  }

  /// Set [_index].
  /// @param [index]: The index position of the active item.
  void _setIndex(int index) {
    if (index != _index) {
      _index = index;
    }
  }

  /// Save the [index] position of the active screen and notify the listeners.
  /// @param [index]: The index position of the active screen.
  void _onPageChanged(int index) {
    _prefs.setInt(_storageKey, index);
    _didDisappear(_index);
    _didAppear(index);
    _setIndex(index);
  }

  /// Navigate to screen [index]. If screen [index] is the current screen, notify all listeners of 
  /// screen [index] that its navigation button has been pressed while it is already active.
  /// @param [index]: The navigation item's index position.
  void _onNavBarItemPressed(int index) {
    index != _index
      ? _controller.jumpToPage(index)
      : _observers[index]?.didFocus();
  }

  /// Return the observer for the screen at [index].
  /// @param [index]: The screen's index position.
  SPDScreenObserver _observer(int index) {
    return _observers[index] ??= SPDScreenObserver();
  }

  /// Build the screen at [index].
  /// @param [context]: The current build context.
  /// @param [index]: The screen's index position.
  Widget _screenBuilder(BuildContext context, int index) {
    final SPDScreenObserver observer = _observer(index);
    switch(index) {
      case 0:
        return _SPLNavView(
          observer: observer, 
          child: const SPDHomeScreen(),
        );
      default:
        return const SPD404Screen();
    }
  }

  /// Build the final widget.
  /// @param [context]: The current build context.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView.builder(
          controller: _controller,
          itemBuilder: _screenBuilder,
          onPageChanged: _onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
        ),
        // bottomNavigationBar: SPLNavBar(
        //   onPressed: _onNavBarItemPressed,
        //   initialIndex: _index,
        //   children: [
        //     SPDNavBarItem(
        //       icon: SPDIcons.home,
        //     ),
        //     SPDNavBarItem(
        //       icon: SPDIcons.notification
        //     ),
        //     SPDNavBarItem(
        //       icon: SPDIcons.tick
        //     ),
        //   ],
        // ),
      ),
    );
  }
}




class _SPLNavView extends StatefulWidget {
  
  const _SPLNavView({ 
    super.key,
    required this.observer, 
    required this.child,
  });

  final SPDScreenObserver observer;

  final Widget child;

  @override
  __SPLNavViewState createState() => __SPLNavViewState();
}

class __SPLNavViewState extends State<_SPLNavView> with SPDScreenAware {

  @override
  void initState() {
    super.initState();
    widget.observer.subscribe(this);
  }

  @override
  void dispose() {
    widget.observer.unsubscribe(this);
    super.dispose();
  }

  @override
  void didAppear() {
    print("VIEW DID APPEAR: ${widget}");
  }

  @override
  void didDisappear() {
    print("VIEW DID DISAPPEAR: ${widget}");
  }

  @override
  void onNavBarItemPressed() {
    print("NAV PRESSED: ${widget}");
  }

  @override
  Widget build(BuildContext context) => widget.child;
}