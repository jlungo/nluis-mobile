import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../shared/constants/app_constants.dart';
import '../models/user_model.dart';
import 'token_manager.dart';

abstract class AuthLocalDataSource {
  Future<Either<Failure, void>> saveUser(UserModel user);
  Future<Either<Failure, UserModel?>> getUser();
  Future<Either<Failure, void>> saveTokens(
    String accessToken,
    String refreshToken,
  );
  Future<Either<Failure, void>> clearUser();
  Future<Either<Failure, void>> setActiveModule(int moduleId);
  Future<Either<Failure, String?>> getActiveModule();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  late final TokenManager tokenManager;

  AuthLocalDataSourceImpl({required this.sharedPreferences}) {
    tokenManager = TokenManager(sharedPreferences);
  }

  @override
  Future<Either<Failure, void>> saveUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await Future.wait([
        sharedPreferences.setString(AppConstants.keyUser, userJson),
        sharedPreferences.setString(AppConstants.keyUserId, user.id),
        sharedPreferences.setString(AppConstants.keyUserEmail, user.email),
        sharedPreferences.setBool(AppConstants.keyIsLoggedIn, true),
      ]);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Imeshindwa kuhifadhi taarifa za mtumiaji: $e'));
    }
  }

  @override
  Future<Either<Failure, UserModel?>> getUser() async {
    try {
      final isLoggedIn =
          sharedPreferences.getBool(AppConstants.keyIsLoggedIn) ?? false;

      if (!isLoggedIn) {
        return const Right(null);
      }

      final userJson = sharedPreferences.getString(AppConstants.keyUser);
      if (userJson == null) {
        return const Right(null);
      }

      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      final user = UserModel.fromJson(userMap);

      return Right(user);
    } catch (e) {
      return Left(CacheFailure('Imeshindwa kupata taarifa za mtumiaji: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveTokens(
    String accessToken,
    String refreshToken,
  ) async {
    try {
      await tokenManager.storeTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Imeshindwa kuhifadhi tokeni: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearUser() async {
    try {
      await Future.wait([
        sharedPreferences.remove(AppConstants.keyUser),
        sharedPreferences.remove(AppConstants.keyUserId),
        sharedPreferences.remove(AppConstants.keyUserEmail),
        sharedPreferences.setBool(AppConstants.keyIsLoggedIn, false),
        sharedPreferences.remove(AppConstants.keyActiveModule),
      ]);
      await tokenManager.clearTokens();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Imeshindwa kufuta taarifa za mtumiaji: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> setActiveModule(int moduleId) async {
    try {
      await sharedPreferences.setInt(AppConstants.keyActiveModule, moduleId);
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure('Imeshindwa kuhifadhi moduli iliyochaguliwa: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, String?>> getActiveModule() async {
    try {
      final moduleId = sharedPreferences.getInt(AppConstants.keyActiveModule);
      return Right(moduleId?.toString());
    } catch (e) {
      return Left(CacheFailure('Imeshindwa kupata moduli iliyochaguliwa: $e'));
    }
  }
}
