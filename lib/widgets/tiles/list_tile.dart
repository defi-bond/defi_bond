/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:stake_pool_lotto/layouts/padding.dart';
import 'package:stake_pool_lotto/themes/colors/color.dart';
import 'package:stake_pool_lotto/themes/fonts/font.dart';
import '../../extensions/text_style.dart';
import '../../layouts/grid.dart';


/// List Tile
/// ------------------------------------------------------------------------------------------------

class SPLListTile extends StatelessWidget {
  
  /// Creates a list item with an optional [leading] widget, [title] / optional [subtitle] and 
  /// optional [trailing] widget.
  const SPLListTile({ 
    Key? key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.padding,
    this.spacing = SPDGrid.x1 * 2.0,
    this.onPressed,
    this.itemExtent,
    this.backgroundColor,
  }): super(key: key);

  /// The optional leading widget.
  final Widget? leading;

  /// The title.
  final Widget title;

  /// The optional subtitle.
  final Widget? subtitle;

  /// The optional trailing widget.
  final Widget? trailing;

  /// The inner padding (default: [OAPadding.shared.tile()]).
  final EdgeInsets? padding;

  /// The horizontal spacing between each of the widgets (default: [SPDGrid.x2]).
  final double spacing;

  /// The function that's called each time the widget it pressed.
  final VoidCallback? onPressed;

  /// The height.
  final double? itemExtent;

  /// The background color (default: [SPDColor.shared.primary1]).
  final Color? backgroundColor;

  /// Build the leading widget.
  /// @param [leading]: The leading widget.
  Widget _buildLeading(Widget leading) {
    return Padding(
      padding: EdgeInsets.only(right: spacing),
      child: leading,
    );
  }

  /// Build the centre widget.
  /// @param [title]: The title widget.
  /// @param [subtitle]: The subtitle widget.
  Widget _buildTitleAndSubtitle(Widget title, Widget? subtitle) {

    final Widget _title = DefaultTextStyle(
      style: SPDFont.shared.body1.medium(), 
      child: title,
    );

    if (subtitle == null) {
      return _title;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title,
        subtitle, 
      ],
    );
  }

  /// Build the trailing widget.
  /// @param [trailing]: The trailing widget.
  Widget _buildTrailing(Widget trailing) {
    return Padding(
      padding: EdgeInsets.only(left: spacing),
      child: trailing,
    );
  }

  /// Build the final widget.
  /// @param [context]: The current build context.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemExtent,
      child: Material(
        color: backgroundColor ?? SPDColor.shared.primary1,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: padding ?? SPDEdgeInsets.shared.tile(),
            child: Row(
              children: [
                if (leading != null)
                  _buildLeading(leading!),
                Expanded(
                  child: _buildTitleAndSubtitle(title, subtitle),
                ),
                if (trailing != null)
                  _buildTrailing(trailing!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}