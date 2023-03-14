/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:stake_pool_lotto/utils/regexp.dart';
import 'package:stake_pool_lotto/validators/validator_pattern.dart';

import '../models/country_code.dart';


/// Validator
/// ------------------------------------------------------------------------------------------------

class SPDValidator {

  /// Provides properties and methods for validating user input.
  const SPDValidator();

  /// Normalise the string [value].
  /// @param [value]: The string to normalise.
  /// @param [trim]: If true, trim [value]'s leading and trailing whitespace (default: `true`).
  /// @param [lowercase]: If true, lowercase each character in [value] (default: `false`).
  /// @param [uppercase]: If true, uppercase each character in [value] (default: `false`).
  String? normalise(
    String? value, { 
    bool trim = true, 
    bool lowercase = false, 
    bool uppercase = false,
  }) {

    if (trim) {
      value = value?.trim();
    }

    if (lowercase) {
      value = value?.toLowerCase();
    } else if (uppercase) {
      value = value?.toUpperCase();
    }

    return SPDRegExp.shared.isWhitespaceOrNull(value) ? null : value;
  }

  /// Return the pluralised form of [value] for the given [count] (e.g. 1 fox, 2 foxes).
  /// @param [value]: The text to pluralise if [count] does not equal `1`.
  /// @param [count]: The number that precedes the text [value].
  String pluralise(String value, { required final int count }) {

    if (count == 1) {
      return value;
    }

    if (RegExp(r'(ch|sh|s|x|z)$').hasMatch(value)) {
      return '${value}es';
    }

    return '${value}s';
  }

  /// Validate the string [value]. Return `null` if validation succeeds, or an error message if it 
  /// fails.
  /// @param [value]?: The string to validate.
  /// @param [maxLength]?: The string's maximum length.
  /// @param [minLength]?: The string's minimum length.
  /// @param [field]?: The form field's name, used in the error message (default: `This field`).
  /// @param [isRequired]?: If true, [value] is mandatory and must be provided (default: `true`).
  /// @param [defaultMessage]?: The default error message returned if an [SPDValidatorPattern] fails 
  /// and does not define an error message (default: `[field] is invalid.`).
  /// @param [validators]?: A list of validators to run against [value].
  String? string(
    final String? value, {
    int? maxLength, 
    int? minLength,
    String? field,
    bool isRequired = true, 
    String? defaultMessage,
    List<SPDValidatorPattern>? validators
  }) {
    
    field ??= 'This field';

    if(SPDRegExp.shared.isWhitespaceOrNull(value)) {
      return isRequired ? '$field is required.' : null;
    }

    if(maxLength != null && value!.length > maxLength) {
      final String text = pluralise('character', count: maxLength);
      return '$field cannot have more than $maxLength $text.';
    }

    if(minLength != null && value!.length < minLength) {
      return '$field must have $minLength or more characters.';
    }

    for (final SPDValidatorPattern validator in validators ?? const []) {
      if(!validator.pattern.hasMatch(value!)) {
        return validator.message ?? defaultMessage ?? '$field is invalid.';
      }
    }

    return null;
  }

  /// Validate the [email] address. Return `null` if validation succeeds, or an error message if it 
  /// fails.
  /// @param [email]?: The email address to validate.
  /// @param [maxLength]?: The email address' maximum length (default: `320`).
  /// @param [minLength]?: The email address' minimum length (default: `3`).
  /// @param [field]?: The form field's name, used in the error message (default: `Email address`).
  /// @param [isRequired]?: If true, [email] is mandatory and must be provided (default: `true`).
  /// @param [defaultMessage]?: The default error message returned if an [SPDValidatorPattern] fails 
  /// and does not define an error message (default: `[field] is invalid.`).
  /// @param [validators]?: A list of additional validators to run against [email].
  String? email(
    String? email, {
    int? maxLength, 
    int? minLength,
    String? field,
    String? defaultMessage,
    bool isRequired = true, 
    List<SPDValidatorPattern>? validators
  }) {
    return string(
      email, 
      maxLength: maxLength ?? 320,  /// The max length of a valid email address. 
      minLength: minLength ?? 3,    /// The min length of a valid email address.
      field: field ?? 'Email address',
      defaultMessage: defaultMessage,
      isRequired: isRequired,
      validators: (validators ??= [])..add(SPDValidatorPattern(SPDRegExp.shared.email)),
    );
  }

  /// Validate the [phone] number. Return `null` if validation succeeds, or an error message if it 
  /// fails.
  /// @param [phone]?: The phone number to validate.
  /// @param [maxLength]?: The phone number's maximum length (default: `320`).
  /// @param [minLength]?: The phone number's minimum length (default: `3`).
  /// @param [field]?: The form field's name, used in the error message (default: `Phone number`).
  /// @param [isRequired]?: If true, [phone] is mandatory and must be provided (default: `true`).
  /// @param [defaultMessage]?: The default error message returned if an [SPDValidatorPattern] fails 
  /// and does not define an error message (default: `[field] is invalid.`).
  /// @param [validators]?: A list of additional validators to run against [phone].
  String? phone(
    String? phone, 
    SPDCountryCode? code, {
    int? maxLength, 
    int? minLength,
    String? field,
    String? defaultMessage,
    bool isRequired = true, 
    List<SPDValidatorPattern>? validators
  }) {
    return string(
      phone, 
      maxLength: maxLength,
      minLength: minLength,
      field: field ?? 'Phone number',
      defaultMessage: defaultMessage,
      isRequired: isRequired,
      validators: (validators ??= [])..add(SPDValidatorPattern(SPDRegExp.shared.phone)),
    );
  }
}