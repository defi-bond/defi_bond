/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart' show Key, protected;


/// List Model
/// ------------------------------------------------------------------------------------------------

abstract class SPDListModel<T> {

  /// Provides properties and methods for accessing and modifying a list's [items].
  const SPDListModel(this.items);

  /// The list's items.
  @protected
  final List<T> items;

  // Return the list's state key.
  Key? get key => null;

  /// Return the number of items in the list.
  int get length {
    return items.length;
  }

  /// Return the index position of the last element in the list, or `-1` if the list is empty.
  int get lastIndex {
    return items.length - 1;
  }

  /// Return true if the list contains no items.
  bool get isEmpty {
    return items.isEmpty;
  }

  /// Return true if the list contains one or more items.
  bool get isNotEmpty {
    return items.isNotEmpty;
  }

  /// Return the first item in the list or `null` if the list is empty.
  T? get first {
    return isEmpty ? null : items.first;
  }

  /// Return the last item in the list or `null` if the list is empty.
  T? get last {
    return isEmpty ? null : items.last;
  }

  /// Return the item in the list at [index].
  /// @param [index]: A value in the range of [0:length-1].
  T operator [](int index) {
    return items[index];
  }

  /// Return the index position of [item] or `-1` if [item] is not an element in the list.
  /// @param [item]: The list item to return the index position of.
  int indexOf(T item) {
    return items.indexOf(item);
  }

  /// Return the element at [index] or `null` if [index] is out of range.
  /// @param [index]: Any integer value.
  T? elementAt(int index) {
    return index < 0 || index >= length ? null : items[index];
  }

  /// Add [item] to the end of the list.
  /// @param [item]: The item to add to the list.
  void add(T item);

  /// Add [items] to the end of the list.
  /// @param [items]: The list of items to add to the list.
  void addAll(Iterable<T> items);

  /// Insert [item] into the list at position [index].
  /// @param [index]: The position to insert the item at.
  /// @param [item]: The item to insert into the list.
  void insert(int index, T item);

  /// Insert [items] into the list a position [index].
  /// @param [index]: The position to insert the item at.
  /// @param [items]: The list of items to insert into the list.
  void insertAll(int index, Iterable<T> items);

  /// Remove the first occurrence of [item] from the list. Return `true` if the [item] was in the 
  /// list and `false` if not.
  /// @param [item]: The item to remove from the list.
  bool remove(T item);

  /// Remove the first occurrence of all [items] from the list. Return the number of items that 
  /// were in the list.
  /// @param [items]: The list of items to remove from the list.
  int removeAll(Iterable<T> items);

  /// Remove the item at position [index] from the list. Return the removed item.
  /// @param [index]: The index position of the item to remove from the list.
  T removeAt(int index);

  /// Remove all items in the range [start:end].
  /// @param [start]: The start position (inclusive).
  /// @param [end]: The end position (exclusive).
  void removeRange(int start, int end);

  /// Replace all items in the range [start:end] with [items].
  /// @param [start]: The start position (inclusive).
  /// @param [end]: The end position (exclusive).
  /// @param [items]: The list of items to add to the list.
  void replaceRange(int start, int end, Iterable<T> items);

  /// Remove all items in the list.
  void clear();
}