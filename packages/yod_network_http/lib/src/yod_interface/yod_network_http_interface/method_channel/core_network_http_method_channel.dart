import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:yod_network_http/src/yod_interface/yod_network_http_interface/platform_interface/core_network_http_platform_interface.dart';

/// An implementation of [YodNetworkHttpPlatform] that uses method channels.
class MethodChannelYodNetworkHttp extends YodNetworkHttpPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('yod_network_http');
}
