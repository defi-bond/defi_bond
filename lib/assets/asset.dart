/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:path/path.dart' as p;


/// Asset
/// ------------------------------------------------------------------------------------------------

abstract class SPDAsset {

  /// Provides properties and methods for working with asset bundles.
  ///   
  /// Assets are added to the project's `assets/` folder ([SPDAsset.root]):
  ///   /assets
  ///     /[directory]
  ///       /..
  const SPDAsset(this.directory);

  /// The root directory.
  static const String root = 'assets';

  /// The top-level directory for the asset type.
  final String directory;

  /// Return the absolute file path of an asset found within [root]/[directory]/.
  /// @param [part*]: The relative file path segments.
  String path(final List<String> parts) {
    return p.joinAll([root, directory, ...parts]);
  }
}