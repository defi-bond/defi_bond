/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'stack_view.dart';


/// Page View
/// ------------------------------------------------------------------------------------------------

class SPLPageView extends StatelessWidget {
  
  /// Creates a scrollable view that navigates through each of its child views page by page.
  const SPLPageView({ 
    Key? key,
    required this.children,
    this.controller,
    this.physics,
    this.axis = Axis.horizontal,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  }): super(key: key);

  /// The pages.
  final List<Widget> children;

  /// The scroll controller.
  final PageController? controller;

  /// The scroll physics (default: [BouncingScrollPhysics]).
  final ScrollPhysics? physics;

  /// The main axis to layout the pages ([children]) along (default: [Axis.horizontal]).
  final Axis axis;

  /// The alignment along the perpendicular [axis] (default: [CrossAxisAlignment.center]).
  final CrossAxisAlignment crossAxisAlignment;

  /// Build each page ([children]) to fill the available space along the [axis].
  /// @param [constraints]: The widget's size constraints.
  List<Widget> _buildPages(BoxConstraints constraints) {
    final List<Widget> pages = [];
    final bool isHorizontal = axis == Axis.horizontal;
    final double? width = isHorizontal ? constraints.maxWidth : null;
    final double? height = isHorizontal ? null : constraints.maxHeight;
    for(final Widget child in children) {
      pages.add(SizedBox(child: child, width: width, height: height));
    }
    return pages;
  }

  /// Build a scrollable view along the [axis].
  /// @param [context]: The current build context.
  /// @param [constraints]: The widget's size constraints.
  Widget _layoutBuilder(BuildContext context, BoxConstraints constraints) {
    return SPLStackView(
      spacing: 0.0,
      axis: axis,
      controller: controller,
      crossAxisAlignment: crossAxisAlignment,
      physics: PageScrollPhysics(
        parent: physics ?? const BouncingScrollPhysics(),
      ),
      children: _buildPages(constraints),
    );
  }

  /// Build the final widget.
  /// @param [context]: The current build context.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: _layoutBuilder,
    );
  }
}