import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../../../shared/models/questionnaire.dart';

abstract class QuestionnaireDetailRemoteDataSource {
  Future<Either<Failure, QuestionnaireDetail>> getQuestionnaireDetail(
    String slug,
  );
}

class QuestionnaireDetailRemoteDataSourceImpl
    implements QuestionnaireDetailRemoteDataSource {
  final DioClient dioClient;

  const QuestionnaireDetailRemoteDataSourceImpl(this.dioClient);

  @override
  Future<Either<Failure, QuestionnaireDetail>> getQuestionnaireDetail(
    String slug,
  ) async {
    try {
      final response = await dioClient.get(
        '/collect/questionnaire/$slug/detail/',
      );

      if (response.statusCode == 200) {
        final detail = QuestionnaireDetailModel.fromJson(response.data);
        return Right(detail);
      }

      if (response.statusCode == 404) {
        return const Left(ServerFailure('Dodoso halipatikani'));
      }

      if (response.statusCode == 401) {
        return const Left(
          AuthFailure('Haujathibitishwa. Tafadhali ingia tena.'),
        );
      }

      return const Left(
        ServerFailure('Imeshindikana kupakia dodoso kutoka seva.'),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return const Left(
          AuthFailure('Haujathibitishwa. Tafadhali ingia tena.'),
        );
      }
      if (e.response?.statusCode == 404) {
        return const Left(ServerFailure('Dodoso halipatikani'));
      }
      return Left(ServerFailure('Hitilafu ya mtandao: ${e.message}'));
    } catch (e) {
      return Left(ServerFailure('Hitilafu: $e'));
    }
  }
}
