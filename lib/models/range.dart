/// Range
/// ------------------------------------------------------------------------------------------------

class SPDRange<T extends num> {
  
  /// Defines a range from [start] (inclusive) to [end] (exclusive).
  const SPDRange(
    this.start,
    this.end,
  ): assert(start <= end);

  /// The start position (inclusive).
  final T start;

  /// The end position (exclusive).
  final T end;
}