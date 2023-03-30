/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../material/ink_response.dart';
import '../../themes/colors/color.dart';


/// Button
/// ------------------------------------------------------------------------------------------------

abstract class SPDButton extends StatefulWidget {

  /// Creates a button that is rendered using the defined [style].
  const SPDButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.onPressedDisabled,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
    this.expand = false,
    required this.style,
    this.targetPadding,
  });

  /// The button's main content.
  final Widget? child;

  /// The callback function that's triggered when the button is pressed while `enabled`. If `null`, 
  /// the button's state will be set to [MaterialState.disabled].
  final VoidCallback? onPressed;

  /// The callback function that's triggered when the button is pressed while `disabled`.
  final VoidCallback? onPressedDisabled;

  /// Controls whether or not the widget has keyboard focus to handle keyboard events.
  final FocusNode? focusNode;

  /// If `true`, the widget will try to obtain focus when it's first loaded (default: `false`).
  final bool autofocus;

  /// If `false`, the button's state will be set to [MaterialState.disabled] (default: `true`).
  final bool enabled;

  /// If `true`, fill the available width.
  final bool expand;

  /// Button style.
  final ButtonStyle style;

  /// The button's outer padding, used to increase its target area.
  final EdgeInsets? targetPadding;

  /// Builds the button's content. This method is called each time the widget is built.
  Widget? builder(final BuildContext context, final Size? minSize, final Color? color) => child;

  @override
  SPDButtonState createState() => SPDButtonState();
}


/// Button State
/// ------------------------------------------------------------------------------------------------

class SPDButtonState extends State<SPDButton> {

  /// The button's current states.
  final Set<MaterialState> _states = <MaterialState>{};

  /// Return `true` if the widget is enabled.
  bool get _enabled {
    return widget.enabled && widget.onPressed != null;
  }

  /// Return `true` if widget's states include [MaterialState.focused].
  bool get _focused {
    return _states.contains(MaterialState.focused);
  }

  /// Return `true` if widget's states include [MaterialState.pressed].
  bool get _pressed {
    return _states.contains(MaterialState.pressed);
  }

  /// Return `true` if widget's states include [MaterialState.disabled].
  bool get _disabled {
    return _states.contains(MaterialState.disabled);
  }

  /// Initialise the widget's state.
  @override
  void initState() {
    super.initState();
    _updateState(MaterialState.disabled, !_enabled);
  }

  /// Update the widget's state.
  /// @param [oldWidget]: The widget's previous state.
  @override
  void didUpdateWidget(covariant final SPDButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// Set the button's current state.
    _updateState(MaterialState.disabled, !_enabled);
    
    /// See [ButtonStyleButton].
    /// If the button is disabled while a press gesture is currently ongoing, InkWell makes a call 
    /// to handleHighlightChanged. This causes an exception because it calls setState in the middle 
    /// of a build. To preempt this, we manually update pressed to false when this situation occurs.
    if (_disabled && _pressed) {
      _onHighlightChanged(false);
    }
  }

  /// Add or remove [state] from the widget's [_states] property.
  /// @param [state]: The state to enable or disable.
  /// @param [value]: If `true` add the state, else remove it.
  void _updateState(final MaterialState state, final bool value) {
    value ? _states.add(state) : _states.remove(state);
  }

  /// Toggle the button's [Material.pressed] state each time the touch event changes.
  /// @param [value]: If `true`, the button is being pressed.
  void _onHighlightChanged(final bool value) {
    if (_pressed != value) {
      setState(() => _updateState(MaterialState.pressed, value));
    }
  }

  /// Toggle the button's [Material.focused] state each time its focus changes.
  /// @param [value]: If `true`, the button has gained focus.
  void _onFocusChanged(final bool value) {
    if (_focused != value) {
      setState(() => _updateState(MaterialState.focused, value));
    }
  }

  /// Build the final widget.
  /// @param [context]: The current build context.
  @override
  Widget build(final BuildContext context) {

    /// Resolve the button's style properties.
    final TextStyle textStyle = widget.style.textStyle?.resolve(_states) ?? const TextStyle();
    final Color? color = widget.style.foregroundColor?.resolve(_states) ?? SPDColor.shared.font;
    final Color? backgroundColor = widget.style.backgroundColor?.resolve(_states);
    final EdgeInsetsGeometry padding = widget.style.padding?.resolve(_states) ?? EdgeInsets.zero;
    final Size minimumSize = widget.style.minimumSize?.resolve(_states) ?? const Size.fromRadius(24.0);
    final BorderSide? side = widget.style.side?.resolve(_states);
    final OutlinedBorder? shape = widget.style.shape?.resolve(_states);

    /// Construct the button's content.
    Widget button = ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minimumSize.width,
        minHeight: minimumSize.height,
        maxWidth: double.infinity,
        maxHeight: double.infinity,
      ),
      child: Padding(
        padding: padding,
        child: Center(
          widthFactor: widget.expand ? null : 1.0,
          child: widget.builder(context, minimumSize, color),
        ),
      ),
    );

    /// Pad the button to increase its target area.
    if (widget.targetPadding != null) {
      button = Padding(
        padding: widget.targetPadding!,
        child: button,
      );
    }

    /// Add the button's background and touch events.
    return Semantics(
      button: true,
      container: true,
      enabled: _enabled,
      child: Material(
        color: backgroundColor,
        clipBehavior: Clip.hardEdge,
        shape: shape?.copyWith(side: side),
        textStyle: textStyle.copyWith(color: color),
        type: backgroundColor == null 
          ? MaterialType.transparency 
          : MaterialType.button,
        child: SPDInkResponse(
          autofocus: widget.autofocus,
          containedInkWell: true,
          canRequestFocus: _enabled,
          overlayColor: widget.style.overlayColor,
          onTap: _enabled ? widget.onPressed : widget.onPressedDisabled,
          onHighlightChanged: _onHighlightChanged,
          onFocusChange: _onFocusChanged,
          targetPadding: widget.targetPadding,
          child: button,
        )
      ),
    );
  }
}