/// Imports
/// ------------------------------------------------------------------------------------------------

import 'list_model.dart';


/// List View Model
/// ------------------------------------------------------------------------------------------------

class SPDListViewModel<T> extends SPDListModel<T> {

  /// Provides properties and methods for accessing and modifying a list's [items].
  const SPDListViewModel(
    List<T> initialItems,
  ): super(initialItems);

  /// Add [item] to the end of the list.
  /// @param [item]: The item to add to the list.
  @override
  void add(T item) {
    items.add(item);
  }

  /// Add [items] to the end of the list.
  /// @param [items]: The list of items to add to the list.
  @override
  void addAll(Iterable<T> items) {
    this.items.addAll(items);
  }

  /// Insert [item] into the list at position [index].
  /// @param [index]: The position to insert the item at.
  /// @param [item]: The item to insert into the list.
  @override
  void insert(int index, T item) {
    items.insert(index, item);
  }

  /// Insert [items] into the list a position [index].
  /// @param [index]: The position to insert the item at.
  /// @param [items]: The list of items to insert into the list.
  @override
  void insertAll(int index, Iterable<T> items) {
    this.items.insertAll(index, items);
  }

  /// Remove the first occurrence of [item] from the list. Return `true` if the [item] was in the 
  /// list and `false` if not.
  /// @param [item]: The item to remove from the list.
  @override
  bool remove(T item) {
    return items.remove(item);
  }

  /// Remove the first occurrence of all [items] from the list. Return the number of items that 
  /// were in the list.
  /// @param [items]: The list of items to remove from the list.
  @override
  int removeAll(Iterable<T> items) {
    int count = 0;
    for (final T item in items) {
      if (this.items.remove(item)) {
        ++count;
      }
    }
    return count;
  }

  /// Remove the item at position [index] from the list. Return the removed item.
  /// @param [index]: The index position of the item to remove from the list.
  @override
  T removeAt(int index) {
    return items.removeAt(index);
  }

  /// Remove all items in the range [start:end].
  /// @param [start]: The start position (inclusive).
  /// @param [end]: The end position (exclusive).
  @override
  void removeRange(int start, int end) {
    items.removeRange(start, end);
  }

  /// Replace all items in the range [start:end] with [items].
  /// @param [start]: The start position (inclusive).
  /// @param [end]: The end position (exclusive).
  /// @param [items]: The list of items to add to the list.
  @override
  void replaceRange(int start, int end, Iterable<T> items) {
    this.items.replaceRange(start, end, items);
  }

  /// Remove all items in the list.
  @override
  void clear() {
    items.clear();
  }
}