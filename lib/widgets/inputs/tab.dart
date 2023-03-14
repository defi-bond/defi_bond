/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../../layouts/grid.dart';


/// Tab
/// ------------------------------------------------------------------------------------------------

class SPDTab extends StatelessWidget {
  
  /// Creates a [TabBar] tab.
  const SPDTab({ 
    Key? key, 
    required this.text,
  }): super(key: key);

  /// The tab's text.
  final String text;

  /// Build the final widget.
  /// @param [context]: The current build context.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SPDGrid.x4,
      child: Center(
        widthFactor: 1.0,
        child: Text(
          text, 
          softWrap: false,
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }
}