import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:yod_network_http/src/yod_interface/yod_network_http_interface/platform_interface/core_network_http_platform_interface.dart';
import 'package:yod_network_http/yod_network_http.dart';

/// An implementation of [YodNetworkHttpPlatform] that uses method channels.
class MethodChannelYodNetworkHttp extends YodNetworkHttpPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('yod_network_http');

  @override
  Future<void> init(HttpInitialValue initialValue) async {
    try {
      await methodChannel.invokeMethod<void>('init', {
        'channel': initialValue.channel,
        // เพิ่ม properties อื่นๆ ถ้ามี
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to initialize YodNetworkHttp: ${e.message}');
      rethrow;
    }
  }
}
