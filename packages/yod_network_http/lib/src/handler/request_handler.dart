import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:yod_network_http/src/handler/response_handler.dart';
import 'package:yod_network_http/src/helper/dio_helper.dart';
import 'package:yod_network_http/src/model/request_config.dart';
import 'package:yod_network_http/src/yod_interface/yod_network_http_interface/model/http_base_option.dart';

class RequestHandler {
  static final RequestHandler _instance = RequestHandler._internal();
  factory RequestHandler() => _instance;
  RequestHandler._internal();

  RequestConfig buildRequestConfig({
    required YodHttpBaseOption option,
    BuildContext? context,
  }) {
    try {
      // String url;
      // bool isAuthorization = false;
      // mock
      bool isAuthorization = true;

      final Map<String, String> headers = _buildRequestHeaders(
        option: option,
        isAuthorization: isAuthorization,
      );

      RequestConfig requestConfig = RequestConfig(
        context: context,
        url: 'http://localhost:8080',
        method: option.method,
        yodHttpBaseOption: option,
        headers: headers,
        isAuthorization: isAuthorization,
      );
      return requestConfig;
    } catch (e) {
      print(
        'CoreNetwork [HTTP] exception: failed to build request config error=$e',
      );
      throw Exception(
        'CoreNetwork [HTTP] exception: failed to build request config error=$e',
      );
    }
  }

  Map<String, String> _buildRequestHeaders({
    required YodHttpBaseOption option,
    required bool isAuthorization,
  }) {
    final Map<String, String> headers = LinkedHashMap<String, String>(
      equals: (a, b) => a.toLowerCase() == b.toLowerCase(),
      hashCode: (key) => key.toLowerCase().hashCode,
    )..addAll(option.headers?.map((k, v) => MapEntry(k, v.toString())) ?? {});

    try {
      final accessToken = 'accessToken'; // Todo มาทำ get access token เอง
      if (isAuthorization && accessToken != null) {
        headers['Authorization'] = 'Bearer $accessToken';
      }

      headers.addAll({'accept': 'application/json'});
      return headers;
    } catch (e) {
      print('CoreNetwork [HTTP] error: build request headers error=$e');
      return headers;
    }
  }

  Options _buildOptions(RequestConfig requestConfig) {
    try {
      ResponseType? responseType =
          requestConfig.yodHttpBaseOption.responseType != null
          ? ResponseType.values.byName(
              requestConfig.yodHttpBaseOption.responseType!,
            )
          : null;
      String? contentType =
          requestConfig.yodHttpBaseOption.contentType ??
          requestConfig.headers?['content-type'];
      // requestConfig.headers?.remove('content-type');

      Options options = Options(
        method: requestConfig.yodHttpBaseOption.method.name.toUpperCase(),
        headers: requestConfig.headers,
        responseType: responseType,
        contentType: contentType,
      );

      return options;
    } catch (e) {
      print('CoreNetwork [HTTP] error: build request options error=$e');
      return Options();
    }
  }

  Future<Response<dynamic>> request({
    required RequestConfig requestConfig,
    BuildContext? context,
  }) async {
    late Future<Function(List<String>)> statStopWatch = Future.value(
      (List<String> stats) {},
    );
    try {
      Options options = _buildOptions(requestConfig);

      Response response = await DioHelper()
          .dioClient(requestConfig: requestConfig, context: context)
          .request(
            requestConfig.url,
            data: requestConfig.yodHttpBaseOption.body,
            queryParameters: requestConfig.yodHttpBaseOption.queryParameters,
            cancelToken: requestConfig.yodHttpBaseOption.cancelToken,
            options: options,
          )
          .then((Response data) async {
            ResponseHandler().processResponse(
              data,
              requestConfig,
              statStopWatch,
            );
            return data;
          });
      return response;
    } on DioException catch (e) {
      ResponseHandler().processDioException(e, requestConfig, statStopWatch);
      print(
        'CoreNetwork [HTTP] exception: DioException error message=${e.message}, statusCode=${e.response?.statusCode}',
      );
      throw Exception(
        'CoreNetwork [HTTP] exception: DioException error message=${e.message}, statusCode=${e.response?.statusCode}',
      );
    } catch (e) {
      ResponseHandler().processError(e, requestConfig, statStopWatch);
      print('CoreNetwork [HTTP] exception: error=$e');
      rethrow;
    }
  }
}
