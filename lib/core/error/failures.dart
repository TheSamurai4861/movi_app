// core/error/failures.dart
abstract class Failure {
  final String message;

  Failure({required this.message});
}

class ServerFailure extends Failure {
  ServerFailure({required super.message});
}

class FetchDataFailure extends Failure {
  FetchDataFailure(String s, {required super.message});
}

class DatabaseFailure extends Failure {
  DatabaseFailure({required super.message});
}

class NetworkFailure extends Failure {
  NetworkFailure({required super.message});
}
