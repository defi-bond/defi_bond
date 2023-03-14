/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import 'package:stake_pool_lotto/storage/user_data_storage.dart';


/// Value Notifier Status
/// ------------------------------------------------------------------------------------------------

enum SPDValueNotifierStatus {
  uninitialized,
  initialized,
  error,
}


/// Value Notifier
/// ------------------------------------------------------------------------------------------------

abstract class SPDValueNotifier<T extends BorshSerializableMixin> extends ValueNotifier<T?> {

  SPDValueNotifier([super.value]);

  String get storageKey;

  Codec<T, Iterable<u8>> get storageCodec;

  SPDValueNotifierStatus status = SPDValueNotifierStatus.uninitialized;

  @override
  set value(T? newValue) {
    super.value = newValue;
    saveValue(newValue).ignore();
  }

  @protected
  Future<T> fetch();

  T? loadValue() {
    final String? encoded = SPDUserDataStorage.shared.getString(storageKey);
    return encoded != null
      ? storageCodec.decode(base64.decode(encoded))
      : null;
  }

  Future<void> saveValue(final T? value) {
    final String? encoded = value != null
      ? base64.encode(value.serialize().toList(growable: false))
      : null;
    return encoded != null 
      ? SPDUserDataStorage.shared.setString(storageKey, encoded)
      : SPDUserDataStorage.shared.delete(storageKey);
  }

  Future<void> initialize() async {
    try {
      final T newValue = await fetch();
      status = SPDValueNotifierStatus.initialized;
      value = newValue;
    } catch (error, stackTrace) {
      print('ERROR [$runtimeType.initialize] : $error');
      print('STACK [$runtimeType.initialize] : $stackTrace');
      status = SPDValueNotifierStatus.error;
      value = loadValue();
    }
  }

  Future<void> update({ final bool silently = true }) async {
    try {
      value = await fetch();
    } catch (error, stackTrace) {
      print('ERROR [$runtimeType.update] : $error');
      print('STACK [$runtimeType.update] : $stackTrace');
      if (!silently) {
        status = SPDValueNotifierStatus.error;
        notifyListeners();
      }
    }
  }
}