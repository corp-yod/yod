import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yod_network_http/src/model/request_config.dart';

class DioHelper {
  static final DioHelper _instance = DioHelper._internal();
  factory DioHelper() => _instance;
  DioHelper._internal();

  Dio dioClient({required RequestConfig requestConfig, BuildContext? context}) {
    final Duration timeout =
        requestConfig.yodHttpBaseOption.timeout ?? Duration(seconds: 30);
    final Duration? receiveTimeout =
        requestConfig.yodHttpBaseOption.responseType == 'stream'
        ? null
        : timeout;

    Dio dio = Dio(
      BaseOptions(
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: receiveTimeout,
      ),
    );

    // dio.interceptors.add(AuthInterceptor(tokenStorage));
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
        ),
      );
    }

    return dio;
  }
}
