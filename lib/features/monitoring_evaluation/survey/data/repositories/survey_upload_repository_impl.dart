import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../../../../core/database/app_database.dart';
import '../../domain/repositories/survey_upload_repository.dart';
import '../datasources/survey_upload_remote_datasource.dart';
import 'package:drift/drift.dart' as drift;

class SurveyUploadRepositoryImpl implements SurveyUploadRepository {
  final SurveyUploadRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final AppDatabase database;

  const SurveyUploadRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.database,
  });

  @override
  Future<Either<Failure, void>> uploadSurvey(String surveyId) async {
    final isOnline = await networkInfo.isConnected;

    if (!isOnline) {
      return const Left(
        NetworkFailure(
          'Hakuna mtandao. Tafadhali washa mtandao na ujaribu tena.',
        ),
      );
    }

    try {
      // Get all responses for this survey
      final responses =
          await (database.select(database.surveyResponses)
            ..where((tbl) => tbl.surveyId.equals(surveyId))).get();

      if (responses.isEmpty) {
        return const Left(ServerFailure('Dodoso halipatikani'));
      }

      // Upload to server
      final result = await remoteDataSource.uploadSurveyData(
        surveyId,
        responses,
      );

      return result.fold((failure) => Left(failure), (_) async {
        // Mark as uploaded (not dirty anymore)
        await (database.update(database.surveyResponses)
          ..where((tbl) => tbl.surveyId.equals(surveyId))).write(
          const SurveyResponsesCompanion(
            dirty: drift.Value(false),
            uploadStatus: drift.Value(2), // success
          ),
        );
        return const Right(null);
      });
    } catch (e) {
      // Mark as failed
      await (database.update(database.surveyResponses)
        ..where((tbl) => tbl.surveyId.equals(surveyId))).write(
        const SurveyResponsesCompanion(
          uploadStatus: drift.Value(3), // failure
        ),
      );
      return Left(ServerFailure('Hitilafu: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> uploadMultipleSurveys(
    List<String> surveyIds,
  ) async {
    final isOnline = await networkInfo.isConnected;

    if (!isOnline) {
      return const Left(
        NetworkFailure(
          'Hakuna mtandao. Tafadhali washa mtandao na ujaribu tena.',
        ),
      );
    }

    int successCount = 0;
    int failureCount = 0;
    String? lastError;

    for (final surveyId in surveyIds) {
      final result = await uploadSurvey(surveyId);
      result.fold((failure) {
        failureCount++;
        lastError = failure.toString();
      }, (_) => successCount++);
    }

    if (failureCount == 0) {
      return const Right(null);
    } else if (successCount == 0) {
      return Left(
        ServerFailure(lastError ?? 'Imeshindikana kupakia dodoso zote'),
      );
    } else {
      return Left(
        ServerFailure('$successCount zimepakiwa, $failureCount zimeshindikana'),
      );
    }
  }
}
