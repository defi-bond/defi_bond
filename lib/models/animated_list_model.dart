/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../utils/duration.dart';
import 'list_model.dart';


/// Animated List View Model
/// ------------------------------------------------------------------------------------------------

class SPDAnimatedListViewModel<T> extends SPDListModel<T> {

  /// Source: `https://flutter.dev/docs/catalog/samples/animated-list`
  /// Keeps a Dart List in sync with an AnimatedList. The methods that change the list apply to
  /// both the internal list and the animated list that belongs to [key].
  SPDAnimatedListViewModel(
    final List<T> initialItems, {
    required this.removedItemBuilder,
  }): super(initialItems);

  /// The animated list's state.
  @override
  final GlobalKey<SliverAnimatedListState> key = GlobalKey<SliverAnimatedListState>();

  /// The callback function to build a removed list item.
  final Widget Function(
    BuildContext context, int index, T item, Animation<double> animation
  ) removedItemBuilder;

  /// Return the animated list's current state.
  SliverAnimatedListState? get _animatedList {
    return key.currentState;
  }

  /// Add [item] to the end of the list.
  /// @param [item]: The item to add to the list.
  @override
  void add(T item) {
    insert(items.length, item);
  }

  /// Add [items] to the end of the list.
  /// @param [items]: The list of items to add to the list.
  @override
  void addAll(final Iterable<T> items) {
    for(final T item in items) {
      insert(this.items.length, item);
    }
  }

  /// Insert [item] into the list at position [index].
  /// @param [index]: The position to insert the item at.
  /// @param [item]: The item to insert into the list.
  @override
  void insert(final int index, final T item) {
    items.insert(index, item);
    _animatedList?.insertItem(index);
  }

  /// Insert [item] into the list a position [index].
  /// @param [index]: The position to insert the item at.
  /// @param [items]: The list of items to insert into the list.
  @override
  void insertAll(int index, final Iterable<T> items) {
    for(final T item in items) {
      insert(index++, item);
    }
  }

  /// Remove the first occurrence of [item] from the list. Return `true` if the [item] was in the 
  /// list and `false` if not.
  /// @param [item]: The item to remove from the list.
  @override
  bool remove(final T item) {
    return removeAt(items.indexOf(item)) != null;
  }

  /// Remove the first occurrence of all [items] from the list. Return the number of items that 
  /// were in the list.
  /// @param [items]: The list of items to remove from the list.
  @override
  int removeAll(final Iterable<T> items) {
    int count = 0;
    for (final T item in items) {
      if (remove(item)) {
        ++count;
      }
    }
    return count;
  }

  /// Remove the item at position [index] from the list. Return the removed item.
  /// @param [index]: The index position of the item to remove from the list.
  @override
  T removeAt(final int index) {
    final T removedItem = this.items.removeAt(index);
    _animatedList?.removeItem(
      index,
      (BuildContext context, Animation<double> animation) =>
        removedItemBuilder(context, index, removedItem, animation),
      duration: SPDDuration.fast,
    );
    return removedItem;
  }

  /// Remove all items in the range [start:end].
  /// @param [start]: The start position (inclusive).
  /// @param [end]: The end position (exclusive).
  @override
  void removeRange(final int start, final int end) {
    for(int i = start; i < end; ++i) {
      removeAt(start);
    }
  }

  /// Replace all items in the range [start:end] with [items].
  /// @param [start]: The start position (inclusive).
  /// @param [end]: The end position (exclusive).
  /// @param [items]: The list of items to add to the list.
  @override
  void replaceRange(final int start, final int end, final Iterable<T> items) {
    removeRange(start, end);
    insertAll(start, items);
  }

  /// Remove all items in the list.
  @override
  void clear() {
    for(int i = 0; i < items.length; ++i) {
      _animatedList?.removeItem(
        0, 
        (BuildContext context, Animation<double> animation) => const SizedBox.shrink(),
        duration: SPDDuration.fast,
      );
    }
    items.clear();
  }
}