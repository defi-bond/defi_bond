/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:stake_pool_lotto/utils/duration.dart';
import '../../themes/colors/color.dart';


/// Error Form Field
/// ------------------------------------------------------------------------------------------------

class SPDErrorFormField extends StatefulWidget {

  /// Creates a form field that displays an error message. The [error] message is animated into view 
  /// when a value is provided. To remove the message set [error] = `null`.
  const SPDErrorFormField({
    super.key,
    this.error,
    this.enabled = true,
    this.padding = EdgeInsets.zero,
    this.duration,
    this.textAlign = TextAlign.center,
  });

  /// The error message to display using the style [ThemeData.inputDecorationTheme.errorStyle]. 
  final String? error;

  /// If `false`, render the message in a disabled state (default: `true`).
  final bool enabled;

  /// The form field's inner padding.
  final EdgeInsets padding;

  /// The animation duration (default: [OADuration.shared.fast]).
  final Duration? duration;

  /// The text's alignment (default: [TextAlign.center]).
  final TextAlign textAlign;

  /// Create an instance of the class' state widget.
  @override
  SPDErrorFormFieldState createState() => SPDErrorFormFieldState();
}


/// Error Form Field State
/// ------------------------------------------------------------------------------------------------

class SPDErrorFormFieldState extends State<SPDErrorFormField> with SingleTickerProviderStateMixin {

  /// The current error value.
  String? _error;

  /// The controller that animates the widget in and out of view.
  late AnimationController _controller;

  /// Return true if the widget has a valid error message.
  bool get _hasError {
    return widget.error?.isNotEmpty == true;
  }

  /// Initialise the widget's state.
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      value: _hasError ? 1.0 : 0.0,
      duration: widget.duration ?? SPDDuration.fast,
    );
    _animate();
  }

  /// Dispose of all acquired resources.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Update the widget's state each time the [widget.error] message value changes.
  /// @param [oldWidget]: The widget's previous state.
  @override
  void didUpdateWidget(covariant SPDErrorFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.error != oldWidget.error) {
      _animate(from: oldWidget.error);
    }
  }

  /// Animate the error message in or out of view depending on the current value of [widget.error].
  /// @param [from]: The previous error message value to animate from.
  void _animate({ String? from }) {

    /// If the widget has an error message, display it.
    if(_hasError) {
      _error = widget.error;
      _controller.forward();
    } 
    /// Else, keep the old error message ([from]) visible until the widget has been animated out of
    /// view, then set it to `null` (i.e. [widget.error]).
    else {
      _error = from ?? widget.error;
      _controller.reverse().whenComplete(() => _error = widget.error);
    }
  }

  /// Build the final widget.
  /// @param [context]: The current build context.
  @override
  Widget build(BuildContext context) {
    final TextStyle? style = Theme.of(context).inputDecorationTheme.errorStyle;
    return SizeTransition(
      sizeFactor: _controller,
      axis: Axis.vertical,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: widget.padding,
              child: Text(
                _error ?? '',
                textAlign: widget.textAlign,
                style: style?.copyWith(
                  color: widget.enabled 
                    ? SPDColor.shared.error
                    : SPDColor.shared.disabled  
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}