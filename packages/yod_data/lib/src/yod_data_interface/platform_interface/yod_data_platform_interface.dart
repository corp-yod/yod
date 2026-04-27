import 'package:flutter/material.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:yod_data/src/yod_data_interface/method_channel/yod_data_method_channel.dart';
import 'package:yod_data/src/yod_data_interface/platform_interface/model/export_model.dart';

abstract class YodDataPlatform extends PlatformInterface {
  /// Constructs a YodDataPlatform.
  YodDataPlatform() : super(token: _token);

  factory YodDataPlatform.instanceFor(String resourceId) {
    return YodDataPlatform.instance.delegateFor(resourceId);
  }

  static final Object _token = Object();

  static YodDataPlatform _instance = MethodChannelYodData();

  /// The default instance of [YodDataPlatform] to use.
  ///
  /// Defaults to [MethodChannelYodData].
  static YodDataPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [YodDataPlatform] when
  /// they register themselves.
  static set instance(YodDataPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  @protected
  YodDataPlatform delegateFor(String resourceId) {
    throw UnimplementedError('delegateFor() is not implemented');
  }

  Future<void> init({BuildContext? context}) {
    throw UnimplementedError('init() has not been implemented.');
  }

  KeyValueStorage variableStorage({BuildContext? context}) {
    throw UnimplementedError('variableStorage() has not been implemented.');
  }

  SecureStorage secureStorage({BuildContext? context}) {
    throw UnimplementedError('secureStorage() has not been implemented.');
  }

  MemoryStorage memoryStorage({BuildContext? context}) {
    throw UnimplementedError('memoryStorage() has not been implemented.');
  }
}
