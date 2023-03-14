/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../../themes/colors/color.dart';


/// Tab Bar
/// ------------------------------------------------------------------------------------------------

class SPLTabBar extends StatelessWidget {

  /// Creates a tab bar. The length of [tabs] must equal the [controller]'s length.
  const SPLTabBar({ 
    Key? key,
    required this.tabs,
    this.controller,
    this.isScrollable = true,
  }): super(key: key);

  /// The tabs.
  final List<Widget> tabs;

  /// The tab controller. If `null`, there must be a [DefaultTabController] ancestor in the widget 
  /// tree.
  final TabController? controller;

  /// If true, the bar becomes scrollable when the tab widths exceed the available space.
  final bool isScrollable;

  /// Build the final widget.
  /// @param [context]: The current build context.
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: SPDColor.shared.primary1,
      child: TabBar(
        tabs: tabs,
        controller: controller,
        isScrollable: isScrollable,
        physics: const BouncingScrollPhysics(),
      ),
    );
  }
}