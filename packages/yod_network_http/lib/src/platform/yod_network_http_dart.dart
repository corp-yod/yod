// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:yod_network_http/src/handler/request_handler.dart';
import 'package:yod_network_http/src/model/request_config.dart';
import 'package:yod_network_http/src/yod_interface/yod_network_http_interface/model/http_base_option.dart';
import 'package:yod_network_http/src/yod_interface/yod_network_http_interface/model/http_initial_value.dart';
import 'package:yod_network_http/src/yod_interface/yod_network_http_interface/platform_interface/core_network_http_platform_interface.dart';

/// A Dart implementation of the YodNetworkHttpPlatform for iOS and Android.
class YodNetworkHttpDart extends YodNetworkHttpPlatform {
  /// Constructs a YodNetworkHttpDart
  YodNetworkHttpDart();

  static void registerWith() {
    YodNetworkHttpPlatform.instance = YodNetworkHttpDart();
  }

  @override
  Future<void> init(HttpInitialValue initialValue) async {
    print(
      '#->>> CoreNetwork [HTTP] init: initialValue=${initialValue.toJson()}',
    );
    // await NetworkHelper().initConstants(initialValue);
    // await NetworkHelper().subscribeConnectivityChanged();
    // await CacheHelper().init();
  }

  @override
  Future<Response<dynamic>> request(
    YodHttpBaseOption option, {
    BuildContext? context,
  }) async {
    print(
      'CoreNetwork [HTTP] request: option=${option.toJson()}, context=$context',
    );
    RequestConfig requestConfig = await RequestHandler().buildRequestConfig(
      option: option,
      context: context,
    );
    print('CoreNetwork [HTTP] request: config=${requestConfig.toJson()}');
    return await RequestHandler().request(
      requestConfig: requestConfig,
      context: context,
    );
  }

  // @override
  // Stream<dynamic> requestStream(
  //   YodHttpBaseOption option, {
  //   BuildContext? context,
  //   bool alwaysOpen = false,
  // }) {
  //   print(
  //     'CoreNetwork [HTTP] request stream: option=${option.toJson()}, context=$context',
  //   );
  //   StreamController<Response> controller = StreamController<Response>();
  //   RequestConfig requestConfig = RequestHandler().buildRequestConfig(
  //     option: option,
  //     context: context,
  //   );
  //   print(
  //     'CoreNetwork [HTTP] request stream: config=${requestConfig.toJson()}',
  //   );
  //   Uri url = Uri.parse(
  //     requestConfig.url,
  //   ).replace(queryParameters: option.queryParameters);
  //   String streamKey = CacheHelper().generateCacheKey(url, option.cacheKey);
  //   print(
  //     'CoreNetwork [HTTP] request stream: controller start, streamKey=$streamKey, url=$url, cacheKey=${option.cacheKey}',
  //   );
  //   ManageController manageController = ManageController(
  //     controller: controller,
  //     alwaysOpen: alwaysOpen,
  //   );
  //   if (RequestStreamManager().tableUrlRequestStreamHttp.containsKey(
  //     streamKey,
  //   )) {
  //     RequestStreamManager().tableUrlRequestStreamHttp[streamKey]!.add(
  //       manageController,
  //     );
  //     if (alwaysOpen) {
  //       RequestHandler().request(
  //         requestConfig: requestConfig,
  //         context: context,
  //       );
  //     }
  //   } else {
  //     RequestStreamManager().tableUrlRequestStreamHttp.addAll({
  //       streamKey: [manageController],
  //     });
  //     RequestHandler().request(requestConfig: requestConfig, context: context);
  //   }
  //   controller.done.then((_) {
  //     print(
  //       'CoreNetwork [HTTP] request stream: controller close, streamKey=$streamKey, url=$url, cacheKey=${option.cacheKey}',
  //     );
  //     RequestStreamManager().controllerDoneHttp(
  //       streamKey,
  //       url,
  //       option.cacheKey,
  //       manageController,
  //     );
  //   });
  //   return controller.stream;
  // }

  // @override
  // Future<void> checkPrefetchPrefixConfig() async {
  //   await PrefetchHelper().checkPrefetchPrefixConfig();
  // }

  // @override
  // Future<void> runPrefetch() async {
  //   await PrefetchHelper().runPrefetch();
  // }

  // @override
  // Future<void> clearAllPrefetch() async {
  //   await PrefetchHelper().clearAllPrefetch();
  // }

  // @override
  // Future<void> clearAllCache() async {
  //   await CacheHelper().clearAllCache();
  // }

  // @override
  // Future<void> deleteCache(
  //   String url, {
  //   String? cacheKey,
  //   Duration delayDelete = Duration.zero,
  //   Function? callback,
  // }) async {
  //   await CacheHelper().deleteCache(
  //     url,
  //     cacheKey: cacheKey,
  //     delayDelete: delayDelete,
  //     callback: callback,
  //   );
  // }

  // @override
  // Future<Result<String?, CoreNetworkHttpError>> getCurrentIp() async {
  //   return NetworkHelper().getCurrentIp();
  // }
}
