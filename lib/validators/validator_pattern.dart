/// Validator Pattern
/// ------------------------------------------------------------------------------------------------

class SPDValidatorPattern {

  /// Defines a regular expression [pattern] to validate the user's input and an optional error 
  /// [message] to return if validation fails (See [SPDValidator]).
  const SPDValidatorPattern(
    this.pattern, {
    this.message,
  });

  /// The pattern to validate the user's input.
  final RegExp pattern;

  /// The error message to return if validation fails.
  final String? message;
}