import 'package:dio/dio.dart';
import 'package:yod_network_http/src/yod_interface/yod_network_http_interface/model/enum.dart';

class YodHttpBaseOption {
  /// Reference name used to look up MDM configuration and retrieve the path URL value.
  String urlName;
  Method method;
  Map<String, String>? pathParameters;
  Map<String, dynamic>? queryParameters;
  Map<String, String>? headers;
  String? legacy;
  List<int>? validateStatus;
  String? responseType;

  /// Defaults to `application/json; charset=utf-8`.
  String? contentType;
  dynamic body;

  /// Defaults to `Duration(minutes: 1)`.
  Duration? timeout;

  /// Defaults to `false`.
  bool isCache;
  String? cacheKey;

  /// Defaults to `false`.
  bool forceLocalCache;

  /// Defaults to `Duration(seconds: 300)`.
  Duration? cacheMaxAge;

  /// Defaults to `false`.
  bool refreshCache;
  Duration? cacheRefreshTime;

  /// Defaults to `false`.
  bool preFetch;
  int retryCount;
  CancelToken? cancelToken;

  /// This value will be added to the HTTP request header
  /// under the key `"mfaf-useCase"`.
  String? useCase;

  /// This value will be added to the HTTP request header
  /// under the key `"mfaf-useCaseStep"`.
  String? useCaseStep;

  /// This value will be added to the HTTP request header
  /// under the key `"mfaf-channel"`.
  String? channel;

  /// The feature group name from MDM configuration
  /// `MobileDeviceCapabilities.activationFeature.name`
  /// used to identify which group this API option belongs to.
  ///
  /// Defaults to `MobileApiCoreExtMapping`.
  String activationFeatureName;

  /// Whether the HTTP client should allow cookies during requests.
  /// When set to `true`, a `CookieJar` will be attached to the Dio client
  /// to automatically persist and handle cookies for subsequent requests.
  ///
  /// Defaults to `false`.
  bool allowCookies;

  // String originalInvokeID;
  // String _uuID;
  // String _uuIDTransaction;

  // String get invokeId => 'command-oda=$_uuID${HttpInterfaceConstants.deviceId}';
  // String get transactionId =>
  //     'command-oda=$_uuIDTransaction${HttpInterfaceConstants.deviceId}';

  YodHttpBaseOption({
    required this.urlName,
    required this.method,
    this.pathParameters,
    this.queryParameters,
    this.headers,
    this.legacy,
    this.validateStatus,
    this.responseType,
    this.contentType,
    this.body,
    this.timeout,
    this.isCache = false,
    this.cacheKey,
    this.forceLocalCache = false,
    this.cacheMaxAge,
    this.refreshCache = false,
    this.cacheRefreshTime,
    this.preFetch = false,
    this.retryCount = 0,
    this.cancelToken,
    this.useCase,
    this.useCaseStep,
    this.channel,
    this.activationFeatureName = 'MobileApiCoreExtMapping',
    this.allowCookies = false,
  });
  // : _uuID = CoreUtilPlatform.instance.genUUID(),
  //      _uuIDTransaction = CoreUtilPlatform.instance.genUUID(),
  //      originalInvokeID = CoreUtilPlatform.instance.genUUID();

  // void retry() {
  //   _uuID = CoreUtilPlatform.instance.genUUID();
  //   _uuIDTransaction = CoreUtilPlatform.instance.genUUID();
  // }

  Map<dynamic, dynamic> toJson() {
    return {
      'urlName': urlName,
      'method': method.name,
      'pathParameters': pathParameters,
      'queryParameters': queryParameters,
      'headers': headers,
      'legacy': legacy,
      'validateStatus': validateStatus,
      'responseType': responseType,
      'contentType': contentType,
      'body': body,
      'timeout': timeout?.inMilliseconds,
      'isCache': isCache,
      'cacheKey': cacheKey,
      'forceLocalCache': forceLocalCache,
      'cacheMaxAge': cacheMaxAge?.inMilliseconds,
      'refreshCache': refreshCache,
      'cacheRefreshTime': cacheRefreshTime?.inMilliseconds,
      'preFetch': preFetch,
      'retryCount': retryCount,
      // 'originalInvokeID': originalInvokeID,
      // 'invokeId': invokeId,
      // 'transactionId': transactionId,
      'cancelToken': cancelToken,
      'useCase': useCase,
      'useCaseStep': useCaseStep,
      'channel': channel,
      'activationFeatureName': activationFeatureName,
      'allowCookies': allowCookies,
    };
  }

  factory YodHttpBaseOption.fromJson(Map<dynamic, dynamic> json) {
    return YodHttpBaseOption(
      urlName: json['urlName'],
      method: Method.values.firstWhere((e) => e.name == json['method']),
      pathParameters: json['pathParameters'] != null
          ? Map<String, String>.from(json['pathParameters'])
          : null,
      queryParameters: json['queryParameters'] != null
          ? Map<String, dynamic>.from(json['queryParameters'])
          : null,
      headers: json['headers'] != null
          ? Map<String, String>.from(json['headers'])
          : null,
      legacy: json['legacy'],
      validateStatus: json['validateStatus'] != null
          ? List<int>.from(json['validateStatus'])
          : null,
      responseType: json['responseType'],
      contentType: json['contentType'],
      body: json['body'],
      timeout: json['timeout'] != null
          ? Duration(milliseconds: json['timeout'])
          : null,
      isCache: json['isCache'] ?? false,
      cacheKey: json['cacheKey'],
      forceLocalCache: json['forceLocalCache'] ?? false,
      cacheMaxAge: json['cacheMaxAge'] != null
          ? Duration(milliseconds: json['cacheMaxAge'])
          : null,
      refreshCache: json['refreshCache'] ?? false,
      cacheRefreshTime: json['cacheRefreshTime'] != null
          ? Duration(milliseconds: json['cacheRefreshTime'])
          : null,
      preFetch: json['preFetch'] ?? false,
      retryCount: json['retryCount'] ?? 0,
      cancelToken: json['cancelToken'],
      useCase: json['useCase'],
      useCaseStep: json['useCaseStep'],
      channel: json['channel'],
      activationFeatureName:
          json['activationFeatureName'] ?? 'MobileApiCoreExtMapping',
      allowCookies: json['allowCookies'] ?? false,
    );
  }
}
