/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:math' show min;
import 'package:flutter/material.dart';
import '../../extensions/text_style.dart';
import '../../layouts/grid.dart';
import '../../layouts/padding.dart';
import '../../themes/colors/color.dart';
import '../../themes/fonts/font.dart';
import '../material/ink_response.dart';
import '../material/material_state_color.dart';


/// Button
/// ------------------------------------------------------------------------------------------------

abstract class SPDButton extends StatefulWidget {

  /// Create a button that is rendered using the defined [style].
  const SPDButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.onPressedDisabled,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
    this.expand = false,
    this.padding,
    this.targetPadding,
    this.minHeight,
    this.color,
    this.backgroundColor,
    this.textStyle,
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

  /// The button's inner padding (default [OAPadding.shared.horizontal()]).
  final EdgeInsets? padding;

  /// The button's outer padding, used to increase its target area.
  final EdgeInsets? targetPadding;

  /// The button's minimum height (default: [SPDGrid.x6]).
  final double? minHeight;

  /// The button's border and content color. This will override the default 
  /// [ButtonStyle.foregroundColor] property defined by [style].
  final Color? color;

  /// The button's background color. This will override the default [ButtonStyle.backgroundColor] 
  /// property defined by [style].
  final Color? backgroundColor;

  /// The button's text style.
  final TextStyle? textStyle;

  /// Return the radius of the button's smallest dimension.
  double get minRadius {
    return (minHeight ?? SPDGrid.x6) * 0.5;
  }

  /// Build the button's content. This method is called each time the widget is built.
  /// @param [context]: The current build context.
  /// @param [color]?: The content color ([color] or [ButtonStyle.foregroundColor]) for the 
  /// current state. 
  Widget? builder(BuildContext context, Color? color) => child;

  /// Define the button's appearance for each [MaterialState]. This method is called each time the 
  /// widget's dependencies change.
  /// @param [context]: The current build context.
  ButtonStyle style(BuildContext context) {
    final double radius = minRadius;
    final double borderRadius = min(radius, SPDGrid.x2);
    return ButtonStyle(
      backgroundColor: SPDMaterialStateColor.color(backgroundColor),
      foregroundColor: SPDMaterialStateColor.color(color ?? SPDColor.shared.font),
      minimumSize: MaterialStateProperty.all<Size>(Size.fromRadius(radius)),
      overlayColor: MaterialStateProperty.all<Color>(SPDColor.shared.overlay),
      padding: MaterialStateProperty.all<EdgeInsets>(padding ?? SPDEdgeInsets.shared.horizontal()),
      shape: MaterialStateProperty.all(
        const StadiumBorder(),
      ),
      // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      //   RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(borderRadius),
      //   ),
      // ),
      tapTargetSize: MaterialTapTargetSize.padded,
      textStyle: MaterialStateProperty.all(
        textStyle ?? SPDFont.shared.button.withAdjustedHeight(),
      ),
    );
  }

  /// Create an instance of the class' state widget.
  @override
  SPDButtonState createState() => SPDButtonState();
}


/// Button State
/// ------------------------------------------------------------------------------------------------

class SPDButtonState extends State<SPDButton> {

  /// The button's styling.
  late ButtonStyle _style;

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
  
  /// Initialise the button's [_style] property.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _style = widget.style(context);
  }

  /// Update the widget's state.
  /// @param [oldWidget]: The widget's previous state.
  @override
  void didUpdateWidget(covariant SPDButton oldWidget) {
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

    /// Update the button's style if any of the style properties have changed.
    if (widget.minHeight != oldWidget.minHeight
        || widget.padding != oldWidget.padding
        || widget.color != oldWidget.color 
        || widget.backgroundColor != oldWidget.backgroundColor) {
      _style = widget.style(context);
    }
  }

  /// Add or remove [state] from the widget's [_states] property.
  /// @param [state]: The state to enable or disable.
  /// @param [value]: If `true` add the state, else remove it.
  void _updateState(MaterialState state, bool value) {
    value ? _states.add(state) : _states.remove(state);
  }

  /// Toggle the button's [Material.pressed] state each time the touch event changes.
  /// @param [value]: If `true`, the button is being pressed.
  void _onHighlightChanged(bool value) {
    if (_pressed != value) {
      setState(() => _updateState(MaterialState.pressed, value));
    }
  }

  /// Toggle the button's [Material.focused] state each time its focus changes.
  /// @param [value]: If `true`, the button has gained focus.
  void _onFocusChanged(bool value) {
    if (_focused != value) {
      setState(() => _updateState(MaterialState.focused, value));
    }
  }

  /// Build the final widget.
  /// @param [context]: The current build context.
  @override
  Widget build(BuildContext context) {

    /// Resolve the button's style properties.
    final TextStyle textStyle = _style.textStyle?.resolve(_states) ?? const TextStyle();
    final Color? color = _style.foregroundColor?.resolve(_states) ?? SPDColor.shared.font;
    final Color? backgroundColor = _style.backgroundColor?.resolve(_states);
    final EdgeInsetsGeometry padding = _style.padding?.resolve(_states) ?? EdgeInsets.zero;
    final Size minimumSize = _style.minimumSize?.resolve(_states) ?? const Size.fromRadius(24.0);
    final BorderSide? side = _style.side?.resolve(_states);
    final OutlinedBorder? shape = _style.shape?.resolve(_states);

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
          child: widget.builder(context, color),
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
          overlayColor: _style.overlayColor,
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