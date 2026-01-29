class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Tatizo la seva']);

  @override
  String toString() => message;
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Tatizo la hifadhi ya data']);

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Hakuna muunganisho wa mtandao']);

  @override
  String toString() => message;
}

class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Tatizo la uthibitishaji']);

  @override
  String toString() => message;
}

class ValidationException implements Exception {
  final String message;
  const ValidationException([this.message = 'Tatizo la uthibitishaji wa data']);

  @override
  String toString() => message;
}
