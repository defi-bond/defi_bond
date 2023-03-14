/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:async';
import 'package:flutter/material.dart';
import '../layouts/grid.dart';
import '../validators/validator.dart';
import '../../exceptions/exception_handler.dart';
import '../../utils/timer.dart';


/// Form Mixin State
/// ------------------------------------------------------------------------------------------------

mixin SPDFormMixin<T extends StatefulWidget> on State<T> {

  /// The global key that must be attached to a [Form] to provide access to its state. Classes
  /// that use [SPDFormMixin] must set this as the [Form] widget's `key` property.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// The form field validator.
  final SPDValidator validator = const SPDValidator();
  
  /// If true, the form is currently being submitted.
  bool _isFormSubmitting = false;

  /// The error message from the last form submission.
  String? _formSubmitError;

  /// Return true if the form is ready to receive user input.
  bool get isFormEnabled {
    return !_isFormSubmitting;
  }

  /// Return true if the form is currently being submitted.
  bool get isFormSubmitting {
    return _isFormSubmitting;
  }

  /// Return the form's current error message.
  String? get formSubmitError {
    return _formSubmitError;
  }

  /// Return the default error message that will be set when an exception is thrown that does not 
  /// correspond to a known error (default: [SPDExceptionHandler.fallbackDefaultMessage]). This 
  /// `should` be overridden to provide an appropriate message for the current context.
  String get defaultFormSubmitError {
    return SPDExceptionHandler.fallbackDefaultMessage;
  }
  
  /// Return the minimum duration applied to each form submition (default: `1 second`).
  Duration get formSubmitMinimumDuration {
    return const Duration(seconds: 1);
  }

  /// Return the default spacing between each of the form fields.
  double get formFieldSpacing {
    return SPDGrid.x2;
  }

  /// Clear the form's current error message.
  void clearFormError() {
    if(_formSubmitError != null) {
      setState(() => _formSubmitError = null);
    }
  }

  /// Called after each of the form field's validator functions succeed. This method can be used to 
  /// provide addition validation and return an error message when validation fails.
  /// @param [state]: The form's current state.
  FutureOr<String?> formValidator(final FormState state);

  /// Returns a [VoidCallback] function that calls [onFormSubmitComplete] if the widget is mounted.
  /// @param [error]: The form's submission error message.
  VoidCallback _onFormSubmitComplete(final String? error) {
    return () { if (mounted) { onFormSubmitComplete(error); } };
  }

  /// Called when the form finishes submitting and updates its current state.
  /// @param [error]: The form's submission error message.
  @mustCallSuper
  void onFormSubmitComplete(final String? error) {
    setState(() {
      _formSubmitError = error;
      _isFormSubmitting = false;
    });
  }

  /// The form's submission callback handler.
  @mustCallSuper
  void onFormSubmit() async {

    /// Check that the [formKey] property has been attached to a [Form] widget.
    assert(formKey.currentState != null, throw FlutterError(
      'The [SPDFormMixin.formKey] property has not been assigned to a [Form] widget.\n'
      'Set `formKey` as the `key` property of the [Form] widget.\n'
      'Form(key: formKey, ...).'
    ));
    
    /// Run validation for all form fields. If successful, proceed and run the form's validator.
    if(formKey.currentState!.validate()) {

      /// The error message passed to [onFormSubmitComplete].
      String? error;

      /// Update the form's status to `submitting`.
      _isFormSubmitting = true;
      setState(() {});

      /// Start a timer to ensure that the form is not re-enabled until the timer expires.
      final SPDTimer timer = SPDTimer(duration: formSubmitMinimumDuration);

      /// Trigger each form field's [onSaved] callback handler.
      formKey.currentState?.save();

      /// Run the form's [validator] function.
      try {
        error = await formValidator(formKey.currentState!);
      } catch(exception) {
        error = SPDExceptionHandler(defaultFormSubmitError).message(exception);
      }

      /// Update the forms status to `not submitting` and set the form's error message (if any).
      timer.onComplete(_onFormSubmitComplete(error));
    }
  }
}