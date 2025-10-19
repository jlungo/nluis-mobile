import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../env/env.dart';
import '../utils/logger.dart';
import '../../shared/constants/app_constants.dart';
import 'network_info.dart';

class DioClient {
  late final Dio dio;
  final FlutterSecureStorage secureStorage;
  final NetworkInfo networkInfo;
  final Future<void> Function()? onTokenRefreshFailedWhileOnline;

  DioClient({
    required this.secureStorage,
    required this.networkInfo,
    this.onTokenRefreshFailedWhileOnline,
  }) {
    dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: Duration(milliseconds: Env.connectionTimeout),
        receiveTimeout: Duration(milliseconds: Env.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token to requests
          final token = await secureStorage.read(
            key: AppConstants.keyAccessToken,
          );

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          AppLogger.debug('REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.debug(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (error, handler) async {
          AppLogger.error(
            'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
            error,
          );

          // Handle token refresh on 401
          if (error.response?.statusCode == 401) {
            final refreshed = await _refreshToken();
            if (refreshed) {
              // Retry the original request
              final options = error.requestOptions;
              final token = await secureStorage.read(
                key: AppConstants.keyAccessToken,
              );
              options.headers['Authorization'] = 'Bearer $token';

              try {
                final response = await dio.fetch(options);
                return handler.resolve(response);
              } catch (e) {
                return handler.reject(error);
              }
            } else {
              // Token refresh failed - check if we're online
              final isOnline = await networkInfo.isConnected;

              if (isOnline) {
                // User is online but refresh failed (refresh token expired/invalid)
                // Trigger automatic logout
                AppLogger.warning(
                  'Token refresh failed while online. Logging out user...',
                );

                if (onTokenRefreshFailedWhileOnline != null) {
                  // Call the logout callback asynchronously
                  // Don't await to prevent blocking the error handler
                  onTokenRefreshFailedWhileOnline!();
                }
              } else {
                // User is offline - don't logout, they may be working offline
                AppLogger.info(
                  'Token refresh failed while offline. User can continue working offline.',
                );
              }
            }
          }

          return handler.next(error);
        },
      ),
    );

    // Logging interceptor (debug only)
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        logPrint: (obj) => AppLogger.debug(obj),
      ),
    );
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await secureStorage.read(
        key: AppConstants.keyRefreshToken,
      );

      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      final response = await Dio(BaseOptions(baseUrl: Env.baseUrl)).post(
        '/auth/refresh/',
        data: {'refresh': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access'] as String;
        await secureStorage.write(
          key: AppConstants.keyAccessToken,
          value: newAccessToken,
        );
        return true;
      }

      return false;
    } catch (e) {
      AppLogger.error('Token refresh failed', e);
      return false;
    }
  }
}
