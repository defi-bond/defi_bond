/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../../layouts/padding.dart';
import '../../widgets/bars/app_bar.dart';


/// Overlay Screen
/// ------------------------------------------------------------------------------------------------

class SPLOverlayScaffold extends StatelessWidget {

  const SPLOverlayScaffold({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: SPDAppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: SPDEdgeInsets.shared.inset(),
        child: child,
      ),
    );
  }
}