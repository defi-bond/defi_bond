/// Import
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';


/// Error Screen
/// ------------------------------------------------------------------------------------------------

class SPDErrorScreen extends StatelessWidget {
  
  const SPDErrorScreen({
    super.key,
    this.exception, 
    this.defaultText,
    this.onTap,
    this.actionText,
  }): assert(defaultText == null || defaultText is String || defaultText is List<TextSpan>);

  final dynamic exception;
  final dynamic defaultText;
  final void Function(BuildContext)? onTap;
  final String? actionText;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('ERROR SCREEN')),
    );
  }
}