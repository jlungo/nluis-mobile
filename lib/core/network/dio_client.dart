import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../env/env.dart';
import '../utils/logger.dart';
import '../../features/auth/data/datasources/token_manager.dart';
import 'network_info.dart';

class DioClient {
  late final Dio _dio;
  final FlutterSecureStorage secureStorage;
  final NetworkInfo networkInfo;
  final SharedPreferences sharedPreferences;
  late final TokenManager tokenManager;
  final Future<void> Function()? onTokenRefreshFailedWhileOnline;

  DioClient({
    required this.secureStorage,
    required this.networkInfo,
    required this.sharedPreferences,
    this.onTokenRefreshFailedWhileOnline,
  }) {
    tokenManager = TokenManager(sharedPreferences);
    _dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: Duration(milliseconds: Env.connectionTimeout),
        receiveTimeout: Duration(milliseconds: Env.receiveTimeout),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Get current token
          final token = await tokenManager.getAccessToken();

          // Check if we need authentication (skip for auth endpoints)
          final isAuthEndpoint = options.path.contains('/auth/');

          if (!isAuthEndpoint) {
            // Check if token exists and is valid
            final isExpired = await tokenManager.isTokenExpired();
            final isExpiringSoon = await tokenManager.isTokenExpiringSoon();

            // If no token or expired, try to refresh
            if (token == null || isExpired || isExpiringSoon) {
              AppLogger.info(
                'Token missing/expired/expiring soon, attempting refresh...',
              );
              final refreshed = await _refreshToken();

              if (!refreshed) {
                // Token refresh failed
                final isOnline = await networkInfo.isConnected;
                if (isOnline && onTokenRefreshFailedWhileOnline != null) {
                  AppLogger.warning(
                    'No valid token and refresh failed. Redirecting to login...',
                  );
                  onTokenRefreshFailedWhileOnline!();
                }
              }
            }
          }

          // Add auth token to requests if available
          final updatedToken = await tokenManager.getAccessToken();
          if (updatedToken != null && updatedToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $updatedToken';
          }

          AppLogger.debug(
            'REQUEST[${options.method}] => PATH: ${options.path}',
          );
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

          // Handle 401 Unauthorized - redirect to login
          if (error.response?.statusCode == 401) {
            final isOnline = await networkInfo.isConnected;

            if (isOnline) {
              // Try to refresh token once
              final refreshed = await _refreshToken();

              if (refreshed) {
                // Token refreshed successfully, retry the original request
                final options = error.requestOptions;
                final token = await tokenManager.getAccessToken();

                if (token != null) {
                  options.headers['Authorization'] = 'Bearer $token';

                  try {
                    final response = await _dio.fetch(options);
                    return handler.resolve(response);
                  } catch (e) {
                    // Retry failed - trigger logout
                    AppLogger.warning(
                      'Request retry failed after token refresh. Logging out...',
                    );
                    if (onTokenRefreshFailedWhileOnline != null) {
                      onTokenRefreshFailedWhileOnline!();
                    }
                    return handler.reject(error);
                  }
                }
              }

              // Token refresh failed or no token - trigger logout
              AppLogger.warning('Unauthorized (401). Redirecting to login...');
              if (onTokenRefreshFailedWhileOnline != null) {
                onTokenRefreshFailedWhileOnline!();
              }
            } else {
              // Offline - allow user to continue
              AppLogger.info(
                'Unauthorized while offline. User can continue offline.',
              );
            }
          }

          return handler.next(error);
        },
      ),
    );

    // Logging interceptor (debug only)
    _dio.interceptors.add(
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
      final refreshToken = await tokenManager.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        AppLogger.warning('No refresh token available');
        return false;
      }

      final response = await Dio(
        BaseOptions(baseUrl: Env.baseUrl),
      ).post('/auth/refresh/', data: {'refresh': refreshToken});

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access'] as String;

        // Update access token (expiration is read from JWT)
        await tokenManager.updateAccessToken(accessToken: newAccessToken);

        AppLogger.info('Token refreshed successfully');
        return true;
      }

      AppLogger.warning(
        'Token refresh failed with status: ${response.statusCode}',
      );
      return false;
    } catch (e) {
      AppLogger.error('Token refresh failed', e);
      return false;
    }
  }
}
