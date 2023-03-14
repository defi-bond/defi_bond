/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:async';
import 'dart:convert';
import 'package:solana_wallet_provider/solana_wallet_provider.dart' show SerializableMixin;


/// Types
/// ------------------------------------------------------------------------------------------------

/// Defines a callback function to map a [json] object to an instance of type [T].
typedef SPDDataDecoder<T> = T Function(Map<String, dynamic> json);


/// Data Storage
/// ------------------------------------------------------------------------------------------------

abstract class SPDDataStorage {

  /// An interface for reading and writing data to disk.
  const SPDDataStorage();

  // /// Create a function that returns [value].
  // /// @param [value]: The return value of the created function.
  // T Function(void) returnValue<T>(final T value) {
  //   return (_) => value;
  // }

  // /// Converts a boolean string [value] to a boolean value.
  // bool? stringToBool<T>(final String? value) {
  //   assert(value == null || value == 'true' || value == 'false');
  //   return value != null ? value == 'true' : null;
  // }

  /// Serialise [value] to a JSON `String`.
  /// @param [value]?: The json object to serialise into a string.
  String? encode<T extends Object>(final T? value) {
    return value != null ? json.encode(value) : null;
  }

  /// Deserialise [value] from a `String` to an `Object` of type `T`.
  /// @param [value]?: The string representation of a json object.
  T? decode<T>(final String? value) {
    return value != null && value.isNotEmpty ? json.decode(value) : null;
  }

  /// Returns the [bool] value associated with [key]. 
  /// 
  /// Throws an exception if the returned value is not a `bool`.
  FutureOr<bool?> getBool(final String key);
  
  /// Returns the [double] value associated with [key]. 
  /// 
  /// Throws an exception if the returned value is not a `double`.
  FutureOr<double?> getDouble(final String key);

  /// Returns the [int] value associated with [key]. 
  /// 
  /// Throws an exception if the returned value is not an `int`.
  FutureOr<int?> getInt(final String key);

  /// Returns the [String] value associated with [key]. 
  /// 
  /// Throws an exception if the returned value is not an `string`.
  FutureOr<String?> getString(final String key);

  /// Returns the [List] of strings associated with [key]. 
  /// 
  /// Throws an exception if the returned value is not an `List<String>`.
  FutureOr<List<String>?> getStringList(final String key);

  /// Returns the [Map] associated with [key]. 
  /// 
  /// Throws an exception if the returned value is not an `Map<String, dynamic>`.
  FutureOr<Map<String, dynamic>?> getMap(final String key);

  /// Returns the [List] of maps associated with [key]. 
  /// 
  /// Throws an exception if the returned value is not an `List<Map<String, dynamic>>`.
  FutureOr<List<Map<String, dynamic>>?> getMapList(final String key);

  /// Returns the value of type [T] associated with [key]. 
  /// 
  /// Throws an exception if the returned value is not of type [T].
  FutureOr<T?> getType<T extends SerializableMixin>(
    final String key, 
    final SPDDataDecoder<T> decoder,
  );

  /// Returns the [List] of type [T] associated with [key]. 
  /// 
  /// Throws an exception if the returned value is not a [List] of type [T].
  FutureOr<List<T>?> getTypeList<T extends SerializableMixin>(
    final String key, 
    final SPDDataDecoder<T> decoder,
  );

  /// Associates [value] with [key]. 
  /// 
  /// Throw an exception if the process fails.
  FutureOr<dynamic> setBool(final String key, final bool value);

  /// Associates [value] with [key]. 
  /// 
  /// Throw an exception if the process fails.
  FutureOr<dynamic> setDouble(final String key, final double value);

  /// Associates [value] with [key]. 
  /// 
  /// Throw an exception if the process fails.
  FutureOr<dynamic> setInt(final String key, final int value);

  /// Associates [value] with [key]. 
  /// 
  /// Throw an exception if the process fails.
  FutureOr<dynamic> setString(final String key, final String value);

  /// Associates [value] with [key]. 
  /// 
  /// Throw an exception if the process fails.
  FutureOr<dynamic> setStringList(final String key, final List<String> value);

  /// Associates [value] with [key]. 
  /// 
  /// Throw an exception if the process fails.
  FutureOr<dynamic> setMap(final String key, final Map<String, dynamic> value);

  /// Associates [value] with [key]. 
  /// 
  /// Throw an exception if the process fails.
  FutureOr<dynamic> setMapList(final String key, final List<Map<String, dynamic>> value);

  /// Associates [value] with [key]. 
  /// 
  /// Throw an exception if the process fails.
  FutureOr<dynamic> setType<T extends SerializableMixin>(final String key, final T value);

  /// Associates [value] with [key]. 
  /// 
  /// Throw an exception if the process fails.
  FutureOr<dynamic> setTypeList<T extends SerializableMixin>(
    final String key, 
    final List<T> value,
  );

  /// Deletes the value associated with [key]. 
  /// 
  /// Throw an exception if the process fails.
  FutureOr<dynamic> delete(final String key);

  /// Deletes all stored values. 
  /// 
  /// Throw an exception if the process fails.
  FutureOr<dynamic> clear();
}