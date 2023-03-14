/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart' show SerializableMixin;
import 'data_storage.dart';


/// User Data Storage
/// ------------------------------------------------------------------------------------------------

class SPDUserDataStorage extends SPDDataStorage {

  /// A wrapper around [SharedPreferences].
  const SPDUserDataStorage._();

  /// The [SPDUserDataStorage] class' singleton instance.
  static const SPDUserDataStorage shared = SPDUserDataStorage._();

  /// The application's [SharedPreferences] instance.
  static late final SharedPreferences _instance;

  /// Load the application's [SharedPreferences] instance from disk.
  Future<SharedPreferences> initialise() async {
    return _instance = await SharedPreferences.getInstance();
  }

  @override
  bool? getBool(String key) {
    return _instance.getBool(key);
  }

  @override
  double? getDouble(String key) {
    return _instance.getDouble(key);
  }

  @override
  int? getInt(String key) {
    return _instance.getInt(key);
  }

  @override
  String? getString(String key) {
    return _instance.getString(key);
  }

  @override
  List<String>? getStringList(String key) {
    return _instance.getStringList(key);
  }

  @override
  Map<String, dynamic>? getMap(String key) {
    return decode(_instance.getString(key));
  }

  @override
  List<Map<String, dynamic>>? getMapList(String key) {
    final List<String>? mapListString = _instance.getStringList(key);
    return mapListString?.map(json.decode).toList(growable: false).cast();
  }

  @override
  T? getType<T extends SerializableMixin>(
    final String key, 
    final SPDDataDecoder<T> decoder,
  ) {
    final Map<String, dynamic>? json = getMap(key);
    print('LOADED MAP = ${json}');
    return json != null ? decoder(json) : null;
  }
  
  @override
  List<T>? getTypeList<T extends SerializableMixin>(
    final String key, 
    final SPDDataDecoder<T> decoder,
  ) {
    final List<Map<String, dynamic>>? mapList = getMapList(key);
    return mapList?.map(decoder).toList(growable: false);
  }

  @override
  Future<bool> setBool(String key, bool value) {
    return _instance.setBool(key, value);
  }

  @override
  Future<bool> setDouble(String key, double value) {
    return _instance.setDouble(key, value);
  }

  @override
  Future<bool> setInt(String key, int value) {
    return _instance.setInt(key, value);
  }

  @override
  Future<bool> setString(String key, String value) {
    return _instance.setString(key, value);
  }

  @override
  Future<bool> setStringList(String key, Iterable<String> value) {
    return _instance.setStringList(key, value.toList(growable: false));
  }

  @override
  Future<bool> setMap(String key, Map<String ,dynamic> value) {
    return _instance.setString(key, json.encode(value));
  }

  @override
  Future<bool> setMapList(String key, Iterable<Map<String ,dynamic>> value) {
    final List<String> mapListString = value.map(json.encode).toList(growable: false);
    return _instance.setStringList(key, mapListString);
  }
  
  @override
  Future<bool> setType<T extends SerializableMixin>(final String key, final T value) {
    return setMap(key, value.toJson());
  }

  @override
  Future<bool> setTypeList<T extends SerializableMixin>(final String key, final Iterable<T> value) {
    return setMapList(key, value.map((e) => e.toJson()));
  }

  @override
  Future<bool> delete(String key) {
    return _instance.remove(key);
  }

  @override
  Future<bool> clear() {
    return _instance.clear();
  }
}