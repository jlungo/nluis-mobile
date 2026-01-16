import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    final result = await remoteDataSource.login(email, password);

    return result.fold(
      (failure) => Left(failure),
      (authResponse) async {
        await localDataSource.saveTokens(
          authResponse.accessToken,
          authResponse.refreshToken,
        );

        await localDataSource.saveUser(authResponse.user);

        return Right(authResponse.user);
      },
    );
  }

  @override
  Future<Either<Failure, void>> logout({bool clearData = false}) async {
    return await localDataSource.clearUser();
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    return await localDataSource.getUser();
  }

  @override
  Future<Either<Failure, void>> setActiveModule(int moduleId) async {
    return await localDataSource.setActiveModule(moduleId);
  }

  @override
  Future<Either<Failure, String?>> getActiveModule() async {
    return await localDataSource.getActiveModule();
  }
}
