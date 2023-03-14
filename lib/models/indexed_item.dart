/// Indexed Item
/// ------------------------------------------------------------------------------------------------

class SPDIndexedItem<T> {

  /// Stores the [index] position that corresponds to a list [item].
  const SPDIndexedItem({
    required this.index,
    required this.item,
  });

  /// The [item]'s index position.
  final int index;

  /// The [item]'s data.
  final T item;
}