import 'package:flutter/widgets.dart';
import 'package:yod_network_http/src/yod_interface/yod_network_http_interface/method_channel/core_network_http_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:yod_network_http/src/yod_interface/yod_network_http_interface/model/http_base_option.dart';
import 'package:yod_network_http/src/yod_interface/yod_network_http_interface/model/http_initial_value.dart';

abstract class YodNetworkHttpPlatform extends PlatformInterface {
  /// Constructs a YodNetworkHttpPlatform.
  YodNetworkHttpPlatform() : super(token: _token);

  static final Object _token = Object();

  static YodNetworkHttpPlatform _instance = MethodChannelYodNetworkHttp();

  /// The default instance of [YodNetworkHttpPlatform] to use.
  ///
  /// Defaults to [MethodChannelCoreNetworkHttp].
  static YodNetworkHttpPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [YodNetworkHttpPlatform] when
  /// they register themselves.
  static set instance(YodNetworkHttpPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> init(HttpInitialValue initialValue) async {
    throw UnimplementedError('init() has not been implemented.');
  }

  Future<dynamic> request(YodHttpBaseOption option, {BuildContext? context}) {
    throw UnimplementedError('request() has not been implemented.');
  }

  Stream<dynamic> requestStream(
    YodHttpBaseOption option, {
    BuildContext? context,
    bool alwaysOpen = false,
  }) {
    throw UnimplementedError('requestStream() has not been implemented.');
  }

  Future<void> checkPrefetchPrefixConfig() {
    throw UnimplementedError(
      'checkPrefetchPrefixConfig() has not been implemented.',
    );
  }

  Future<void> runPrefetch() async {
    throw UnimplementedError('runPrefetch() has not been implemented.');
  }

  Future<void> clearAllPrefetch() async {
    throw UnimplementedError('clearAllPrefetch() has not been implemented.');
  }

  Future<void> clearAllCache() async {
    throw UnimplementedError('clearAllCache() has not been implemented.');
  }

  Future<void> deleteCache(
    String url, {
    String? cacheKey,
    Duration delayDelete = Duration.zero,
    Function? callback,
  }) async {
    throw UnimplementedError('deleteCache() has not been implemented.');
  }

  // Future<Result<String?, CoreNetworkHttpError>> getCurrentIp() async {
  //   throw UnimplementedError('getCurrentIp() has not been implemented.');
  // }
}
