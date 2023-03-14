/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart' show EdgeInsets;
import 'grid.dart';


/// Padding
/// ------------------------------------------------------------------------------------------------

class SPDEdgeInsets {
  
  /// Defines the application's commonly used padding values.
  const SPDEdgeInsets._();

  /// The [SPDEdgeInsets] class' singleton instance.
  static const shared = SPDEdgeInsets._();

  /// Return the default horizontal inset.
  double get horizontalInset => SPDGrid.x3;
  
  /// Return the default vertical inset.
  double get verticalInset => SPDGrid.x2;

  /// Return padding for all four edges.
  /// @param [left]?: The left padding value (default: [horizontalInset]).
  /// @param [top]?: The top padding value (default: [verticalInset]).
  /// @param [right]?: The right padding value (default: [horizontalInset]).
  /// @param [bottom]?: The bottom padding value (default: [verticalInset]).
  EdgeInsets inset({ double? left, double? top, double? right, double? bottom }) {
    return EdgeInsets.only(
      left: left ?? horizontalInset,
      top: top ?? verticalInset,
      right: right ?? horizontalInset,
      bottom: bottom ?? verticalInset,
    );
  }

  /// Return symmetric padding for all four edges.
  /// @param [horizontal]?: The horizontal padding value (default: [horizontalInset]).
  /// @param [vertical]?: The vertical padding value (default: [verticalInset]).
  EdgeInsets symmetric({ double? horizontal, double? vertical }) {
    return EdgeInsets.symmetric(
      horizontal: horizontal ?? horizontalInset, 
      vertical: vertical ?? verticalInset,
    );
  }

  /// Return padding for the horizontal edges.
  /// @param [value]?: The horizontal padding value (default: [horizontalInset]).
  EdgeInsets horizontal([double? value]) {
    return EdgeInsets.symmetric(
      horizontal: value ?? horizontalInset,
    );
  }

  /// Return padding for the vertical edges.
  /// @param [value]?: The vertical padding value (default: [verticalInset]).
  EdgeInsets vertical([double? value]) {
    return EdgeInsets.symmetric(
      vertical: value ?? verticalInset,
    );
  }

  /// Return the default padding for a list tile.
  EdgeInsets tile() {
    return EdgeInsets.symmetric(
      horizontal: horizontalInset, 
      vertical: verticalInset * 0.5,
    );
  }

  /// Return the default padding for a card.
  EdgeInsets card() {
    return const EdgeInsets.all(SPDGrid.x2);
  }
}