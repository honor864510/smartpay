class ParseSdkException implements Exception {
  final Object? error;
  final String? message;
  final StackTrace stackTrace;

  ParseSdkException(this.message, {this.error, StackTrace? stackTrace})
    : stackTrace = stackTrace ?? StackTrace.current;

  @override
  String toString() => 'ParseSdkException: ${message ?? error}';
}
