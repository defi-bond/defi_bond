/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart' show SerializableMixin;
import '../storage/data_storage.dart';


/// Secure Data Storage
/// ------------------------------------------------------------------------------------------------

class SPDSecureDataStorage extends SPDDataStorage {

  /// A wrapper around [FlutterSecureStorage].
  const SPDSecureDataStorage._();

  /// The [SPDSecureDataStorage] class' singleton instance.
  static SPDSecureDataStorage shared = const SPDSecureDataStorage._();

  /// Return an instance of [FlutterSecureStorage].
  FlutterSecureStorage get _instance => const FlutterSecureStorage();

  /// Check that [value] is a boolean string.
  void _assertBoolStringValue(final String? value) {
    assert(value == null || value == 'true' || value == 'false');
  }

  @override
  Future<bool?> getBool(final String key) async {
    final String? value = await _instance.read(key: key);
    _assertBoolStringValue(value);
    return value != null ? value == 'true' : null;
  }

  @override
  Future<double?> getDouble(final String key) async {
    final String? doubleString = await _instance.read(key: key);
    return doubleString != null ? double.parse(doubleString) : null;
  }

  @override
  Future<int?> getInt(final String key) async {
    final String? intString = await _instance.read(key: key);
    return intString != null ? int.parse(intString) : null;
  }

  @override
  Future<String?> getString(final String key) {
    return _instance.read(key: key);
  }

  @override
  Future<List<String>?> getStringList(final String key) async {
    return decode(await _instance.read(key: key))?.cast<String>();
  }

  @override
  Future<Map<String, dynamic>?> getMap(final String key) async {
    return decode(await _instance.read(key: key));
  }

  @override
  Future<List<Map<String, dynamic>>?> getMapList(final String key) async {
    return decode(await _instance.read(key: key))?.cast<Map<String, dynamic>>();
  }
  
  @override
  FutureOr<T?> getType<T extends SerializableMixin>(
    final String key, 
    final SPDDataDecoder<T> decoder,
  ) async {
    final Map<String, dynamic>? json = await getMap(key);
    return json != null ? decoder(json) : null;
  }
  
  @override
  FutureOr<List<T>?> getTypeList<T extends SerializableMixin>(
    final String key, 
    final SPDDataDecoder<T> decoder,
  ) async {
    final List<Map<String, dynamic>>? mapList = await getMapList(key);
    return mapList?.map(decoder).toList(growable: false);
  }

  @override
  Future<void> setBool(final String key, final bool? value) {
    _assertBoolStringValue(value?.toString());
    return _instance.write(key: key, value: value?.toString());
  }

  @override
  Future<void> setDouble(final String key, final double? value) {
    return _instance.write(key: key, value: value?.toString());
  }

  @override
  Future<void> setInt(final String key, final int? value) {
    return _instance.write(key: key, value: value?.toString());
  }

  @override
  Future<void> setString(final String key, final String? value) {
    return _instance.write(key: key, value: value);
  }

  @override
  Future<void> setStringList(final String key, final List<String>? value) async {
    return _instance.write(key: key, value: encode(value));
  }

  @override
  Future<void> setMap(final String key, final Map<String, dynamic>? value) {
    return _instance.write(key: key, value: encode(value));
  }

  @override
  Future<void> setMapList(final String key, final List<Map<String, dynamic>>? value) {
    return _instance.write(key: key, value: encode(value));
  }

  @override
  Future<void> setType<T extends SerializableMixin>(final String key, final T value) {
    return setMap(key, value.toJson());
  }

  @override
  Future<void> setTypeList<T extends SerializableMixin>(
    final String key, 
    final List<T> value,
  ) {
    return setMapList(key, value.map((e) => e.toJson()).toList(growable: false));
  }

  @override
  Future<void> delete(final String key) {
    return _instance.delete(key: key);
  }

  @override
  Future<void> clear() {
    return _instance.deleteAll();
  }
}