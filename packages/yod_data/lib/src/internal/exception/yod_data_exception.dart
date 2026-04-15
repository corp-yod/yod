class YodDataException implements Exception {
  String message;
  final dynamic _baseException;
  dynamic rawData;
  YodDataException(this.message, {dynamic exception, this.rawData})
    : _baseException = exception;

  dynamic get baseException => _baseException;
  dynamic get raw => rawData;

  @override
  String toString() {
    return "$message${baseException != null ? '|$baseException' : ''}";
  }
}

class YodDataTimeoutException extends YodDataException {
  YodDataTimeoutException(super.message, {super.exception});
}
