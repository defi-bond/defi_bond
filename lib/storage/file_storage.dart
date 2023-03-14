/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart' show Uuid;


/// File Storage
/// ------------------------------------------------------------------------------------------------

abstract class SPDFileStorage {

  /// An interface for reading and writing files to disk.
  const SPDFileStorage(this.directory);

  /// The callback function that returns the root directory.
  final Future<Directory> Function() directory;

  /// Returns true if [error] is a [FileSystemException] for a file or directory that does not 
  /// exist.
  bool _isDoesNotExistError(final Object error) {
    return error is FileSystemException ? error.osError?.errorCode == 2 : false;
  }

  /// Creates a unique file name with the provided file extension ([ext]).
  String name({ final String? ext }) {
    final String name = const Uuid().v4().replaceAll('-', '');
    return ext != null ? p.setExtension(name, ext) : name;
  }

  /// Constructs an absolute file path to the root [directory].
  /// 
  /// ```
  /// final storage = SPDFileStorage(...);
  /// final path = storage.path(['subfolder', 'file.txt']);
  /// print(path); // 'root-directory/subfolder/file.txt';
  /// ```
  Future<String> path(
    final Iterable<String> parts,
  ) async {
    assert(parts.isNotEmpty);

    // Get the file directory.
    final Directory dir = await directory();

    // Join the path segments into a complete file path using the current platform's path separator. 
    // E.g. 'dir/path/name.ext' or 'dir\path\name.ext'
    return p.joinAll([dir.path, ...parts]);
  }

  /// Reads a file from [directory]. 
  /// 
  /// Throws an error [Object] if the operation fails.
  /// 
  /// ```
  /// final storage = SPDFileStorage(...);
  /// final file = storage.read(['subfolder', 'file.txt']);
  /// print(file); // 'root-directory/subfolder/file.txt';
  /// ```
  Future<File> read(final Iterable<String> parts) async {
    return File(await path(parts));
  }

  /// Writes [bytes] to a file in [directory] and returns the destination [File]. 
  /// 
  /// If the destination file already exists, this will overwrite its contents. 
  /// 
  /// Throws an error [Object] if the operation fails.
  /// 
  /// ```
  /// final storage = SPDFileStorage(...);
  /// final file = storage.write('Data'.codeUnits, ['subfolder', 'file.txt']);
  /// ```
  Future<File> write(
    final Uint8List bytes, 
    final Iterable<String> parts, {
    final FileMode mode = FileMode.write
  }) async {
    final String path = await this.path(parts);
    return File(path)..writeAsBytesSync(bytes, mode: mode, flush: true);
  }

  /// Creates a file in [directory]. 
  ///
  /// If [overwrite] is true, truncate the file's contents if it already exists. Else, return an 
  /// error (default: `false`).
  ///
  /// Throws an error [Object] if the operation fails.
  /// 
  /// ```
  /// final storage = SPDFileStorage(...);
  /// final file = storage.create(['subfolder', 'file.txt'], overwrite: true);
  /// ```
  Future<File> create(
    final Iterable<String> parts, {
    final bool overwrite = false,
  }) async {
    final File file = File(await path(parts));
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    } else if (overwrite) {
      file.writeAsBytesSync([]);
    } else {
      throw FileSystemException('The file ${file.path} already exists.');
    }
    return file;
  }

  /// Copies [file] to a new [File] in [directory]. 
  /// 
  /// If the destination file already exists, this will overwrite its contents. 
  /// 
  /// Throws an error [Object] if the operation fails.
  /// 
  /// ```
  /// final storage = SPDFileStorage(...);
  /// final file = storage.write('Data'.codeUnits, ['subfolder', 'file1.txt']);
  /// final fileCopy = storage.copy(file, ['subfolder', 'file2.txt']);
  /// ```
  Future<File> copy(final File file, final Iterable<String> parts) async {
    return file.copySync(await path(parts));
  }

  /// Moves [file] to a location in [directory]. 
  /// 
  /// If the destination file already exists, this will overwrite its contents. 
  /// 
  /// Throws an error [Object] if the operation fails.
  Future<File> move(final File file, final Iterable<String> parts) async {

    /// Get the storage directory.
    final Directory dir = await directory();

    /// Get the destination file path.
    final String path = p.joinAll([dir.path, ...parts]);
    
    /// If the source [file] and destination path refer to the same file system, rename [file].
    if (file.path.startsWith(dir.path)) {
      return file.rename(path);
    }
    
    /// Else, copy the [file] to its destination path and delete the current [file].
    final File copy = file.copySync(path);
    file.deleteSync();
    return copy;
  }

  /// Deletes a file in [directory]. 
  /// 
  /// Throws an error [Object] if the operation fails.
  Future<void> delete(final Iterable<String> parts) async {
    final String path = await this.path(parts);
    return File(path).deleteSync();
  }

  /// Deletes [directory].
  /// 
  /// Throws an error [Object] if the operation fails.
  Future<void> clear() async {
    return (await directory()).deleteSync(recursive: true);
  }
}