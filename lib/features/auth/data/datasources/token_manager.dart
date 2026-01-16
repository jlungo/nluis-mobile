import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../../shared/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';

class TokenManager {
  final SharedPreferences _prefs;

  const TokenManager(this._prefs);

  Future<void> storeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      await Future.wait([
        _prefs.setString(AppConstants.keyAccessToken, accessToken),
        _prefs.setString(AppConstants.keyRefreshToken, refreshToken),
      ]);
    } catch (e) {
      throw CacheException('Failed to store tokens: $e');
    }
  }

  Future<String?> getAccessToken() async {
    try {
      final token = _prefs.getString(AppConstants.keyAccessToken);
      
      if (token == null || token.isEmpty) {
        return null;
      }

      if (JwtDecoder.isExpired(token)) {
        return null;
      }

      return token;
    } catch (e) {
      throw CacheException('Failed to get access token: $e');
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      return _prefs.getString(AppConstants.keyRefreshToken);
    } catch (e) {
      throw CacheException('Failed to get refresh token: $e');
    }
  }

  Future<bool> isTokenExpired() async {
    try {
      final token = _prefs.getString(AppConstants.keyAccessToken);
      
      if (token == null || token.isEmpty) {
        return true;
      }

      return JwtDecoder.isExpired(token);
    } catch (e) {
      return true;
    }
  }

  Future<bool> isTokenExpiringSoon() async {
    try {
      final token = _prefs.getString(AppConstants.keyAccessToken);
      
      if (token == null || token.isEmpty) {
        return true;
      }

      final expirationDate = JwtDecoder.getExpirationDate(token);
      final now = DateTime.now();
      final fiveMinutesFromNow = now.add(const Duration(minutes: 5));

      return expirationDate.isBefore(fiveMinutesFromNow);
    } catch (e) {
      return true;
    }
  }

  Future<Duration?> getTimeUntilExpiration() async {
    try {
      final token = _prefs.getString(AppConstants.keyAccessToken);
      
      if (token == null || token.isEmpty) {
        return null;
      }

      if (JwtDecoder.isExpired(token)) {
        return null;
      }

      final expirationDate = JwtDecoder.getExpirationDate(token);
      final now = DateTime.now();
      
      return expirationDate.difference(now);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearTokens() async {
    try {
      await Future.wait([
        _prefs.remove(AppConstants.keyAccessToken),
        _prefs.remove(AppConstants.keyRefreshToken),
      ]);
    } catch (e) {
      throw CacheException('Failed to clear tokens: $e');
    }
  }

  Future<void> updateAccessToken({
    required String accessToken,
  }) async {
    try {
      await _prefs.setString(AppConstants.keyAccessToken, accessToken);
    } catch (e) {
      throw CacheException('Failed to update access token: $e');
    }
  }
}
