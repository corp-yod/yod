import 'dart:async';

import 'package:dio/dio.dart';
import 'package:yod_network_http/src/model/request_config.dart';

class ResponseHandler {
  static final ResponseHandler _instance = ResponseHandler._internal();
  factory ResponseHandler() => _instance;
  ResponseHandler._internal();

  void processResponse(
    Response response,
    RequestConfig requestConfig,
    Future<Function(List<String>)> statStopWatch,
  ) {
    String requestUrl =
        requestConfig.yodHttpBaseOption.legacy ??
        requestConfig.yodHttpBaseOption.urlName;

    if (response.data is ResponseBody) {
      ResponseBody responseBody = response.data as ResponseBody;
      responseBody.stream = responseBody.stream.transform(
        StreamTransformer.fromHandlers(
          handleError: (err, stackTrace, sink) {
            sink.addError(err, stackTrace);
          },
          handleDone: (sink) {
            statStopWatch.then((cb) {
              return cb(['http_res_time', 'http_res_time_$requestConfig']);
            });
            sink.close();
          },
          handleData: (data, sink) {
            sink.add(data);
          },
        ),
      );
    } else {
      statStopWatch.then((cb) {
        return cb(['http_res_time', 'http_res_time_$requestUrl']);
      });
    }

    if (response.statusCode == 429) {
      print('CoreNetwork [HTTP] response url=${response.requestOptions.uri}');
    } else {
      print(
        'CoreNetwork [HTTP] response: url=${response.requestOptions.uri}, statusCode=${response.statusCode}',
      );
    }

    if (response.statusCode == 304) {
    } else {}
  }

  void processDioException(
    DioException e,
    RequestConfig requestConfig,
    Future<Function(List<String>)> statStopWatch,
  ) {
    String requestUrl =
        requestConfig.yodHttpBaseOption.legacy ??
        requestConfig.yodHttpBaseOption.urlName;
    statStopWatch.then(
      (cb) => cb(["http_res_time", "http_res_time_$requestUrl"]),
    );

    if (e.response?.redirects.isNotEmpty ?? false) {
      // final lastRedirect = e.response!.redirects.last.location;
      // final uri = e.response!.requestOptions.uri;
      // final redirectUrl = lastRedirect.scheme.isEmpty
      // ? Uri(scheme: uri.scheme, host: uri.host, path: lastRedirect.path)
      // : lastRedirect;
    }

    if (e.type == DioExceptionType.receiveTimeout) {
    } else if (e.type == DioExceptionType.connectionTimeout) {}
  }

  void processError(
    Object e,
    RequestConfig requestConfig,
    Future<Function(List<String>)> statStopWatch,
  ) {
    String requestUrl =
        requestConfig.yodHttpBaseOption.legacy ??
        requestConfig.yodHttpBaseOption.urlName;
    statStopWatch.then(
      (cb) => cb(["http_res_time", "http_res_time_$requestUrl"]),
    );
  }
}
