import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../../../shared/models/questionnaire.dart';

abstract class QuestionnaireRemoteDataSource {
  Future<Either<Failure, List<Questionnaire>>> getQuestionnaires({
    String? keyword,
    required String module,
    String? category,
  });
}

class QuestionnaireRemoteDataSourceImpl
    implements QuestionnaireRemoteDataSource {
  final DioClient dioClient;

  const QuestionnaireRemoteDataSourceImpl(this.dioClient);

  @override
  Future<Either<Failure, List<Questionnaire>>> getQuestionnaires({
    String? keyword,
    required String module,
    String? category,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (keyword != null && keyword.isNotEmpty) {
        queryParameters['keyword'] = keyword;
      }
      if (module.isNotEmpty) {
        queryParameters['module'] = module;
      }
      if (category != null && category.isNotEmpty) {
        queryParameters['category'] = category;
      }

      final response = await dioClient.get(
        '/collect/questionnaire/list/',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'] ?? response.data;
        final questionnaires =
            data
                .map(
                  (json) =>
                      QuestionnaireModel.fromJson(json as Map<String, dynamic>),
                )
                .toList();

        return Right(questionnaires);
      }

      if (response.statusCode == 401) {
        return const Left(
          AuthFailure('Haujathibitishwa. Tafadhali ingia tena.'),
        );
      }

      return const Left(
        ServerFailure('Imeshindikana kupakia madodoso kutoka seva.'),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return const Left(
          AuthFailure('Haujathibitishwa. Tafadhali ingia tena.'),
        );
      }
      return Left(ServerFailure('Hitilafu ya mtandao: ${e.message}'));
    } catch (e) {
      return Left(ServerFailure('Hitilafu: $e'));
    }
  }
}
