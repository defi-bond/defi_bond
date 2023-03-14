/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;
import '../storage/file_storage.dart';


/// Temporary File Storage
/// ------------------------------------------------------------------------------------------------

class SPDTemporaryFileStorage extends SPDFileStorage {

  /// Reads and writes files to `temporary` storage. This directory is not backed up and is suitable 
  /// for storing caches or downloaded files.
  const SPDTemporaryFileStorage._()
    : super(getTemporaryDirectory);

  /// The [SPDTemporaryFileStorage] class' singleton instance.
  static const SPDTemporaryFileStorage shared = SPDTemporaryFileStorage._();
}