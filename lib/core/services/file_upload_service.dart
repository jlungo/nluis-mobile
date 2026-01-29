import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import '../network/dio_client.dart';

class FileUploadService {
  final DioClient dioClient;

  const FileUploadService(this.dioClient);

  /// Upload a single file to the server
  Future<Map<String, dynamic>?> uploadFile({
    required String filePath,
    required String fieldName,
    String? surveyId,
    String? formSlug,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File does not exist: $filePath');
      }

      final fileName = path.basename(filePath);
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath, filename: fileName),
        if (surveyId != null) 'survey_id': surveyId,
        if (formSlug != null) 'form_slug': formSlug,
      });

      final response = await dioClient.post(
        '/collect/upload/file/',
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>?;
      }

      return null;
    } catch (e) {
      throw Exception('Failed to upload file: ${e.toString()}');
    }
  }

  /// Upload multiple files
  Future<List<Map<String, dynamic>>> uploadMultipleFiles({
    required List<String> filePaths,
    required String fieldName,
    String? surveyId,
    String? formSlug,
  }) async {
    final uploadedFiles = <Map<String, dynamic>>[];

    for (final filePath in filePaths) {
      try {
        final result = await uploadFile(
          filePath: filePath,
          fieldName: fieldName,
          surveyId: surveyId,
          formSlug: formSlug,
        );
        if (result != null) {
          uploadedFiles.add(result);
        }
      } catch (e) {
        // Continue with other files even if one fails
        continue;
      }
    }

    return uploadedFiles;
  }

  /// Upload survey with all its files
  Future<Map<String, dynamic>> uploadSurveyWithFiles({
    required String surveyId,
    required Map<String, dynamic> surveyData,
    required Map<String, List<String>> filesByField,
  }) async {
    try {
      // First upload all files
      final uploadedFilesByField = <String, List<Map<String, dynamic>>>{};

      for (final entry in filesByField.entries) {
        final fieldName = entry.key;
        final filePaths = entry.value;

        final uploadedFiles = await uploadMultipleFiles(
          filePaths: filePaths,
          fieldName: fieldName,
          surveyId: surveyId,
        );

        if (uploadedFiles.isNotEmpty) {
          uploadedFilesByField[fieldName] = uploadedFiles;
        }
      }

      // Then upload survey data with file references
      final enhancedSurveyData = Map<String, dynamic>.from(surveyData);
      enhancedSurveyData['uploaded_files'] = uploadedFilesByField;

      final response = await dioClient.post(
        '/collect/surveys/submit/',
        data: enhancedSurveyData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'survey_id': surveyId,
          'uploaded_files': uploadedFilesByField,
        };
      }

      return {'success': false, 'error': 'Failed to submit survey'};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}
