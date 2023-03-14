/// [String] Extensions
/// ------------------------------------------------------------------------------------------------

extension SPDStringExtension on String {
  
  /// Returns a copy of this string with its first letter capitalised.
  String capitalise() {
    return isEmpty ? '' : this[0].toUpperCase() + substring(1);
  }

  /// Returns a copy of this string with each word in the string capitalised.
  String capitaliseWords() {
    const String separator = ' ';
    return split(separator).map((word) => word.capitalise()).join(separator);
  }
}