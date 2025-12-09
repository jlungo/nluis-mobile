import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../../shared/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';

/// Token manager for handling token storage, expiration, and validation using JWT
/// 
/// This class provides:
/// - JWT-based token expiration checking
/// - Proactive token expiration checking
/// - Automatic token cleanup
/// - SharedPreferences storage
class TokenManager {
  final SharedPreferences _prefs;

  const TokenManager(this._prefs);

  /// Store tokens (both expire after 1 day as per JWT)
  /// 
  /// [accessToken] - JWT access token
  /// [refreshToken] - JWT refresh token
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

  /// Get access token if it's still valid
  /// 
  /// Returns null if token is expired or doesn't exist
  Future<String?> getAccessToken() async {
    try {
      final token = _prefs.getString(AppConstants.keyAccessToken);
      
      if (token == null || token.isEmpty) {
        return null;
      }

      // Check if token is expired using jwt_decoder
      if (JwtDecoder.isExpired(token)) {
        return null;
      }

      return token;
    } catch (e) {
      throw CacheException('Failed to get access token: $e');
    }
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    try {
      return _prefs.getString(AppConstants.keyRefreshToken);
    } catch (e) {
      throw CacheException('Failed to get refresh token: $e');
    }
  }

  /// Check if the current token is expired using JWT decoder
  /// 
  /// Returns true if:
  /// - Token doesn't exist
  /// - Token is invalid
  /// - Token is expired
  Future<bool> isTokenExpired() async {
    try {
      final token = _prefs.getString(AppConstants.keyAccessToken);
      
      if (token == null || token.isEmpty) {
        return true;
      }

      return JwtDecoder.isExpired(token);
    } catch (e) {
      // If we can't determine expiration, consider it expired for safety
      return true;
    }
  }

  /// Check if token will expire soon (within next 5 minutes)
  /// 
  /// Useful for proactive token refresh
  Future<bool> isTokenExpiringSoon() async {
    try {
      final token = _prefs.getString(AppConstants.keyAccessToken);
      
      if (token == null || token.isEmpty) {
        return true;
      }

      // Get expiration date from JWT
      final expirationDate = JwtDecoder.getExpirationDate(token);
      final now = DateTime.now();
      final fiveMinutesFromNow = now.add(const Duration(minutes: 5));

      return expirationDate.isBefore(fiveMinutesFromNow);
    } catch (e) {
      return true;
    }
  }

  /// Get time remaining until token expiration
  /// 
  /// Returns Duration or null if token is already expired or doesn't exist
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

  /// Clear all stored tokens
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

  /// Update only the access token (used after refresh)
  /// 
  /// [accessToken] - New JWT access token (expiration is read from JWT)
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
