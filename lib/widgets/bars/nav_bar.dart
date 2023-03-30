/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../../layouts/grid.dart';
import '../../models/nav_bar_item.dart';
import '../../themes/colors/color.dart';


/// Navigation Bar
/// ------------------------------------------------------------------------------------------------

class SPLNavBar extends StatefulWidget implements PreferredSizeWidget {
  
  /// Creates a bar that displays a row of navigation items.
  const SPLNavBar({ 
    Key? key,
    this.color,
    this.activeColor,
    this.initialIndex = 0,
    required this.children,
    this.onPressed,
  }): super(key: key);

  /// The navigation bar's height (56.0).
  static const double kHeight = SPDGrid.x1 * 7.0;

  /// The default icon color (default: [SPDColor.secondary1]).
  final Color? color;

  /// The active icon color (default: [SPDColor.font]).
  final Color? activeColor;

  /// The index position of the initial active item (default: `0`).
  final int initialIndex;

  /// The navigation items.
  final List<SPDNavBarItem> children;

  /// The callback function that's triggered when a navigation item is pressed.
  final void Function(int index)? onPressed;

  @override
  Size get preferredSize => const Size.fromHeight(SPLNavBar.kHeight * 0.5);

  @override
  SPLNavBarState createState() => SPLNavBarState();
}


/// Navigation Bar State
/// ------------------------------------------------------------------------------------------------

class SPLNavBarState extends State<SPLNavBar> {
  
  /// The index position of the active navigation items.
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  /// Sets [_index].
  void _setIndex(int index) {
    if (mounted && index != _index) {
      _index = index;
      setState(() => null);
    }
  }

  /// Creates a callback function that triggers [widget.onPressed] and updates [_index].
  VoidCallback _onPressed(final int index) {
    return () {
      _setIndex(index);
      widget.onPressed?.call(index);
    };
  }

  /// Builds the navigation [item] at [index].
  Widget _buildItem(final SPDNavBarItem item, { required final int index }) {
    final bool active = _index == index;
    return SizedBox(
      height: SPLNavBar.kHeight,
      child: GestureDetector(
        onTap: _onPressed(index),
        child: Icon(
          active 
            ? (item.activeIcon ?? item.icon) 
            : item.icon, 
          color: active
            ? widget.activeColor ?? SPDColor.shared.font
            : widget.color ?? SPDColor.shared.primary8, 
          size: SPDGrid.x3,
        ),
      ),
    );
  }

  /// Builds the final widget.
  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      height: SPLNavBar.kHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < widget.children.length; ++i)
            Expanded(
              child: ColoredBox(
                color: Colors.red,
                child: _buildItem(
                  widget.children[i], 
                  index: i,
                ),
              ),
            ),
        ],
      ),
    );
  }
}