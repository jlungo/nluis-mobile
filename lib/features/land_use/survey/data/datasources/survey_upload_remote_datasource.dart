import 'package:dartz/dartz.dart';
import 'dart:convert';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../../../core/database/app_database.dart';
import '../../../../../core/services/file_upload_service.dart';

abstract class SurveyUploadRemoteDataSource {
  Future<Either<Failure, void>> uploadSurveyData(
    String surveyId,
    List<SurveyResponse> responses,
  );
}

class SurveyUploadRemoteDataSourceImpl implements SurveyUploadRemoteDataSource {
  final DioClient dioClient;
  final FileUploadService fileUploadService;

  const SurveyUploadRemoteDataSourceImpl(
    this.dioClient,
    this.fileUploadService,
  );

  @override
  Future<Either<Failure, void>> uploadSurveyData(
    String surveyId,
    List<SurveyResponse> responses,
  ) async {
    try {
      if (responses.isEmpty) {
        return const Left(ServerFailure('Hakuna data ya kupakia'));
      }

      final firstResponse = responses.first;
      final projectId = firstResponse.projectId;
      final questionnaireId = firstResponse.questionnaireId;

      // Extract file paths from responses
      final filesByField = <String, List<String>>{};
      final formResponses = <Map<String, dynamic>>[];

      for (final response in responses) {
        final answersData =
            response.answersJson.isNotEmpty
                ? jsonDecode(response.answersJson) as Map<String, dynamic>
                : <String, dynamic>{};

        // Extract file/image fields
        final cleanedAnswers = <String, dynamic>{};
        answersData.forEach((key, value) {
          if (value is String &&
              (value.startsWith('/') || value.contains('file://'))) {
            // This is likely a file path
            filesByField.putIfAbsent(key, () => []).add(value);
            cleanedAnswers[key] = 'UPLOADED'; // Placeholder
          } else {
            cleanedAnswers[key] = value;
          }
        });

        formResponses.add({
          'form_slug': response.formSlug,
          'answers': cleanedAnswers,
        });
      }

      // Upload files first if any
      Map<String, List<Map<String, dynamic>>> uploadedFiles = {};
      if (filesByField.isNotEmpty) {
        for (final entry in filesByField.entries) {
          try {
            final uploaded = await fileUploadService.uploadMultipleFiles(
              filePaths: entry.value,
              fieldName: entry.key,
              surveyId: surveyId,
            );
            if (uploaded.isNotEmpty) {
              uploadedFiles[entry.key] = uploaded;
            }
          } catch (e) {
            // Continue even if file upload fails
          }
        }
      }

      final payload = {
        'survey_id': surveyId,
        'project_id': projectId,
        'questionnaire_id': questionnaireId,
        'forms': formResponses,
        if (uploadedFiles.isNotEmpty) 'uploaded_files': uploadedFiles,
      };

      final response = await dioClient.post(
        '/collect/surveys/submit/',
        data: payload,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(null);
      }

      if (response.statusCode == 401) {
        return const Left(
          AuthFailure('Haujathibitishwa. Tafadhali ingia tena.'),
        );
      }

      if (response.statusCode == 400) {
        final message = response.data?['message'] ?? 'Data si sahihi';
        return Left(ServerFailure(message));
      }

      return Left(
        ServerFailure('Imeshindikana kupakia dodoso: ${response.statusCode}'),
      );
    } catch (e) {
      return Left(ServerFailure('Hitilafu ya kupakia: ${e.toString()}'));
    }
  }
}
