/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../../extensions/text_style.dart';
import '../../layouts/grid.dart';
import '../../themes/fonts/font.dart';


/// Section
/// ------------------------------------------------------------------------------------------------

class SPDSection extends StatelessWidget {

  const SPDSection({
    super.key,
    required this.title,
    required this.child,
  });

  final Widget title;

  final Widget child;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DefaultTextStyle(
          style: SPDFont.shared.labelMedium.medium(), 
          child: title,
        ),
        const SizedBox(
          height: SPDGrid.x2,
        ),
        child,
      ],
    );
  }
}