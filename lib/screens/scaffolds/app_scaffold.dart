/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:stake_pool_lotto/layouts/padding.dart';
import 'package:stake_pool_lotto/themes/colors/color.dart';
import '../discover/discover_screen.dart';
import '../errors/404_screen.dart';
import '../stake/stake_screen.dart';
import '../swap/swap_screen.dart';
import '../../icons/dream_drops_icons.dart';
import '../../screens/home/home_screen.dart';
import '../../storage/storage_key.dart';
import '../../storage/user_data_storage.dart';


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
  factory SPDAppScaffold.fromJson(final Map<String, dynamic> json) {
    return const SPDAppScaffold();
  }

  @override
  SPDAppScaffoldState createState() => SPDAppScaffoldState();
}


/// Application Scaffold State
/// ------------------------------------------------------------------------------------------------

class SPDAppScaffoldState extends State<SPDAppScaffold> {

  /// The index position of the active screen.
  late int _index;

  /// The [PageView]'s scroll controller.
  late PageController _controller;

  // /// The screen observers that get notified when a change happens.
  // final Map<int, SPDScreenObserver> _observers = {};

  // final List<Widget> screens = [
  //   const SPDHomeScreen(),
  //   const SPDSwapScreen(),
  //   const SPDStakeScreen(),
  //   const SPDDiscoverScreen(),
  // ];

  /// The storage key used to save/restore the active screens index position.
  String get _storageKey {
    return SPDStorageKey.screenIndex;
  }

  /// The [SPDUserDataStorage] singleton instance.
  SPDUserDataStorage get _prefs {
    return SPDUserDataStorage.shared;
  }

  @override
  void initState() {
    super.initState();
    _index = _prefs.getInt(_storageKey) ?? 0;
    _controller = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    // SPDAppScaffold.observer.unsubscribe(this);
    _controller.dispose();
    // _disposeObservers();
    super.dispose();
  }

  // /// Dispose of all screen observer ([_observers]).
  // void _disposeObservers() {
  //   for (final observer in _observers.values) {
  //     observer.dispose();
  //   }
  //   _observers.clear();
  // }

  /// Subscribe to the [RouteObserver].
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // SPDAppScaffold.observer.subscribe(this, ModalRoute.of(context)!);
  }

  // /// Called when the current route has been popped off.
  // @override
  // void didPop() {
  //   _didDisappear(_index);
  // }

  // // Called when the top route has been popped off, and the current route shows up.
  // @override
  // void didPopNext() {
  //   _didAppear(_index);
  // }

  // /// Called when the current route has been pushed.
  // @override
  // void didPush() {
  //   _didAppear(_index);
  // }

  // /// Called when a new route has been pushed, and the current route is no longer visible.
  // @override
  // void didPushNext() {
  //   _didDisappear(_index);
  // }

  // /// Notifies all listeners of screen [index] that it has become the top-most view.
  // void _didAppear(final int index) {
  //   _observers[index]?.didAppear();
  // }

  // /// Notifies all listeners of screen [index] that it is no longer the top-most view.
  // void _didDisappear(final int index) {
  //   _observers[index]?.didDisappear();
  // }

  /// Sets [_index].
  void _setIndex(final int index) {
    if (mounted && index != _index) {
      setState(() => _index = index);
    }
  }

  /// Saves sthe [index] position of the active screen and notify the listeners.
  void _onPageChanged(final int index) {
    _prefs.setInt(_storageKey, index).ignore();
    // _didDisappear(_index);
    // _didAppear(index);
    _setIndex(index);
  }

  /// Navigates to screen [index]. If screen [index] is the current screen, notify all listeners of 
  /// screen [index] that its navigation button has been pressed while it is already active.
  void _onNavBarItemPressed(final int index) {
    print('CONTROLLER PAGE = ${_controller.page}, INDEX $index');
    if (index != _index) {
      _controller.jumpToPage(index);
    }
    // index != _index
    //   ? _controller.jumpToPage(index)
    //   : _observers[index]?.didFocus();
  }

  // /// Returns the observer for the screen at [index].
  // SPDScreenObserver _observer(final int index) {
  //   return _observers[index] ??= SPDScreenObserver();
  // }

  /// Builds the screen at [index].
  Widget _screenBuilder(final BuildContext context, final int index) {
    // final SPDScreenObserver observer = _observer(index);
    // return index < screens.length ? screens[index] : const SPD404Screen();
    switch(index) {
      case 0:
        return const SPDHomeScreen();
      case 1:
        return const SPDSwapScreen();
      case 2:
        return const SPDStakeScreen();
      case 3:
        return const SPDDiscoverScreen();
      default:
        return const SPD404Screen();
    }
  }

  /// Builds the final widget.
  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: SPDEdgeInsets.shared.horizontal(),
          child: PageView.builder(
            controller: _controller,
            itemBuilder: _screenBuilder,
            onPageChanged: _onPageChanged,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: _onNavBarItemPressed,
          selectedItemColor: SPDColor.shared.font,
          unselectedItemColor: SPDColor.shared.primary8,
          backgroundColor: SPDColor.shared.primary1,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(SPDIcons.homefill),
            ),
            BottomNavigationBarItem(
              label: 'Swap',
              icon: Icon(SPDIcons.reverse),
            ),
            BottomNavigationBarItem(
              label: 'Stake',
              icon: Icon(SPDIcons.walletfill),
            ),
            BottomNavigationBarItem(
              label: 'Discover',
              icon: Icon(SPDIcons.discoverfill),
            ),
          ],
        ),
        // bottomNavigationBar: SPLNavBar(
        //   onPressed: _onNavBarItemPressed,
        //   initialIndex: _index,
        //   children: [
        //     SPDNavBarItem(
        //       icon: SPDIcons.homefill,
        //     ),
        //     SPDNavBarItem(
        //       icon: SPDIcons.reverse,
        //     ),
        //     SPDNavBarItem(
        //       icon: SPDIcons.walletfill,
        //     ),
        //     SPDNavBarItem(
        //       icon: SPDIcons.discoverfill,
        //     ),
        //   ],
        // ),
      ),
    );
  }
}


// /// Navigation View
// /// ------------------------------------------------------------------------------------------------

// class _SPLNavView extends StatefulWidget {
  
//   const _SPLNavView({ 
//     required this.observer, 
//     required this.child,
//   });

//   final SPDScreenObserver observer;

//   final Widget child;

//   @override
//   _SPLNavViewState createState() => _SPLNavViewState();
// }


// /// Navigation View State
// /// ------------------------------------------------------------------------------------------------

// class _SPLNavViewState extends State<_SPLNavView> with SPDScreenAware {

//   @override
//   void initState() {
//     super.initState();
//     // widget.observer.subscribe(this);
//   }

//   @override
//   void dispose() {
//     // widget.observer.unsubscribe(this);
//     super.dispose();
//   }

//   @override
//   Widget build(final BuildContext context) => widget.child;
// }