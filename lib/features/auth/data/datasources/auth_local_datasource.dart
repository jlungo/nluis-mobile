import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../shared/constants/app_constants.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheTokens(String accessToken, String refreshToken);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearAuthData();
  Future<void> setActiveModule(int moduleId);
  Future<String?> getActiveModule();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  const AuthLocalDataSourceImpl({
    required this.secureStorage,
    required this.sharedPreferences,
  });

  @override
  Future<void> cacheTokens(String accessToken, String refreshToken) async {
    try {
      await Future.wait([
        secureStorage.write(
          key: AppConstants.keyAccessToken,
          value: accessToken,
        ),
        secureStorage.write(
          key: AppConstants.keyRefreshToken,
          value: refreshToken,
        ),
      ]);
    } catch (e) {
      throw CacheException('Failed to cache tokens: $e');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return await secureStorage.read(key: AppConstants.keyAccessToken);
    } catch (e) {
      throw CacheException('Failed to get access token: $e');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await secureStorage.read(key: AppConstants.keyRefreshToken);
    } catch (e) {
      throw CacheException('Failed to get refresh token: $e');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await sharedPreferences.setString(
        AppConstants.keyUser,
        user.toJsonString(),
      );
    } catch (e) {
      throw CacheException('Failed to cache user: $e');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = sharedPreferences.getString(AppConstants.keyUser);
      if (userJson == null) return null;
      return UserModel.fromJsonString(userJson);
    } catch (e) {
      throw CacheException('Failed to get cached user: $e');
    }
  }

  @override
  Future<void> clearAuthData() async {
    try {
      await Future.wait([
        secureStorage.delete(key: AppConstants.keyAccessToken),
        secureStorage.delete(key: AppConstants.keyRefreshToken),
        sharedPreferences.remove(AppConstants.keyUser),
        sharedPreferences.remove(AppConstants.keyActiveModule),
      ]);
    } catch (e) {
      throw CacheException('Failed to clear auth data: $e');
    }
  }

  @override
  Future<void> setActiveModule(int moduleId) async {
    try {
      await sharedPreferences.setString(
        AppConstants.keyActiveModule,
        moduleId as String,
      );
    } catch (e) {
      throw CacheException('Failed to set active module: $e');
    }
  }

  @override
  Future<String?> getActiveModule() async {
    try {
      return sharedPreferences.getString(AppConstants.keyActiveModule);
    } catch (e) {
      throw CacheException('Failed to get active module: $e');
    }
  }
}
