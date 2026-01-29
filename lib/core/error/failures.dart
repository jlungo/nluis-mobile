import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Tatizo la seva']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Tatizo la hifadhi ya data'])
      : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Hakuna muunganisho wa mtandao'])
      : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure([String message = 'Tatizo la uthibitishaji'])
      : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Tatizo la uthibitishaji wa data'])
      : super(message);
}
