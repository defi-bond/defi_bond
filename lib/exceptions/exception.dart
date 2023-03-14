/// Exception Code
/// ------------------------------------------------------------------------------------------------

enum SPDExceptionCode {
  associatedTokenAccountDoesNotExist,
}


/// Exception
/// ------------------------------------------------------------------------------------------------

class SPDException implements Exception {

  /// Error [message] and [code].
  const SPDException(
    this.message, {
    this.code,
  });

  /// The error message.
  final String message;

  /// The error code.
  final SPDExceptionCode? code;

  /// Associated token account exception.
  factory SPDException.ata(final String message) => SPDException(
    message, 
    code: SPDExceptionCode.associatedTokenAccountDoesNotExist,
  );

  @override
  String toString() => '[SPDException] $message';
}