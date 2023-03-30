/// Import
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../../icons/dream_drops_icons.dart';
import '../../layouts/grid.dart';
import '../../themes/colors/color.dart';


/// Error Screen
/// ------------------------------------------------------------------------------------------------

class SPDErrorScreen extends StatelessWidget {
  
  const SPDErrorScreen({
    super.key,
    this.error, 
  });

  final Object? error;

  @override
  Widget build(final BuildContext context) {
    final double size = SPDGrid.x8;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox.square(
              dimension: size, 
              child: Material(
                color: SPDColor.shared.font,
                shape: CircleBorder(),
                child: Icon(
                  SPDIcons.exclamationmark,
                  color: SPDColor.shared.primary1,
                  size: size * 0.25,
                ),
              ),
            ),
            const SizedBox(
              height: SPDGrid.x2,
            ),
            Center(
              child: Text(
                error?.toString() ?? 'Something went wrong',
              ),
            ),
          ],
        ),
      ),
    );
  }
}