/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:math' show max;
import 'list_operation.dart';
import 'range.dart';


/// List Event
/// ------------------------------------------------------------------------------------------------

class SPDListEvent<T> {

  /// [EOL] = `End of list`.
  /// 
  /// Defines a list [operation] for [items]. An [SPDListView] uses [SPDListEvent] to modify the 
  /// contents of its list (i.e. insert, remove or update [items]).
  const SPDListEvent(
    List<T>? items, {
    this.start,
    this.end,
    this.eol = false,
    this.clear = false,
    this.operation = SPDListOperation.insert,
  }): items = items ?? const [];

  /// The list items of the [operation].
  final List<T> items;

  /// The start position (inclusive) to apply an [SPDListOperation.insert] or 
  /// [SPDListOperation.replace] operation. (default: `list length`).
  final int? start;

  /// The end position (exclusive) of the range [start:end] for an [SPDListOperation.remove] or 
  /// [SPDListOperation.replace] operation. (default: `list length`).
  final int? end;

  /// If true, the end of the list has been reached ([eol] = `end of list`).
  final bool eol;

  /// If true, clear the current list before applying the [operation].
  final bool clear;

  /// The operation being applied to the list.
  /// [SPDListOperation.insert]: 
  ///   - Insert [items] into the list at position [index].
  /// [SPDListOperation.remove]: 
  ///   - Remove [items] -or- range [start:end] from the list.
  /// [SPDListOperation.replace]: 
  ///   - Replace range [start:end] with [items].
  final SPDListOperation operation;

  /// Return a copy of `this` instance.
  /// @params [*]: The values to overwrite the existing properties.
  SPDListEvent<T> copyWith({
    List<T>? items,
    int? start,
    int? end,
    bool? eol,
    bool? clear,
    SPDListOperation? operation,
  }) {
    return SPDListEvent<T>(
      items ?? this.items,
      start: start ?? this.start,
      end: end ?? this.end,
      eol: eol ?? this.eol,
      clear: clear ?? this.clear,
      operation: operation ?? this.operation,
    );
  }

  /// Return the start index of the current operation, normalised to the list's index range.
  /// @param [length]: The list's current length.
  int index(int length) {
    return (start ?? length).clamp(0, length);
  }

  /// Return the index range of the current operation, normalised to the list's index range.
  /// @param [length]: The list's current length.
  SPDRange<int> range(int length) {
    final int si = index(length);
    final int ei = end ?? length;
    return SPDRange<int>(si, max(si, ei));
  }
}