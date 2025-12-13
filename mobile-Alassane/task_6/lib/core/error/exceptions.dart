class NoInternetConnectionException implements Exception {
  final String message;
  NoInternetConnectionException([this.message = 'No internet connection']);
  @override
  String toString() => 'NoInternetConnectionException: $message';
}

class CacheMissException implements Exception {
  final String message;
  CacheMissException([this.message = 'No cached data']);
  @override
  String toString() => 'CacheMissException: $message';
}