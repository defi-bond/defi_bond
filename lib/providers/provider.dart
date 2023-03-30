/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import 'package:stake_pool_lotto/storage/user_data_storage.dart';


/// Provider Status
/// ------------------------------------------------------------------------------------------------

enum SPLProviderStatus {
  
  uninitialized(0),
  initialized(20),
  updating(40),
  updated(60),
  error(80),
  ;

  const SPLProviderStatus(this.level);

  final int level;
}


/// Provider
/// ------------------------------------------------------------------------------------------------

abstract class SPLProvider<T extends SerializableMixin> extends ValueNotifier<T?> {

  SPLProvider()
    : super(null);

  String get storageKey;

  T Function(Map<String, dynamic>) get decoder;

  SPLProviderStatus status = SPLProviderStatus.uninitialized;

  bool get isError => status == SPLProviderStatus.error;

  bool get isUninitialized => status == SPLProviderStatus.uninitialized;

  bool get isUpdating => status == SPLProviderStatus.updating;

  bool get isUpdated => status.level >= SPLProviderStatus.updated.level;

  @override
  set value(final T? newValue) {
    if (value != newValue) {
      super.value = newValue;
      save(newValue).ignore();
    }
  }

  void initialize() {
    if (status == SPLProviderStatus.uninitialized) {
      super.value = SPDUserDataStorage.shared.getType(storageKey, decoder);
      status = SPLProviderStatus.initialized;
      notifyListeners();
    }
  }

  @protected
  Future<T> fetch(final SolanaWalletProvider provider);

  Future<void> update(
    final SolanaWalletProvider provider, { 
    final SPLProviderStatus? notifyLevel, 
  }) async {
    final currentStatus = status;
    try {
      if (currentStatus.level < SPLProviderStatus.updating.level) {
        status = SPLProviderStatus.updating;
      }
      final T value = await fetch(provider);
      status = SPLProviderStatus.updated;
      this.value = value;
    } catch(error, stackTrace) {
      print('ERROR [$runtimeType.update] : $error');
      print('STACK [$runtimeType.update] : $stackTrace');
      if (notifyLevel == null || notifyLevel.level > status.level) {
        status = SPLProviderStatus.error;
        notifyListeners();
      } else {
        status = currentStatus;
        rethrow;
      }
    }
  }

  @protected
  Future<void> save(final T? value) {
    return value != null
      ? SPDUserDataStorage.shared.setType(storageKey, value)
      : SPDUserDataStorage.shared.delete(storageKey);
  }
}