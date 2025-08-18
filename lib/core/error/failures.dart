abstract class Failure {
  final String message;
  final dynamic data;

  const Failure({
    required this.message,
    required this.data,
  });

  @override
  String toString() => 'Failure(message: $message, data: $data)';
}

class OfflineFailure extends Failure {
  const OfflineFailure({required super.message, super.data});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, required super.data});
}

class EmptyCacheFailure extends Failure {
  const EmptyCacheFailure({required super.message, super.data});
}

/// exception in fromMap or fromJson
class SerializeFailure extends Failure {
  const SerializeFailure({required super.message, super.data});
}
