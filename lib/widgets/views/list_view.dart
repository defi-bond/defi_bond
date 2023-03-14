/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stake_pool_lotto/exceptions/exception_handler.dart';
import 'package:stake_pool_lotto/layouts/padding.dart';
import 'package:stake_pool_lotto/models/range.dart';
import 'package:stake_pool_lotto/utils/snackbar.dart';
import 'package:stake_pool_lotto/widgets/indicators/circular_progress_indicator.dart';
import '../../layouts/grid.dart';
import '../../models/list_event.dart';
import '../../models/list_model.dart';
import '../../models/list_operation.dart';
import '../../models/list_view_model.dart';
import '../buttons/primary_button.dart';
import '../images/info_graphic.dart';
import '../indicators/refresh_indicator.dart';


/// Enums and Types
/// ------------------------------------------------------------------------------------------------

/// Item builder.
typedef SPDListViewItemBuilder<T> = Widget Function(BuildContext context, int index, T item);

/// Error builder.
typedef SPDListViewErrorBuilder = Widget Function(BuildContext context, Object error);

/// Empty builder.
typedef SPDListViewEmptyBuilder = Widget Function(BuildContext context);

/// On Load.
typedef SPDListViewOnLoad<T> = FutureOr<SPDListEvent<T>> Function(int index, T? item);

/// On Refresh.
typedef SPDListViewOnRefresh<T> = FutureOr<SPDListEvent<T>> Function();

/// Progress status.
enum _SPDListViewStatus {
  none,
  loading,
  refreshing,
}


/// List View
/// ------------------------------------------------------------------------------------------------

class SPDListView<T> extends StatefulWidget {
  
  /// Creates a list that can dynamically modify its items using [onLoad]/[onEvent]/[onRefresh].
  const SPDListView({ 
    Key? key, 
    this.initialItems,
    required this.itemBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.onLoad,
    this.onEvent,
    this.onRefresh,
    this.controller,
    this.preloadLength = 4,
    this.itemExtent,
  }): super(key: key);

  /// The list's initial state.
  final SPDListEvent<T>? initialItems;

  /// The callback function to build a list item.
  /// @param [context]: The current build context.
  /// @param [index]: The [item]'s index position in the list.
  /// @param [item]: The item in the list to build a [Widget] for.
  final SPDListViewItemBuilder<T> itemBuilder;

  /// The callback function to build an error view when [onLoad]/[onEvent]/[onRefresh] fails.
  /// @param [context]: The current build context.
  /// @param [error]: The error thrown by the event.
  final SPDListViewErrorBuilder? errorBuilder;

  /// The callback function to build a view when the list is empty.
  /// @param [context]: The current build context.
  final SPDListViewEmptyBuilder? emptyBuilder;

  /// The callback function to modify the list's items as the user scrolls to the end of the list.
  /// @param [index]: [item]'s index position in the list or `-1` if the list is empty.
  /// @param [item]: The last item in the list, or `null` if the list is empty.
  final SPDListViewOnLoad<T>? onLoad;

  /// The stream of [SPDListEvent]s to modify the list's items at any time.
  final Stream<SPDListEvent<T>>? onEvent;

  /// The callback function to modify the list's items when the user drags down from the top.
  final SPDListViewOnRefresh<T>? onRefresh;

  /// The list's scroll controller.
  final ScrollController? controller;

  /// The threshold at which a call to [onLoad] is triggered in page lengths (default: `4`).
  /// 
  /// For example, if the list's view `height` = `100` and [preloadLength] = `4`, a call to
  /// [onLoad] will occur each time the remaining scroll height falls below `400` (i.e. `height` *
  /// [preloadLength]).
  final int preloadLength;

  /// The height of a single list item.
  final double? itemExtent;

  /// Create an instance of the class' state widget.
  @override
  SPDListViewState<T> createState() => SPDListViewState<T>();
}


/// List View State
/// ------------------------------------------------------------------------------------------------

class SPDListViewState<T> extends State<SPDListView<T>> {

  /// The list's items.
  @protected
  late SPDListModel<T> items;

  /// The future that completes once the view's initial items have been loaded.
  late Future<void> _futureInit;

  /// The list's `progress` status (See [_onLoad]/[_onRefresh]).
  _SPDListViewStatus _status = _SPDListViewStatus.none;

  /// The error thrown when a call to [widget.onLoad]/[widget.onEvent]/[widget.onRefresh] fails.
  Object? _error;

  /// The list's scroll controller.
  late ScrollController _controller;

  /// The scroll controller's debug label, which is used to ensure that [_controller] is disposed 
  /// only if it has been created by this class (See [_createController]/[_disposeController]).
  static const String _controllerLabel = 'SPDListView';

  /// The [widget.onEvent] stream subscription.
  StreamSubscription<SPDListEvent<T>>? _subscription;

  /// Create an [SPDListModel] to manage the items in the list.
  /// @param [initialItems]?: The list's initial items ([widget.initialItems?.items]).
  @protected
  SPDListModel<T> initModel(List<T>? initialItems) {
    return SPDListViewModel(initialItems ?? <T>[]);
  }

  /// Initialise the widget's state.
  @override
  void initState() {
    super.initState();
    
    items = initModel(widget.initialItems?.items);
    _controller = widget.controller ?? _createController();
    _subscription = widget.onEvent?.listen(_onEvent, onError: _onError, cancelOnError: false);

    if (widget.initialItems?.eol != true && widget.onLoad != null) {
      _controller.addListener(_onScroll);
    }

    _futureInit = widget.initialItems != null
      ? Future.value(null)
      : _onLoad();
  }

  /// Dispose of all acquired resources.
  @override
  void dispose() {
    _subscription?.cancel();
    _disposeController();
    super.dispose();
  }

  /// Update the widget's scroll [_controller] each time the [widget.controller] property changes.
  /// @param [oldWidget]: The widget's previous state.
  @override
  void didUpdateWidget(covariant SPDListView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {

      /// Remove the [_onScroll] listener from the previous controller.
      oldWidget.controller?.removeListener(_onScroll);

      /// If the current scroll [_controller] is not equal to the previous controller, then it is a 
      /// default controller created by this class and can now be disposed of.
      if (_controller != oldWidget.controller) {
        _disposeController();
      }

      /// Set [_controller] to the new scroll [widget.controller] or create a default controller.
      _controller = widget.controller ?? _createController(offset: oldWidget.controller?.offset);
      
      /// Attach the [_onScroll] listener to the new scroll [_controller].
      if (widget.onLoad != null) {
        _controller.addListener(_onScroll);
      }
    }
  }

  /// Set the list's [_error].
  /// @param [error]: The list's current error.
  void _setError(final Object? error) {
    if (error != _error) {
      setState(() => _error = error);
    }
  }

  /// Set the list's progress [_status].
  /// @param [status]: The list's progress status.
  void _setStatus(_SPDListViewStatus status) {
    if (_status != status) {
      setState(() => _status = status);
    }
  }

  /// Create a new [ScrollController].
  /// @param [offset]?: The controller's initial scroll offset (default: `0.0`).
  ScrollController _createController({ double? offset }) {
    return ScrollController(
      debugLabel: _controllerLabel,
      initialScrollOffset: offset ?? 0.0,
    );
  }

  /// Dispose of the current scroll [_controller] if it was created by this class 
  /// (See [_createController]).
  void _disposeController() {
    if (_controller != widget.controller) {
      assert(_controller.debugLabel == _controllerLabel);
      _controller.dispose();
    }
  }

  /// The scroll [_controller]'s event listener that triggers a call to [_onLoad] each time the user 
  /// scrolls to the end of the list.
  void _onScroll() {
    if (_status == _SPDListViewStatus.none && _error == null) {
      final ScrollPosition position = _controller.position;
      if(position.userScrollDirection == ScrollDirection.reverse) {
        final double threshold = widget.preloadLength * position.viewportDimension;
        if(position.extentAfter < threshold) {
          _onLoad();
        }
      }
    }
  }
  
  /// Handle [widget.onLoad]/[widget.onEvent]/[widget.onRefresh] errors. If the list is empty, store 
  /// the thrown exception so that the widget can build an error view (See [_futureBuilder] and 
  /// [_errorBuilder]). Else, display a snackbar message for the error.
  /// @param [error]: The error that caused the operation to fail.
  /// @param [stackTrack]: The error's stack trace.
  void _onError(Object error, [StackTrace? stackTrace]) {
    _setError(items.isEmpty ? error : null);
    if (items.isNotEmpty) {
      final String message = SPDExceptionHandler().message(error);
      SPLSnackbar.shared.error(context, message);
    } 
  }

  /// Handle an [SPDListEvent] to modify the list's items.
  /// @param [event]: The event to modify the list.
  void _onEvent(SPDListEvent<T> event) {
    if (mounted) {

      /// Clear the list's error.
      _setError(null);

      /// Clear the list's items.
      if (event.clear) {
        items.clear();
      }

      /// Get the range in which the modification is being applied.
      final SPDRange<int> range = event.range(items.length);

      /// Modify the list's items.
      switch(event.operation) {
        case SPDListOperation.insert:
          items.insertAll(range.start, event.items);
          break;
        case SPDListOperation.remove:
          event.items.isNotEmpty
            ? items.removeAll(event.items)
            : items.removeRange(range.start, range.end);
          break;
        case SPDListOperation.replace:
          items.replaceRange(range.start, range.end, event.items);
          break;
      }

      /// Remove the scroll [_controller]'s listener if the end of the list (`eol`) has been 
      /// reached, else add a listener if the list has been reset ([event.clear]).
      if(event.eol) {
        _controller.removeListener(_onScroll);
      } else if (event.clear) {
        _controller..removeListener(_onScroll)..addListener(_onScroll);
      }
    }
  }

  /// Call [widget.onLoad] to fetch the next batch of items.
  Future<void> _onLoad() async {
    if (widget.onLoad != null) {
      try {
        _setStatus(_SPDListViewStatus.loading);
        final int index = items.length - 1;
        final T? item = index != -1 ? items[index] : null;
        _onEvent(await widget.onLoad?.call(index, item) ?? SPDListEvent(<T>[]));
      } catch(error, stackTrace) {
        _onError(error, stackTrace);
      } finally {
        _setStatus(_SPDListViewStatus.none);
      }
    }
  }

  /// Call [widget.onRefresh] to update the list's items.
  Future<void> _onRefresh() async {
    if (widget.onRefresh != null) {
      try {
        _setStatus(_SPDListViewStatus.refreshing);
        _onEvent(await widget.onRefresh?.call() ?? SPDListEvent([]));
      } catch(error, stackTrace) {
        _onError(error, stackTrace);
      } finally {
        _setStatus(_SPDListViewStatus.none);
      }
    }
  }

  /// Build the list item at [index].
  /// @param [context]: The current build context.
  /// @param [index]: The index position of the item in the list to build.
  Widget _itemBuilder(BuildContext content, int index) {
    return widget.itemBuilder(context, index, items[index]);
  }

  /// Reset [_futureInit] to reload the view's initial items. This should only be called when the 
  /// list has no items and fails to load its initial items.
  void _onRetry() {
    _futureInit = _onLoad();
    setState(() {});
  }

  /// Build the widget that gets displayed when [widget.onLoad]/[widget.onEvent]/[widget.onRefresh] 
  /// fails and the list is empty.
  /// @param [error]: The error thrown by the operation.
  Widget _errorBuilder(Object error) {
    return Center(
      child: widget.errorBuilder?.call(context, error) ?? SPDInfoGraphic.error(
        error: error,
        actions: [
          if (widget.onLoad != null)
            SPDPrimaryButton(
              onPressed: _onRetry,
              child: const Text('Retry'), 
            ),
        ],
      ),
    );
  }

  /// Build the widget that gets displayed when the list is empty and does not have an [_error].
  Widget _emptyBuilder() {
    return Center(
      child: widget.emptyBuilder?.call(context) ?? SPDInfoGraphic.empty(),
    );
  }

  /// Build the list widget.
  @protected
  Widget buildList() {

    final delegate = SliverChildBuilderDelegate(
      _itemBuilder,
      childCount: items.length,
    );

    if (widget.itemExtent != null) {
      return SliverFixedExtentList(
        delegate: delegate, 
        itemExtent: widget.itemExtent!,
      );
    }

    return SliverList(
      delegate: delegate,
    );
  }

  /// Build the loading indicator widget.
  Widget _buildLoadingIndicator() {
    return Padding(
      padding: SPDEdgeInsets.shared.vertical(),
      child: SPDCircularProgressIndicator(
        radius: items.isEmpty ? null : SPDGrid.x2,
      ),
    );
  }

  /// Display a loading indicator until the future completes. If the future completes successfully, 
  /// build the current state of the widget. Else, build an error view. 
  /// @param [context]: The current build context.
  /// @param [snapshot]: The future builder's current state.
  Widget _futureBuilder(BuildContext context, AsyncSnapshot<void> snapshot) {

    if (snapshot.connectionState != ConnectionState.done) {
      return _buildLoadingIndicator();
    }
    
    final Object? error = snapshot.error ?? _error;
    if (error != null) {
      return _errorBuilder(error);
    }
    
     if (items.isEmpty) {
      return _emptyBuilder();
    }
    
    Widget view = CustomScrollView(
      controller: _controller,
      cacheExtent: widget.itemExtent,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: <Widget>[
        buildList(),
        SliverFillRemaining(
          hasScrollBody: false,
          child: _status == _SPDListViewStatus.loading 
            ? _buildLoadingIndicator() 
            : SizedBox.shrink(),
        ),
      ],
    );

    if (widget.onRefresh != null) {
      view = SPLRefreshIndicator(
        onRefresh: _onRefresh,
        child: view, 
      );
    }

    return view;
  }

  /// Build the final widget.
  /// @param [context]: The current build context.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureInit,
      builder: _futureBuilder,
    );
  }
}