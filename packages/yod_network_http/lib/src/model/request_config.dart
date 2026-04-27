import 'package:flutter/widgets.dart';
import 'package:yod_network_http/src/yod_interface/yod_network_http_interface/model/enum.dart';
import 'package:yod_network_http/src/yod_interface/yod_network_http_interface/model/http_base_option.dart';

class RequestConfig {
  BuildContext? context;
  String url;
  Method method;
  YodHttpBaseOption yodHttpBaseOption;
  Map<String, String>? headers;
  bool isAuthorization;

  RequestConfig({
    this.context,
    required this.url,
    required this.method,
    required this.yodHttpBaseOption,
    this.headers,
    this.isAuthorization = false,
  });

  Map<dynamic, dynamic> toJson() {
    return {
      'context': context?.toString(),
      'url': url,
      'method': method.name,
      'yodHttpBaseOption': yodHttpBaseOption.toJson(),
      'headers': headers,
      'isAuthorization': isAuthorization,
    };
  }

  factory RequestConfig.fromJson(Map<dynamic, dynamic> json) {
    return RequestConfig(
      context: null,
      url: json['url'],
      method: Method.values.firstWhere((e) => e.name == json['method']),
      yodHttpBaseOption: YodHttpBaseOption.fromJson(json['yodHttpBaseOption']),
      headers: Map<String, String>.from(json['headers']),
      isAuthorization: json['isAuthorization'] ?? false,
    );
  }
}
