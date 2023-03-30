/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../../extensions/text_style.dart';
import '../../layouts/grid.dart';
import '../../providers/stake_provider.dart';
import '../../themes/fonts/font.dart';
import '../../themes/colors/color.dart';


/// List Tile
/// ------------------------------------------------------------------------------------------------

class SPDListTile extends StatelessWidget {
  
  const SPDListTile({
    super.key,
    this.leading,
    this.status,
    required this.title,
    this.titleTrailing,
    this.subtitle,
    this.subtitleTrailing,
    this.trailing,
    this.onTap,
  });

  final Widget? leading;

  final DelegationStatus? status;

  final Widget title;

  final Widget? titleTrailing;

  final Widget? subtitle;

  final Widget? subtitleTrailing;

  final Widget? trailing;

  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {

    Widget? leading = this.leading;
    if (leading != null) {
      final DelegationStatus? status = this.status;
      leading = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          leading,
          if (status != null)
            Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.only(top: 11),
              decoration: BoxDecoration(
                color: status.color,
                shape: BoxShape.circle,
              ),
            ),
        ],
      );
    }

    Widget? title = this.title;
    final Widget? titleTrailing = this.titleTrailing;
    if (titleTrailing != null) {
      title = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: title,
          ),
          const SizedBox(
            width: SPDGrid.x2,
          ),
          titleTrailing,
        ],
      );
    }

    Widget? subtitle = this.subtitle;
    final Widget? subtitleTrailing = this.subtitleTrailing;
    if (subtitleTrailing != null) {
      subtitle = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          subtitle ?? const SizedBox.shrink(),
          const SizedBox(
            width: SPDGrid.x2,
          ),
          subtitleTrailing,
        ],
      );
    }

    if (subtitle != null) {
      subtitle = Padding(
        padding: const EdgeInsets.only(
          top: SPDGrid.x1 * 0.5,
        ),
        child: DefaultTextStyle(
          style: SPDFont.shared.labelLarge.setColor(SPDColor.shared.secondary8), 
          child: subtitle,
        ),
      );
    }

    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
      splashColor: SPDColor.shared.primary2,
    );
  }
}