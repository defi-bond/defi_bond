/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/widgets.dart';
import '../../layouts/grid.dart';


/// Stack View
/// ------------------------------------------------------------------------------------------------

class SPLStackView extends StatelessWidget {

  /// Creates a view that renders its child elements ([children]) along the given [axis].
  const SPLStackView({
    super.key, 
    required this.children,
    this.isScrollable = true,
    this.spacing = SPDGrid.x1 * 2.0,
    this.axis = Axis.horizontal,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.controller,
    this.physics,
  });

  /// The stack view's items.
  final List<Widget> children;

  /// If true, enable scrolling (default: `true`).
  final bool isScrollable;

  /// The spacing between each item ([children]) in the stack view (default: [SPLGrid.x2]).
  final double spacing;

  /// The main axis to layout the items ([children]) along (default: [Axis.horizontal]).
  final Axis axis;

  /// The amount of space that the widget should try to occupy (default: [MainAxisSize.max]).
  final MainAxisSize mainAxisSize;

  /// The alignment along the main [axis] (default: [MainAxisAlignment.center]).
  final MainAxisAlignment mainAxisAlignment;

  /// The alignment along the perpendicular [axis] (default: [CrossAxisAlignment.center]).
  final CrossAxisAlignment crossAxisAlignment;

  /// The [SingleChildScrollView]'s scroll controller.
  final ScrollController? controller;

  /// The [SingleChildScrollView]'s scroll physics.
  final ScrollPhysics? physics;

  /// Return true if the [axis] == [Axis.horizontal].
  bool get _isHorizontal {
    return axis == Axis.horizontal;
  }

  /// Build a spacer widget.
  Widget _buildSpacer() {
    return _isHorizontal 
      ? SizedBox(width: spacing) 
      : SizedBox(height: spacing);
  }

  /// Build the items list.
  List<Widget> _buildItems() {
    
    if (spacing <= 0.0 || children.isEmpty) { 
      return children; 
    }

    final List<Widget> items = [children.first];
    for (int i = 1; i < children.length; ++i) {
      items.add(_buildSpacer());
      items.add(children[i]);
    }

    return items;
  }

  /// Build the final widget.
  /// @param [context]: The current build context.
  @override
  Widget build(BuildContext context) {

    final Widget child = _isHorizontal 
      ? Row(
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: _buildItems(),
        )
      : Column(
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: _buildItems(),
        );

    return isScrollable
      ? SingleChildScrollView(
          scrollDirection: axis,
          controller: controller,
          physics: physics ?? const BouncingScrollPhysics(),
          reverse: mainAxisAlignment == MainAxisAlignment.end,
          child: child,
        )
      : child;
  }
}