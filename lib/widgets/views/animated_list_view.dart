/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/animated_list_model.dart';
import '../../models/list_event.dart';
import '../../models/list_model.dart';
import 'list_view.dart';


/// Animated List View
/// ------------------------------------------------------------------------------------------------

class SPDAnimatedListView<T> extends SPDListView<T> {
  
  /// Creates an animated list that can dynamically modify its items using 
  /// [onLoad]/[onEvent]/[onRefresh].
  const SPDAnimatedListView({ 
    Key? key, 
    SPDListEvent<T>? initialItems,
    required SPDListViewItemBuilder<T> itemBuilder,
    SPDListViewErrorBuilder? errorBuilder,
    SPDListViewEmptyBuilder? emptyBuilder,
    SPDListViewOnLoad<T>? onLoad,
    Stream<SPDListEvent<T>>? onEvent,
    SPDListViewOnRefresh<T>? onRefresh,
    ScrollController? controller,
    int preloadLength = 4,
    double? itemExtent,
  }): super(
        key: key,
        initialItems: initialItems,
        itemBuilder: itemBuilder,
        errorBuilder: errorBuilder,
        emptyBuilder: emptyBuilder,
        onLoad: onLoad,
        onEvent: onEvent,
        onRefresh: onRefresh,
        controller: controller,
        preloadLength: preloadLength,
        itemExtent: itemExtent,
      );

  /// Create an instance of the class' state widget.
  @override
  SPDAnimatedListViewState<T> createState() => SPDAnimatedListViewState<T>();
}


/// Animated List View State
/// ------------------------------------------------------------------------------------------------

class SPDAnimatedListViewState<T> extends SPDListViewState<T> {

  /// The animated list's state, used to modify the underlying list.
  // final GlobalKey<SliverAnimatedListState> _key = GlobalKey<SliverAnimatedListState>();

  /// Create an [SPDListModel] to manage the items in the list.
  /// @param [items]?: The list's initial items ([widget.initialItems?.items]).
  @override
  SPDListModel<T> initModel(List<T>? items) {
    return SPDAnimatedListViewModel(
      items ?? <T>[],
      removedItemBuilder: _removedItemBuilder,
    );
  }

  /// Build the list item at [index].
  /// @param [context]: The current build context.
  /// @param [index]: The index position of the item in the list to build.
  /// @param [animation]: The list item's animation.
  Widget _itemBuilder
  (final BuildContext content, 
  final int index, 
  final Animation<double> animation,
  ) {
    return SizeTransition(
      sizeFactor: animation,
      child: widget.itemBuilder(context, index, items[index]),
    );
  }

  /// Build the removed list [item] for the animation.
  /// 
  /// Used to build an item after it has been removed from the list. This method is needed because a
  /// removed item remains visible until its animation has completed (even though it's gone as far
  /// this ListModel is concerned). The widget will be used by the
  /// [SliverAnimatedListState.removeItem] method's [SliverAnimatedListRemovedItemBuilder]
  /// parameter.
  /// 
  /// @param [context]: The current build context.
  /// @param [index]: The index position of the removed [item].
  /// @param [item]: The removed item.
  /// @param [animation]: The list item's animation.
  Widget _removedItemBuilder(
    final BuildContext context, 
    final int index, 
    final T item, 
    final Animation<double> animation,
  ) {
    return SizeTransition(
      sizeFactor: animation,
      child: widget.itemBuilder(context, index, item),
    );
  }

  /// Build the animated list widget.
  @override
  Widget buildList() {
    return SliverAnimatedList(
      key: items.key,
      itemBuilder: _itemBuilder,
      initialItemCount: items.length,
    );
  }
}