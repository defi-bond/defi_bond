/// Imports
/// ------------------------------------------------------------------------------------------------

library spd_exception_handler;

import 'dart:async';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import 'package:stake_pool_lotto/exceptions/exception.dart';


/// Exception Handler
/// ------------------------------------------------------------------------------------------------

/// Return a callback function that parses an exception into a [String].
/// @param [defaultMessage]: The default error message (See [SPDExceptionHandler.message]).
String Function(dynamic) messageHandler([String? defaultMessage]) {
  return SPDExceptionHandler(defaultMessage).message;
}

/// Return a callback function that maps an exception to a [SPDExceptionHandler].
/// @param [defaultMessage]: The default error message (See [SPDExceptionHandler.exception]).
SPDException Function(dynamic) exceptionHandler([String? defaultMessage]) {
  return SPDExceptionHandler(defaultMessage).exception;
}

/// Return a callback function that attempts to parse an error object into a [SPDException].
/// @param [defaultMessage]: The default error message (See [SPDExceptionHandler.error]).
Future<Object> Function(Object, [StackTrace]) errorHandler([String? defaultMessage]) {
  return SPDExceptionHandler(defaultMessage).error;
}

/// Handles thrown errors and exceptions.
class SPDExceptionHandler {

  /// Exception handler - used to parse exceptions and return user friendly error messages.
  const SPDExceptionHandler([
    this.defaultMessage,
  ]);

  /// The default error message.
  final String? defaultMessage;

  /// The default error message used when [defaultMessage] is not defined and a value is required.
  static String get fallbackDefaultMessage {
    return 'Something has gone wrong.';
  }
  
  /// Parse [error] for a known error message (with [defaultMessage] as a fallback if defined) and 
  /// return it as an instance of [SPDException]. Else return the original [error] value.
  /// @param [error]: Any error value.
  /// @param [stackTrace]?: The error's stack trace.
  Future<Object> error(Object error, [StackTrace? stackTrace]) {
    final String? message = _parseException(error) ?? defaultMessage;
    return Future.error(message != null ? SPDException(message) : error, stackTrace);
  }

  /// Parse [exception] for a known error message (with [defaultMessage] as a fallback) and return 
  /// it as an instance of [SPDException].
  /// @param [exception]: Any exception value.
  /// @param [defaultMessage]?: The default error message (default: [fallbackDefaultMessage]).
  SPDException exception(dynamic exception, [String? defaultMessage]) {
    return SPDException(message(exception, defaultMessage));  
  }

  /// Parse [exception] for a known error message (with [defaultMessage] as a fallback) and return 
  /// the message value.
  /// @param [exception]: Any exception value.
  /// @param [defaultMessage]?: The default error message (default: [fallbackDefaultMessage]).
  String message(dynamic exception, [String? defaultMessage]) {
    final String? message = _parseException(exception) ?? defaultMessage;
    return message ?? this.defaultMessage ?? fallbackDefaultMessage;
  }

  /// Parse [exception] and return a known error message or `null` if no known error is found.
  /// @param [exception]?: Any exception value.
  String? _parseException(dynamic exception) {
    print('PARSE EXCEPTION: ${exception.toString()} - $exception');
    if (exception is JsonRpcException) {
      return _jsonRpcException(exception);
    } else if (exception is SPDException) {
      return exception.message;
    } else {
      print('NO MATCHED EXCEPTION FOR: ${exception.runtimeType}');
      return null;
    }
  }

  String? _jsonRpcException(final JsonRpcException exception) {
    print('JSON MESSAGE = ${exception.message}');
    switch(exception.code) {
      case -32002:
      case JsonRpcExceptionCode.serverErrorSendTransactionPreflightFailure:
        if (exception.message.contains('Attempt to debit an account but found no record of a prior credit.')) {
          return 'Attempt to debit an account but found no record of a prior credit.';
        }
        return null;
      default:
        return null;
    }
  }
}