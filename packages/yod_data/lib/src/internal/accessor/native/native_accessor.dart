import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yod_data/src/internal/connector/isar/base_isar.dart';
import 'package:yod_data/src/internal/connector/memory_storage/memory_storage_imp.dart';
import 'package:yod_data/src/internal/connector/secure_stroge/base_secure_stroge.dart';
import 'package:yod_data/src/internal/exception/yod_data_exception.dart';
import 'package:yod_data/src/yod_data_interface/platform_interface/model/export_model.dart';

class NativeAccessor {
  @visibleForTesting
  static set instance(NativeAccessor value) => _instance = value;

  factory NativeAccessor() => _instance;

  NativeAccessor._internal();

  static NativeAccessor _instance = NativeAccessor._internal();

  static NativeAccessor get instance => _instance;

  final Map<String, NativeResource> _resources = {};

  IsarStorage getIsarStorage(String resourceId) {
    if (!hasResource(resourceId)) {
      throw YodDataException(
        'YodDataBackgroundManager for resourceId $resourceId not found. Please register the resource first.',
      );
    }
    return _resources[resourceId]!.isarStorage;
  }

  SecureStorage getSecureStorage(String resourceId) {
    if (!hasResource(resourceId)) {
      throw YodDataException(
        'YodDataBackgroundManager for resourceId $resourceId not found. Please register the resource first.',
      );
    }
    return _resources[resourceId]!.secureStorage;
  }

  MemoryStorage getMemoryStorage(String resourceId) {
    if (!hasResource(resourceId)) {
      throw YodDataException(
        'YodDataBackgroundManager for resourceId $resourceId not found. Please register the resource first.',
      );
    }
    return _resources[resourceId]!.memoryStorage;
  }

  /// Registers a new resource with the given ID if it doesn't already exist.
  ///
  /// @param resourceId The unique identifier for the resource
  /// @return The registered AppInternalResource
  NativeResource register(String resourceId, {bool supportEncryption = true}) {
    if (!hasResource(resourceId)) {
      _resources[resourceId] = _internalRegister(resourceId);
    }
    return _resources[resourceId]!;
  }

  NativeResource _internalRegister(
    String resourceId, {
    bool registerEncryption = true,
  }) {
    final nativeDBResource = NativeResource(resourceId);

    if (registerEncryption) {
      //TODO: add encryption register
    }

    nativeDBResource.registerIsarStorage(IsarStorage());
    nativeDBResource.registerSecureStorage(SecureStorageImp());
    nativeDBResource.registerMemoryStorage(MemoryStorageImp());
    return nativeDBResource;
  }

  /// Unregisters a resource with the given ID.
  /// @param resourceId The unique identifier for the resource
  void unregister(String resourceId) {
    if (hasResource(resourceId)) {
      _resources.remove(resourceId);
    }
  }

  /// Checks if a resource with the given ID exists.
  ///
  /// @param resourceId The unique identifier for the resource
  /// @return True if the resource exists, false otherwise
  bool hasResource(String resourceId) {
    return _resources.containsKey(resourceId);
  }

  /// Gets the AppInternalResource for a given resource ID.
  /// @param resourceId The unique identifier for the resource
  /// @return The AppInternalResource for the specified resource
  NativeResource getResource(String resourceId) {
    var resource = _resources[resourceId];
    if (resource == null) {
      throw YodDataException(
        'YodData not found resource with id: $resourceId. Please register the resource first.',
      );
    } else {
      return resource;
    }
  }

  /// Clears all registered resources.
  /// This is useful for resetting the state of the accessor.
  void clear() {
    _resources.clear();
  }

  Future<Directory> cacheLocation() async {
    var tempPath = '/mfaf.core_data_cache/';
    Directory directory = Directory(tempPath);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    return directory;
  }

  Future<Directory> cacheMessageLocation({String? myId}) async {
    var baseCacheLocation = await cacheLocation();
    var path =
        '${baseCacheLocation.path}message_temp${myId != null ? '/$myId' : ''}';
    var directory = Directory(path);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    return directory;
  }

  Future<Directory> cacheTempLocation() async {
    var baseCacheLocation = await cacheLocation();
    var path = '${baseCacheLocation.path}temp';
    var directory = Directory(path);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    return directory;
  }

  Future<String> get storageLocation async {
    final dir = await getApplicationDocumentsDirectory();

    return '${dir.path}/db';
  }

  Future<String> get isarLocation async {
    var path = '${await storageLocation}/isar';
    var isarDirectory = Directory(path);
    if (!isarDirectory.existsSync()) {
      isarDirectory.createSync(recursive: true);
    }
    return path;
  }

  Future<String> get realmLocation async {
    var path = '${await storageLocation}/realm';
    var realmDirectory = Directory(path);
    if (!realmDirectory.existsSync()) {
      realmDirectory.createSync(recursive: true);
    }
    return path;
  }

  static bool isProcessIsolate() {
    try {
      return Isolate.current.debugName != null &&
          Isolate.current.debugName != 'main';
    } catch (_) {}
    return false;
  }

  static void deleteRealmFile(String realmLocation) {
    try {
      // Realm.deleteRealm(realmLocation);
      _deleteFile(realmLocation);
    } catch (e, s) {
      print('delete realm file $realmLocation fail: e:$e s:$s');
    }
  }

  static void _deleteFile(String filePath) {
    _deleteRealmFile(filePath);
    _deleteRealmLock(filePath);
    _deleteRealmManagement(filePath);
  }

  static void _deleteRealmManagement(String filePath) {
    Directory d = Directory('$filePath.management');
    if (d.existsSync()) {
      d.delete(recursive: true).onError((error, stackTrace) => d);
    }
  }

  static void _deleteRealmLock(String filePath) {
    File f = File('$filePath.lock');
    if (f.existsSync()) {
      f.delete(recursive: true).onError((error, stackTrace) => f);
    }
  }

  static void _deleteRealmFile(String filePath) {
    File f = File(filePath);
    if (f.existsSync()) {
      f.delete(recursive: true).onError((error, stackTrace) => f);
    }
  }
}

class NativeResource {
  final String _resourceId;

  IsarStorage? _isarStorage;
  SecureStorage? _secureStorage;
  MemoryStorage? _memoryStorage;

  NativeResource(this._resourceId);

  void registerIsarStorage(IsarStorage isarStorage) {
    _isarStorage = isarStorage;
  }

  void registerSecureStorage(SecureStorage secureStorage) {
    _secureStorage = secureStorage;
  }

  void registerMemoryStorage(MemoryStorage memoryStorage) {
    _memoryStorage = memoryStorage;
  }

  String get resourceId => _resourceId;

  IsarStorage get isarStorage =>
      _isarStorage ??
      (throw YodDataException(
        'IsarStorage for resourceId $_resourceId not registered',
      ));

  SecureStorage get secureStorage =>
      _secureStorage ??
      (throw YodDataException(
        'SecureStorage for resourceId $_resourceId not registered',
      ));

  MemoryStorage get memoryStorage =>
      _memoryStorage ??
      (throw YodDataException(
        'MemoryStorage for resourceId $_resourceId not registered',
      ));
}
