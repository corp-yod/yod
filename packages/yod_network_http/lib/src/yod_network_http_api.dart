import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:yod_network_http/src/yod_interface/yod_network_http_interface/model/http_base_option.dart';
import 'package:yod_network_http/src/yod_interface/yod_network_http_interface/model/http_initial_value.dart';
import 'package:yod_network_http/src/yod_interface/yod_network_http_interface/platform_interface/core_network_http_platform_interface.dart';

class YodNetworkHttp {
  @visibleForTesting
  static set instance(YodNetworkHttp value) => _instance = value;
  static YodNetworkHttp get instance => _instance;

  static YodNetworkHttp _instance = YodNetworkHttp._internal();
  YodNetworkHttp._internal();
  factory YodNetworkHttp() => _instance;

  Future<void> init(HttpInitialValue initialValue) async {
    await YodNetworkHttpPlatform.instance.init(initialValue);
  }

  Future<Response<dynamic>> request(YodHttpBaseOption option, {BuildContext? context}) {
    return YodNetworkHttpPlatform.instance.request(option, context: context);
  }

  Stream<dynamic> requestStream(
    YodHttpBaseOption option, {
    BuildContext? context,
    bool alwaysOpen = false,
  }) {
    return YodNetworkHttpPlatform.instance.requestStream(
      option,
      context: context,
      alwaysOpen: alwaysOpen,
    );
  }

  Future<void> checkPrefetchPrefixConfig() {
    return YodNetworkHttpPlatform.instance.checkPrefetchPrefixConfig();
  }

  Future<void> runPrefetch() async {
    return YodNetworkHttpPlatform.instance.runPrefetch();
  }

  Future<void> clearAllPrefetch() async {
    return YodNetworkHttpPlatform.instance.clearAllPrefetch();
  }

  Future<void> clearAllCache() async {
    return YodNetworkHttpPlatform.instance.clearAllCache();
  }

  Future<void> deleteCache(
    String url, {
    String? cacheKey,
    Duration delayDelete = Duration.zero,
    Function? callback,
  }) async {
    return YodNetworkHttpPlatform.instance.deleteCache(
      url,
      cacheKey: cacheKey,
      delayDelete: delayDelete,
      callback: callback,
    );
  }

  // Future<Result<String?, YodNetworkHttpError>> getCurrentIp() async {
  //   return YodNetworkHttpPlatform.instance.getCurrentIp();
  // }
}
