import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:yod_data/src/yod_data_interface/platform_interface/yod_data_platform_interface.dart';

class MethodChannelYodData extends YodDataPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('yod_data');

  // @override
  // YodDataPlatform delegateFor(String resourceId) {
  //   return MethodChannelYodData();
  // }
}
