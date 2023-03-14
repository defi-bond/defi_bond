/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:stake_pool_lotto/utils/duration.dart';
import '../../layouts/grid.dart';
import '../painters/animated_indicator_painter.dart';
import 'primary_button.dart';


/// Indicator Button
/// ------------------------------------------------------------------------------------------------

class SPDIndicatorButton extends StatefulWidget {

  /// Creates a button that transition between an [SPDPrimaryButton] and progress indicator. Set 
  /// [showIndicator] equal to `true` for a progress indicator and `false` for a primary button.
  const SPDIndicatorButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.focusNode,
    this.showIndicator = false,
    this.autofocus = false,
    this.enabled = true,
    this.expand = false,
    this.padding,
    this.targetPadding,
    this.minHeight,
    this.color,
  });

  /// The button's main content.
  final Widget? child;

  /// The callback function that's triggered when the button is pressed while `enabled`. If `null`, 
  /// the button's state will be set to [MaterialState.disabled].
  final VoidCallback? onPressed;

  /// Controls whether or not the widget has keyboard focus to handle keyboard events.
  final FocusNode? focusNode;

  /// If `true`, render the progress indicator. Else, render the [SPLPrimaryButton].
  final bool showIndicator;

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

  /// The button's minimum height (default: [SPLGrid.x6]).
  final double? minHeight;

  /// The button's border and content color. This will override the default 
  /// [ButtonStyle.foregroundColor] property defined by [style].
  final Color? color;

  /// Create an instance of the class' state widget.
  @override
  SPDIndicatorButtonState createState() => SPDIndicatorButtonState();
}


/// Indicator Button State
/// ------------------------------------------------------------------------------------------------

class SPDIndicatorButtonState extends State<SPDIndicatorButton> with TickerProviderStateMixin {

  /// The controller that animates the indicator's movement.
  late AnimationController _translateController;

  /// The controller that animates the between the button and indicator state.
  late AnimationController _transformController;

  /// The animation that fades the button in/out of view.
  late Animation<double> _fadeAnimation;

  /// The animation that resizes the widget.
  late Animation<double> _sizeAnimation;

  /// The animation that transforms the indicator's appearance.
  late Animation<double> _transformAnimation;

  /// Return the button's minimum height.
  double get _minHeight {
    return widget.minHeight ?? SPDGrid.x6;
  }

  /// Initialise the widget's state.
  @override
  void initState() {
    super.initState();

    final double value = widget.showIndicator ? 0.0 : 1.0;

    _translateController = AnimationController(
      vsync: this, 
      value: value,
      duration: SPDDuration.slow,
    );
    
    _transformController = AnimationController(
      vsync: this, 
      value: value,
      duration: SPDDuration.slow,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _transformController, 
      curve: const Interval(0.70, 1.0, curve: Curves.easeInOut),
    );

    _sizeAnimation = CurvedAnimation(
      parent: _transformController, 
      curve: const Interval(0.25, 0.7, curve: Curves.easeOut),
    );

    _transformAnimation = CurvedAnimation(
      parent: _transformController, 
      curve: const Interval(0.0, 0.25, curve: Curves.easeIn),
    );

    if (widget.showIndicator) {
      _translateController.repeat();
    }
  }

  /// Dispose of all acquired resources.
  @override
  void dispose() {
    _translateController.dispose();
    _transformController.dispose();
    super.dispose();
  }

  /// Update the widget's state.
  /// @param [oldWidget]: The widget's previous state.
  @override
  void didUpdateWidget(covariant final SPDIndicatorButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showIndicator != oldWidget.showIndicator) {
      _animate(showIndicator: widget.showIndicator);
    }
  }

  /// Animate the widget from its current state to a progress indicator or primary button.
  /// @param [showIndicator]: If `true`, render a progress indicator, else render a primary button.
  void _animate({ required final bool showIndicator }) {
    _translateController.stop();
    _transformController.stop();
    if (showIndicator) {
      _transformController.reverse().whenComplete(() {
        _translateController.repeat();
      });
    } else {
      _translateController.forward().whenComplete(() {
        _transformController.forward();
      });
    }
  }

  /// Build the button widget.
  /// @param [minHeight]: The button's height.
  Widget _buildButton({ required final double minHeight }) {
    return SPDPrimaryButton(
      onPressed: widget.onPressed,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      enabled: widget.enabled,
      expand: widget.expand,
      padding: widget.padding,
      targetPadding: widget.targetPadding,
      minHeight: minHeight,
      backgroundColor: widget.color,
      child: widget.child,
    );
  }

  /// Build the progress indicator for the current animation ([_transformAnimation]) frame.
  /// @param [context]: The current build context.
  /// @param [child]?: The static child widget.
  Widget _animatedBuilder(BuildContext context, Widget? child) {
    return CustomPaint(
      painter: SPDAnimatedIndicatorPainter(
        animation: _translateController,
        transformValue: _transformAnimation.value,
        color: widget.color,
        borderRadius: _minHeight * 0.5,
      ),
    );
  }

  /// Build the final widget.
  /// @param [context]: The current build context.
  @override
  Widget build(BuildContext context) {
    final double minHeight = _minHeight;
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.hardEdge,
      children: [
        SizedBox(
          width: minHeight,
          height: minHeight,
        ),
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _transformAnimation,
            builder: _animatedBuilder,
          ),
        ),
        FadeTransition(
          opacity: _fadeAnimation,
          child: SizeTransition(
            axis: Axis.horizontal,
            sizeFactor: _sizeAnimation,
            child: _buildButton(minHeight: minHeight),
          ),
        ),
      ],
    );
  }
}