final class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

final class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}

final class NetworkException implements Exception {
  final String? message;
  const NetworkException(this.message);
}

final class RequestException implements Exception {
  final String message;
  const RequestException(this.message);
}
