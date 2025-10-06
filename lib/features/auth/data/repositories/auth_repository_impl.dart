import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
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
      (response) async {
        try {
          await localDataSource.cacheTokens(
            response.accessToken,
            response.refreshToken,
          );
          await localDataSource.cacheUser(response.user);
          return Right(response.user);
        } on CacheException catch (e) {
          return Left(CacheFailure(e.message));
        } catch (e) {
          return Left(CacheFailure('Imeshindwa kuhifadhi taarifa: $e'));
        }
      },
    );
  }

  @override
  Future<Either<Failure, void>> logout({bool clearData = false}) async {
    try {
      await localDataSource.clearAuthData();
      // If clearData is true, could trigger a database clear here
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to logout: $e'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      return Right(user);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to get current user: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final token = await localDataSource.getAccessToken();
      return Right(token != null && token.isNotEmpty);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to check authentication: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> refreshAccessToken() async {
    try {
      final refreshToken = await localDataSource.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return const Left(AuthFailure('Hakuna tokeni iliyohifadhiwa'));
      }

      final result = await remoteDataSource.refreshToken(refreshToken);

      return result.fold(
        (failure) => Left(failure),
        (newAccessToken) async {
          try {
            await localDataSource.cacheTokens(newAccessToken, refreshToken);
            return Right(newAccessToken);
          } on CacheException catch (e) {
            return Left(CacheFailure(e.message));
          } catch (e) {
            return Left(CacheFailure('Imeshindwa kuhifadhi tokeni: $e'));
          }
        },
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Imeshindwa kupata tokeni: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> setActiveModule(int moduleId) async {
    try {
      await localDataSource.setActiveModule(moduleId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to set active module: $e'));
    }
  }

  @override
  Future<Either<Failure, String?>> getActiveModule() async {
    try {
      final module = await localDataSource.getActiveModule();
      return Right(module);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to get active module: $e'));
    }
  }
}
