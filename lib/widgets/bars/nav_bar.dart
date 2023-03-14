/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:stake_pool_lotto/themes/colors/color.dart';
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

  /// The default icon color (default: [SPDColor.shared.secondary1]).
  final Color? color;

  /// The active icon color (default: [SPDColor.shared.brand]).
  final Color? activeColor;

  /// The index position of the initial active item (default: `0`).
  final int initialIndex;

  /// The navigation items.
  final List<SPDNavBarItem> children;

  /// The callback function that's triggered when a navigation item is pressed.
  /// @param [index]: The navigation item's index position.
  final void Function(int index)? onPressed;

  /// Return the navigation bar's size.
  @override
  Size get preferredSize => const Size.fromHeight(SPLNavBar.kHeight * 0.5);

  /// Create an instance of the class' state widget.
  @override
  SPLNavBarState createState() => SPLNavBarState();
}


/// Navigation Bar State
/// ------------------------------------------------------------------------------------------------

class SPLNavBarState extends State<SPLNavBar> {
  
  /// The index position of the active navigation items.
  late int _index;

  /// Initialise the widget's state.
  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  /// Set [_index].
  /// @param [index]: The index position of the active item.
  void _setIndex(int index) {
    if (index != _index) {
      setState(() => _index = index);
    }
  }

  /// Create a callback function that triggers [widget.onPressed] and updates [_index].
  /// @param [item]: The navigation item to create a callback function for.
  /// @param [index]: The navigation item's index position.
  VoidCallback _onPressed(int index) {
    return () {
      _setIndex(index);
      widget.onPressed?.call(index);
    };
  }

  /// Build the navigation [item] at [index].
  /// @param [item]: The navigation item data.
  /// @param [index]: The navigation item's index position.
  Widget _buildItem(final SPDNavBarItem item, { required final int index }) {
    
    final bool active = _index == index;

    final IconData icon = active
      ? (item.activeIcon ?? item.icon)
      : item.icon;

    final Color color = active
      ? widget.activeColor ?? SPDColor.shared.brand
      : widget.color ?? SPDColor.shared.secondary1;

    return SizedBox(
      height: SPLNavBar.kHeight,
      child: GestureDetector(
        onTap: _onPressed(index),
        child: ColoredBox(
          color: Colors.transparent,
          child: Icon(
            icon, 
            color: color, 
            size: SPDGrid.x3,
          ),
        ),
      ),
    );
  }

  /// Build the final widget.
  /// @param [context]: The current build context.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SPLNavBar.kHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < widget.children.length; ++i)
            Expanded(
              child: _buildItem(
                widget.children[i], 
                index: i,
              ),
            ),
        ],
      ),
    );
  }
}