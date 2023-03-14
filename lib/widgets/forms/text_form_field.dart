/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../layouts/grid.dart';
import '../../layouts/line_weight.dart';
import '../../themes/colors/color.dart';
import 'error_form_field.dart';


/// Text Form Field
/// ------------------------------------------------------------------------------------------------

class SPDTextFormField extends FormField<String> {
  
  /// See [TextFormField].
  /// This is a copy of [TextFormField] with a custom error message widget.
  SPDTextFormField({
    Key? key,
    this.controller,
    String? initialValue,
    FocusNode? focusNode,
    InputDecoration? decoration = const InputDecoration(),
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction? textInputAction,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    this.textAlign = TextAlign.left,
    TextAlignVertical? textAlignVertical,
    bool autofocus = false,
    bool readOnly = false,
    ToolbarOptions? toolbarOptions,
    bool? showCursor,
    String obscuringCharacter = '•',
    bool obscureText = false,
    bool autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    bool enableSuggestions = true,
    MaxLengthEnforcement? maxLengthEnforcement,
    int? maxLines = 1,
    int? minLines,
    bool expands = false,
    int? maxLength,
    ValueChanged<String>? onChanged,
    GestureTapCallback? onTap,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onFieldSubmitted,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    List<TextInputFormatter>? inputFormatters,
    bool? enabled,
    double cursorWidth = SPDLineWeight.w1,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    Brightness? keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(SPDGrid.x1 * 2.0),
    bool enableInteractiveSelection = true,
    TextSelectionControls? selectionControls,
    InputCounterWidgetBuilder? buildCounter,
    ScrollPhysics? scrollPhysics,
    Iterable<String>? autofillHints,
    AutovalidateMode? autovalidateMode,
    this.autoClearError = false,
  }): super(
        key: key,
        initialValue: controller != null ? controller.text : (initialValue ?? ''),
        onSaved: onSaved,
        validator: validator,
        enabled: enabled ?? decoration?.enabled ?? true,
        autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
        builder: (FormFieldState<String> _state) {

          final _SPDTextFormFieldState state = _state as _SPDTextFormFieldState;

          final InputDecoration _decoration = (decoration ?? const InputDecoration())
            .applyDefaults(Theme.of(state.context).inputDecorationTheme);

          void onChangedHandler(String value) {
            state.didChange(value);
            onChanged?.call(value);
          }

          return TextField(
            controller: state._effectiveController,
            focusNode: focusNode,
            decoration: _decoration,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            style: style ?? _decoration.hintStyle?.copyWith(
              color: SPDColor.shared.font,
            ),
            strutStyle: strutStyle,
            textAlign: textAlign,
            textAlignVertical: textAlignVertical,
            textDirection: textDirection,
            textCapitalization: textCapitalization,
            autofocus: autofocus,
            toolbarOptions: toolbarOptions,
            readOnly: readOnly,
            showCursor: showCursor,
            obscuringCharacter: obscuringCharacter,
            obscureText: obscureText,
            autocorrect: autocorrect,
            smartDashesType: smartDashesType ?? (obscureText ? SmartDashesType.disabled : SmartDashesType.enabled),
            smartQuotesType: smartQuotesType ?? (obscureText ? SmartQuotesType.disabled : SmartQuotesType.enabled),
            enableSuggestions: enableSuggestions,
            maxLengthEnforcement: maxLengthEnforcement,
            maxLines: maxLines,
            minLines: minLines,
            expands: expands,
            maxLength: maxLength,
            onChanged: onChangedHandler,
            onTap: onTap,
            onEditingComplete: onEditingComplete,
            onSubmitted: onFieldSubmitted,
            inputFormatters: inputFormatters,
            enabled: enabled ?? decoration?.enabled ?? true,
            cursorWidth: cursorWidth,
            cursorHeight: cursorHeight,
            cursorRadius: cursorRadius,
            cursorColor: cursorColor,
            scrollPadding: scrollPadding,
            scrollPhysics: scrollPhysics,
            keyboardAppearance: keyboardAppearance,
            enableInteractiveSelection: enableInteractiveSelection,
            selectionControls: selectionControls,
            buildCounter: buildCounter,
            autofillHints: autofillHints,
          );
        }
      );
  
  /// Controls the text being edited. If null, this widget will create its own 
  /// [TextEditingController] and initialise its [TextEditingController.text] with [initialValue].
  final TextEditingController? controller;

  /// If `true`, clear the error message each time the input value is changed.
  final bool autoClearError;

  /// The input text and error message alignment.
  final TextAlign textAlign;

  /// Create an instance of the class' state widget.
  @override
  _SPDTextFormFieldState createState() => _SPDTextFormFieldState();
}


/// Text Form Field State
/// ------------------------------------------------------------------------------------------------

class _SPDTextFormFieldState extends FormFieldState<String> {

  /// The flag that indicates if the input has been changed after being build (See [build]).
  bool _hasChanged = false;

  /// The fallback text editing controller if one has not been provided.
  TextEditingController? _controller;
  
  /// Return `true` if the error message should be displayed.
  bool get _showError {
    return widget.autoClearError && _hasChanged;
  }

  /// Return the active text editing controller.
  TextEditingController? get _effectiveController {
    return widget.controller ?? _controller;
  }

  /// Return state's widget property.
  @override
  SPDTextFormField get widget {
    return super.widget as SPDTextFormField;
  }

  /// Initialise the widget's state.
  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      widget.controller?.addListener(_onControllerChanged);
    }
  }
  
  /// Dispose of all acquired resources.
  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  /// Update the widget's state.
  /// @param [oldWidget]: The widget's previous state.
  @override
  void didUpdateWidget(covariant SPDTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      
      oldWidget.controller?.removeListener(_onControllerChanged);
      widget.controller?.addListener(_onControllerChanged);

      if (oldWidget.controller != null && widget.controller == null) {
        _controller = TextEditingController.fromValue(oldWidget.controller?.value);
      }

      if (widget.controller != null) {
        setValue(widget.controller?.text);
        if (oldWidget.controller == null) {
          _controller = null;
        }
      }
    }
  }

  /// See [TextFormField].
  /// @param [value]: The text field's new value.
  @override
  void didChange(String? value) {
    _hasChanged = true;
    super.didChange(value);
    if (_effectiveController!.text != value) {
      _effectiveController!.text = value ?? '';
    }
  }

  /// See [TextFormField].
  @override
  void reset() {
    /// setState will be called in the superclass, so even though state is being manipulated, no 
    /// setState call is needed here.
    _effectiveController!.text = widget.initialValue ?? '';
    super.reset();
  }

  /// See [TextFormField].
  void _onControllerChanged() {
    /// Suppress changes that originated from within this class.
    /// In the case where a controller has been passed in to this widget, we register this change 
    /// listener. In these cases, we'll also receive change notifications for changes originating 
    /// from within this class -- for example, the reset() method. In such cases, the FormField 
    /// value will already have been set.
    if (_effectiveController!.text != value) {
      didChange(_effectiveController!.text);
    }
  }

  /// Build the widget with an [OAErrorFormField] to display the current [error] message.
  /// @param [child]: The text field widget.
  /// @param [error]: The text field widget's current error value.
  Widget _build(Widget child, { String? error }) {
    return Column(
      children: [
        child, 
        SPDErrorFormField(
          error: error,
          textAlign: widget.textAlign,
          padding: const EdgeInsets.only(
            top: SPDGrid.x1 * 0.5,
          ),
        ),
      ],
    );
  }

  /// Build the final widget.
  /// @param [context]: The current build context.
  @override
  Widget build(BuildContext context) {

    /// Get the form field's current error value (this must be called before resetting [_hasChanged] 
    /// as it relys on its value).
    final String? error = _showError ? null : errorText;

    /// Build the [TextField] widget.
    final Widget textField = super.build(context);

    /// Reset the flag.
    _hasChanged = false;

    /// Construct the final widget.
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: SPDGrid.x6,
      ),
      child: widget.validator != null
        ? _build(textField, error: error)
        : textField,
    );
  }
}