/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'asset.dart';


/// Asset Image
/// ------------------------------------------------------------------------------------------------

class SPDAssetImage extends SPDAsset {

  /// Provides properties and methods for working with image assets (.jpg, .svg, etc.).
  ///   
  /// Images are added to the project's `assets/images/` folder:
  ///   /assets
  ///     /images
  ///       /..
  const SPDAssetImage._()
    : super('images');

  /// The [SPDAssetImage] class' singleton instance.
  static const SPDAssetImage shared = SPDAssetImage._();

  /// Read the file's contents as an [AssetImage].
  /// @param [part*]: The relative file path segments.
  AssetImage image(final List<String> parts) {
    return AssetImage(path(parts));
  }
}