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

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache error']);

  @override
  String toString() => 'CacheException: $message';
}

class ServerException implements Exception {
  final int statusCode;
  final String body;
  const ServerException({required this.statusCode, required this.body});

  @override
  String toString() => 'ServerException($statusCode): $body';
}