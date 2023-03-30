/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/widgets.dart';
import '../../layouts/grid.dart';


/// Stack View
/// ------------------------------------------------------------------------------------------------

class SPDStackView extends StatelessWidget {

  /// Creates a view that renders its child elements ([children]) along the given [axis].
  const SPDStackView({
    super.key, 
    required this.children,
    this.spacing = SPDGrid.x1 * 2.0,
    this.axis = Axis.vertical,
    this.mainAxisSize = MainAxisSize.min,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  /// The stack view's items.
  final List<Widget> children;

  /// The spacing between each item ([children]) in the stack view (default: [SPDGrid.x2]).
  final double spacing;

  /// The main axis to layout the items ([children]) along (default: [Axis.horizontal]).
  final Axis axis;

  /// The amount of space that the widget should try to occupy (default: [MainAxisSize.max]).
  final MainAxisSize mainAxisSize;

  /// The alignment along the main [axis] (default: [MainAxisAlignment.center]).
  final MainAxisAlignment mainAxisAlignment;

  /// The alignment along the perpendicular [axis] (default: [CrossAxisAlignment.center]).
  final CrossAxisAlignment crossAxisAlignment;

  /// True if the [axis] == [Axis.horizontal].
  bool get _isHorizontal => axis == Axis.horizontal;

  /// Builds the items list.
  List<Widget> _buildChildren(final Widget spacer) {
    final List<Widget> items = [];
    final int length = (children.length * 2) - 1;
    for (int i = 0; i < length; ++i) {
      items.add(i.isEven ? children[i ~/ 2] : spacer);
    }
    return items;
  }

  /// Builds the final widget.
  @override
  Widget build(final BuildContext context) {
    return _isHorizontal 
      ? Row(
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: _buildChildren(SizedBox(width: spacing)),
        )
      : Column(
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: _buildChildren(SizedBox(height: spacing)),
        );
  }
}