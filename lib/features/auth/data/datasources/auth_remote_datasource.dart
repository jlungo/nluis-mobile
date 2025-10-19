import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, AuthResponseModel>> login(String email, String password);
  Future<Either<Failure, String>> refreshToken(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  const AuthRemoteDataSourceImpl(this.dioClient);

  @override
  Future<Either<Failure, AuthResponseModel>> login(String email, String password) async {
    try {
      final response = await dioClient.post(
        '/auth/login/',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // Validate user_type before parsing full response
        final userType = response.data['user_type'] as int?;
        if (userType != 5) {
          return const Left(AuthFailure('Hauruhusiwi kutumia programu ya simu. Wasiliana na msimamizi.'));
        }

        return Right(AuthResponseModel.fromJson(response.data));
      } else {
        return Left(ServerFailure('Tatizo la kuingia: ${response.statusMessage}'));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final errorDetail = e.response?.data?['detail'];
        return Left(AuthFailure(errorDetail ?? 'Barua pepe au neno la siri sio sahihi'));
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return const Left(NetworkFailure('Muda wa kusubiri umeisha. Angalia muunganisho wa mtandao.'));
      }
      if (e.type == DioExceptionType.connectionError) {
        return const Left(NetworkFailure('Hakuna muunganisho wa mtandao.'));
      }
      return Left(ServerFailure('Tatizo la seva: ${e.message}'));
    } catch (e) {
      return Left(ServerFailure('Tatizo lisilo tarajiwa: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> refreshToken(String refreshToken) async {
    try {
      final response = await dioClient.post(
        '/auth/refresh/',
        data: {
          'refresh': refreshToken,
        },
      );

      if (response.statusCode == 200) {
        return Right(response.data['access'] as String);
      } else {
        return Left(ServerFailure('Imeshindwa kuonyesha tokeni: ${response.statusMessage}'));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return const Left(AuthFailure('Tokeni imeisha muda. Tafadhali ingia tena.'));
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return const Left(NetworkFailure('Muda wa kusubiri umeisha. Angalia muunganisho wa mtandao.'));
      }
      if (e.type == DioExceptionType.connectionError) {
        return const Left(NetworkFailure('Hakuna muunganisho wa mtandao.'));
      }
      return Left(ServerFailure('Tatizo la seva: ${e.message}'));
    } catch (e) {
      return Left(ServerFailure('Tatizo lisilo tarajiwa: $e'));
    }
  }
}
