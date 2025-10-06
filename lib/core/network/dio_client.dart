import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../env/env.dart';
import '../utils/logger.dart';
import '../../shared/constants/app_constants.dart';

class DioClient {
  late final Dio dio;
  final FlutterSecureStorage secureStorage;

  DioClient({required this.secureStorage}) {
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
