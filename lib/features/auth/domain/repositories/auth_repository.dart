import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, void>> logout({bool clearData = false});
  Future<Either<Failure, User?>> getCurrentUser();
  Future<Either<Failure, bool>> isAuthenticated();
  Future<Either<Failure, String>> refreshAccessToken();
  Future<Either<Failure, void>> setActiveModule(int moduleId);
  Future<Either<Failure, String?>> getActiveModule();
}
