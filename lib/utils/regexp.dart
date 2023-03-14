/// Regular Expression
/// ------------------------------------------------------------------------------------------------

class SPDRegExp {

  /// Provides properties and methods for common regular expressions.
  const SPDRegExp._();

  /// The [SPDRegExp] class' singleton instance.
  static const SPDRegExp shared = SPDRegExp._();

  /// Return a basic regular expression for matching a potential email address.
  RegExp get email {
    return RegExp(r'^\s*[^@\s]+@[^@\s]+(\.[^.@\s]+)+\s*$', unicode: true);
  }

  /// Return a basic regular expression for matching a potential phone number.
  RegExp get phone {
    return RegExp(r'^\s*[+]?\s*\d((-\s*\d)|[\s\d])*$', unicode: true);
  }

  /// Return a regular expression for matching a whitespace only string.
  RegExp get whitespace {
    return RegExp(r'^\s*$', unicode: true, multiLine: true);
  }

  /// Return true if [value] is a valid email address.
  /// @param [value]: Any string.
  bool isEmail(String value) {
    return email.hasMatch(value);
  }

  /// Return true if [value] is a valid phone number.
  /// @param [value]: Any string.
  bool isPhone(String value) {
    return phone.hasMatch(value);
  }

  /// Return true if [value] is a whitespace only string.
  /// @param [value]: Any string.
  bool isWhitespace(String value) {
    return whitespace.hasMatch(value);
  }

  /// Return true if [value] is a whitespace only string or `null`.
  /// @param [value]?: Any string.
  bool isWhitespaceOrNull(String? value) {
    return value == null || whitespace.hasMatch(value);
  }
}