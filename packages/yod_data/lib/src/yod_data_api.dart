import 'package:flutter/widgets.dart';
import 'package:yod_data/src/yod_data_interface/platform_interface/model/export_model.dart';
import 'package:yod_data/src/yod_data_interface/platform_interface/yod_data_platform_interface.dart';

// YodData yodData = YodData.instance;

class YodData {
  @visibleForTesting
  static set instance(YodData value) => _instance = value;

  factory YodData() => _instance;

  YodData._internal();

  static YodData _instance = YodData._internal();

  static YodData get instance => _instance;

  Future<void> init({BuildContext? context}) {
    return YodDataPlatform.instance.init(context: context);
  }

  KeyValueStorage variableStorage({BuildContext? context}) {
    return YodDataPlatform.instance.variableStorage(context: context);
  }

  SecureStorage secureStorage({BuildContext? context}) {
    return YodDataPlatform.instance.secureStorage(context: context);
  }

  MemoryStorage memoryStorage({BuildContext? context}) {
    return YodDataPlatform.instance.memoryStorage(context: context);
  }
}
