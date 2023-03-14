/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
import '../storage/file_storage.dart';


/// Persistent File Storage
/// ------------------------------------------------------------------------------------------------

class SPDPersistentFileStorage extends SPDFileStorage {

  /// Reads and writes files to `persistent` storage. This directory is backed up, not visible to 
  /// the user and is suitable for sqlite.db files.
  const SPDPersistentFileStorage._()
    : super(getApplicationDocumentsDirectory);

  /// The [SPDPersistentFileStorage] class' singleton instance.
  static const SPDPersistentFileStorage shared = SPDPersistentFileStorage._();
}