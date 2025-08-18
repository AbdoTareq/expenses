class ServerException implements Exception {
  final String? message;
  final dynamic data;

  ServerException({this.message, this.data});

  @override
  String toString() => 'ServerException(message: $message, data: $data)';
}

class RequestException implements Exception {}

class EmptyCacheException implements Exception {}

class OfflineException implements Exception {}

class SerializeException implements Exception {}
