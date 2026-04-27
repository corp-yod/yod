import 'package:flutter/material.dart';
import 'package:yod_data/src/internal/accessor/native/native_accessor.dart';
import 'package:yod_data/src/internal/connector/secure_stroge/base_secure_stroge.dart';
import 'package:yod_data/src/yod_data_interface/platform_interface/model/export_model.dart';
import 'package:yod_data/src/yod_data_interface/platform_interface/yod_data_platform_interface.dart';

class YodDataDart extends YodDataPlatform {
  final String _resourceId;

  static void registerWith() {
    YodDataPlatform.instance = YodDataDart();
  }

  YodDataDart({String resourceId = 'default', bool requireEncryption = true})
    : _resourceId = resourceId {
    print(
      ' #->>> YodDataDart constructor: resourceId=$_resourceId, requireEncryption=$requireEncryption',
    );
    _registerInstance(requireEncryption: requireEncryption);
  }

  void _registerInstance({bool requireEncryption = true}) {
    NativeAccessor.instance.register(
      _resourceId,
      supportEncryption: requireEncryption,
    );
  }

  Future<void> _initIsarStorage(NativeResource resource) async {
    final isarStorage = resource.isarStorage;
    await isarStorage.init();

    await isarStorage.register(dbName: 'variable');
  }

  void _initSecureStorage(NativeResource resource) {
    final secureStorage = resource.secureStorage as SecureStorageImp;

    try {
      secureStorage.ready();
      debugPrint('SecureStorage initialized successfully');
    } catch (e, s) {
      debugPrint('SecureStorage initialization failed: e:$e s:$s');
      secureStorage.fail(e, s);
    }
  }

  @override
  YodDataPlatform delegateFor(String resourceId) {
    return YodDataDart(resourceId: resourceId);
  }

  @override
  Future<void> init({BuildContext? context}) async {
    print('#->>> YodData init: resourceId=$_resourceId');
    final resource = NativeAccessor.instance.getResource(_resourceId);
    await _initIsarStorage(resource);
    _initSecureStorage(resource);
  }

  @override
  KeyValueStorage variableStorage({BuildContext? context}) {
    return NativeAccessor.instance
        .getIsarStorage(_resourceId)
        .getStorage(dbName: 'variable');
  }

  @override
  SecureStorage secureStorage({BuildContext? context}) {
    return NativeAccessor.instance.getSecureStorage(_resourceId);
  }

  @override
  MemoryStorage memoryStorage({BuildContext? context}) {
    return NativeAccessor.instance.getMemoryStorage(_resourceId);
  }
}
