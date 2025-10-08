import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../core/error/failures.dart';
import '../../core/env/env.dart';
import '../../shared/models/questionnaire.dart';

abstract class QuestionnaireRepository {
  Future<Either<Failure, List<Questionnaire>>> getQuestionnaireList({
    String? keyword,
    String? module,
    String? category,
  });

  Future<Either<Failure, QuestionnaireDetail>> getQuestionnaireDetail(String slug);
}

class QuestionnaireRepositoryImpl implements QuestionnaireRepository {
  final Dio dio;

  const QuestionnaireRepositoryImpl(this.dio);

  @override
  Future<Either<Failure, List<Questionnaire>>> getQuestionnaireList({
    String? keyword,
    String? module,
    String? category,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (keyword != null && keyword.isNotEmpty) queryParameters['keyword'] = keyword;
      if (module != null && module.isNotEmpty) queryParameters['module'] = module;
      if (category != null && category.isNotEmpty) queryParameters['category'] = category;

      final response = await dio.get(
        '${Env.baseUrl}/collect/questionnaire/list/',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'] ?? response.data;
        final questionnaires = data
            .map((json) => QuestionnaireModel.fromJson(json as Map<String, dynamic>))
            .toList();
        return Right(questionnaires);
      } else {
        return Left(ServerFailure('Failed to fetch questionnaires'));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return const Left(AuthFailure('Unauthorized'));
      }
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, QuestionnaireDetail>> getQuestionnaireDetail(String slug) async {
    try {
      final response = await dio.get(
        '${Env.baseUrl}/collect/questionnaire/$slug',
      );

      if (response.statusCode == 200) {
        final questionnaireDetail = QuestionnaireDetailModel.fromJson(response.data);
        return Right(questionnaireDetail);
      } else {
        return Left(ServerFailure('Failed to fetch questionnaire detail'));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return const Left(ServerFailure('Questionnaire not found'));
      }
      if (e.response?.statusCode == 401) {
        return const Left(AuthFailure('Unauthorized'));
      }
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}
