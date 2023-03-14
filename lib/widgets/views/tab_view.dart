/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'page_view.dart';


/// Tab View
/// ------------------------------------------------------------------------------------------------

class SPLTabView extends StatefulWidget {
  
  /// Creates an [SPLPageView] with one tab per page. The length of [children] must equal the 
  /// [controller]'s length.
  const SPLTabView({ 
    Key? key,
    required this.children,
    this.controller,
    this.physics,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  }): super(key: key);

  /// The tab views.
  final List<Widget> children;
  
  /// The tab controller. If `null`, there must be a [DefaultTabController] ancestor in the widget 
  /// tree.
  final TabController? controller;

  /// The scroll physics (default: [BouncingScrollPhysics]).
  final ScrollPhysics? physics;

  /// The alignment along the vertical axis (default: [CrossAxisAlignment.center]).
  final CrossAxisAlignment crossAxisAlignment;

  /// Create an instance of the class' state widget.
  @override
  _SPLTabViewState createState() => _SPLTabViewState();
}


/// Tab View State
/// ------------------------------------------------------------------------------------------------

class _SPLTabViewState extends State<SPLTabView> {

  /// The [OAPageView]'s scroll controller.
  late PageController _pageController;

  /// The tab controller.
  TabController? _tabController;

  /// The current index.
  late int _tabIndex;

  /// A simple mutex counter.
  int _mutexCount = 0;

  /// Return the tab controller's current offset.
  double get _offset {
    return ((_pageController.page ?? 0) - _tabController!.index).clamp(-1.0, 1.0);
  }

  /// Initialise the widget's state.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setTabController();
    _tabIndex = _tabController!.index;
    _pageController = PageController(initialPage: _tabIndex);
  }

  /// Dispose of all acquired resources.
  @override
  void dispose() {
    _tabController?.animation?.removeListener(_onTabControllerAnimationTick);
    _tabController = null;
    _pageController.dispose();
    super.dispose();
  }
  
  /// Update the widget's tab controller each time it changes.
  /// @param [oldWidget]: The widget's previous state.
  @override
  void didUpdateWidget(covariant SPLTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _setTabController();
    }
  }

  /// Return true if [controller] has been defined, else throw an exception.
  /// @param [controller]: The current tab controller.
  bool _debugTabController(TabController? controller) {
    if (controller != null) { 
      return true;
    }
    throw FlutterError(
      'No TabController for ${widget.runtimeType}.\n'
      'When creating a ${widget.runtimeType}, you must either provide an explicit '
      'TabController using the "controller" property, or you must ensure that there '
      'is a DefaultTabController above the ${widget.runtimeType}.\n'
      'In this case, there was neither an explicit controller nor a default controller.',
    );
  }

  /// Return true if the current tab controller ([_tabController]) and [widget.children] have the 
  /// same length, else throw an exception.
  bool _debugLength() {
    if (_tabController!.length == widget.children.length) {
      return true;
    }
    throw FlutterError(
      "Controller's length property (${_tabController!.length}) does not match the "
      "number of tabs (${widget.children.length}) present in SSPTabView's children property.",
    );
  }

  /// Set [_tabController].
  void _setTabController() {
  
    final TabController? tabController = widget.controller ?? DefaultTabController.of(context);
    assert(_debugTabController(tabController));

    if (tabController == _tabController) {
      return;
    }

    _tabController?.animation?.removeListener(_onTabControllerAnimationTick);
    tabController?.animation?.addListener(_onTabControllerAnimationTick);
    _tabController = tabController;
  }

  /// Animate the page controller to the current page ([_tabIndex]).
  Future<void> _animatedPageToCurrentIndex() async {
    if (!mounted || _pageController.page == _tabIndex.toDouble()) {
      return null;
    }

    _mutexCount += 1;

    await _pageController.animateToPage(
      _tabIndex, 
      duration: kTabScrollDuration, 
      curve: Curves.ease,
    );

    _mutexCount -= 1;
  }

  /// Update the page controller each time the tab controller's position changes.
  void _onTabControllerAnimationTick() {
  
    if (_mutexCount > 0 || !_tabController!.indexIsChanging) {
      return; // This widget is driving the controller's animation.
    }

    if (_tabController!.index != _tabIndex) {
      _tabIndex = _tabController!.index;
      _animatedPageToCurrentIndex();
    }
  }

  /// Update the tab controller for the current scroll position each time the page scrolls.
  /// @param [notification]: The scroll notification.
  bool _onNotification(ScrollNotification notification) {
     
    if (_mutexCount > 0 || notification.depth != 0) {
      return false;
    }

    _mutexCount += 1;

    if (!_tabController!.indexIsChanging && notification is ScrollUpdateNotification) {
      if ((_pageController.page! - _tabController!.index).abs() > 1.0) {
        _tabController!.index = _pageController.page!.floor();
        _tabIndex = _tabController!.index;
      }
      _tabController!.offset = _offset;
    } else if (notification is ScrollEndNotification) {
      _tabController!.index = _pageController.page!.round();
      _tabIndex = _tabController!.index;
      if (!_tabController!.indexIsChanging) {
        _tabController!.offset = _offset;
      }
    }

    _mutexCount -= 1;

    return false;
  }

  /// Build the final widget.
  /// @param [context]: The current build context.
  @override
  Widget build(BuildContext context) {
    assert(_debugLength());
    return NotificationListener<ScrollNotification>(
      onNotification: _onNotification,
      child: SPLPageView(
        controller: _pageController,
        physics: widget.physics,
        crossAxisAlignment: widget.crossAxisAlignment,
        children: widget.children,
      ),
    );
  }
}