/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';


/// Navigation Bar Item
/// ------------------------------------------------------------------------------------------------

class SPDNavBarItem {

  /// Defines the icons ([icon]/[activeIcon]) of an [SPDNavBar] button.
  const SPDNavBarItem({
    required this.icon,
    this.activeIcon,
  });

  /// The icon displayed when the button is not active.
  final IconData icon;

  /// The icon displayed when the button is active (default: [icon]).
  final IconData? activeIcon;
}