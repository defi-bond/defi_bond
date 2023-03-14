/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';


/// Ink Response
/// ------------------------------------------------------------------------------------------------

class SPDInkResponse extends InkResponse {

  /// Create an [InkResponse] widget with a highlight effect that's constrained to the widget's 
  /// visual bounding box (i.e. excluding the widget's [targetPadding]).
  SPDInkResponse({
    Key? key,
    bool autofocus = false,
    BorderRadius? borderRadius,
    bool canRequestFocus = true,
    Widget? child,
    bool containedInkWell = true,
    FocusNode? focusNode,
    MaterialStateProperty<Color?>? overlayColor,
    BoxShape? highlightShape,
    void Function(bool)? onHighlightChanged,
    void Function(bool)? onFocusChange,
    VoidCallback? onTap,
    this.targetPadding,
  }): super(
        key: key,
        autofocus: autofocus,
        borderRadius: borderRadius,
        canRequestFocus: canRequestFocus,
        child: child,
        containedInkWell: containedInkWell,
        focusNode: focusNode,
        overlayColor: overlayColor,
        splashFactory: InkRipple.splashFactory,
        highlightColor: Colors.transparent,
        highlightShape: highlightShape ?? BoxShape.rectangle,
        onHighlightChanged: onHighlightChanged,
        onFocusChange: onFocusChange,
        onTap: onTap,
      );

  /// The outer padding to exclude from the ink well effect's bounding box.
  final EdgeInsets? targetPadding;

  /// Return the bounding box of the ink well effect.
  /// @param [referenceBox]: The size of the widget's target area.
  @override
  RectCallback? getRectCallback(RenderBox referenceBox) {
    if(targetPadding == null) {
      return super.getRectCallback(referenceBox);
    }
    return () {
      return targetPadding!.deflateRect(Offset.zero & referenceBox.size);
    };
  }
}