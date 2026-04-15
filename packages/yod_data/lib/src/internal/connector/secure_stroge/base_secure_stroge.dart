import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yod_data/src/yod_data_interface/platform_interface/model/export_model.dart';

class SecureStorageImp extends SecureStorage {
  final FlutterSecureStorage _storage;
  final Completer<void> _setupCompleter;

  SecureStorageImp()
    : _setupCompleter = Completer<void>(),
      _storage = const FlutterSecureStorage(
        iOptions: IOSOptions(),
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
        webOptions: WebOptions(),
      );

  void ready() {
    if (!_setupCompleter.isCompleted) {
      _setupCompleter.complete();
    }
  }

  void fail(Object error, [StackTrace? stackTrace]) {
    if (!_setupCompleter.isCompleted) {
      _setupCompleter.completeError(error, stackTrace);
    }
  }

  Future<void> _ensureSetup() {
    return _setupCompleter.future;
  }

  Future<T?> forceGetKeyValue<T>(String key) {
    return _storage.read(key: key).then((value) => value as T?);
  }

  @override
  Future<Set<String>> getAllKey() {
    return _storage.readAll().then((value) => value.keys.toSet());
  }

  @override
  Future<T?> getKeyValue<T>(String key, {bool ensureSetup = false}) {
    if (!ensureSetup) {
      return forceGetKeyValue<T>(key);
    }
    return _ensureSetup().then((_) => forceGetKeyValue(key));
  }

  @override
  Future<void> removeKeyValue(String key) {
    return _storage.delete(key: key);
  }

  @override
  Future<void> setKeyValue(String key, value) {
    return _storage.write(key: key, value: value);
  }
}
