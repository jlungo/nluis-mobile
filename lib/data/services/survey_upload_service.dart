import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import '../../core/network/dio_client.dart';
import '../local/database.dart';
import '../local/tables/survey_tables.dart';

/// Service for handling questionnaire uploads with deduplication,
/// retry safety, and progress tracking.
class SurveyUploadService {
  final AppDatabase database;
  final DioClient dioClient;

  SurveyUploadService({
    required this.database,
    required this.dioClient,
  });

  /// Get all responses that are not uploaded (pending, uploading, or failed)
  Future<List<SurveyResponse>> getPendingResponses({
    String? moduleSlug,
    String? projectId,
  }) async {
    var query = database.select(database.surveyResponses)
      ..where((tbl) => tbl.uploadStatus.isNotIn([UploadStatusConverter.uploaded]));

    if (moduleSlug != null) {
      query = query..where((tbl) => tbl.moduleSlug.equals(moduleSlug));
    }
    if (projectId != null) {
      query = query..where((tbl) => tbl.projectId.equals(projectId));
    }

    return query.get();
  }

  /// Get responses for a specific survey
  Future<List<SurveyResponse>> getResponsesForSurvey(String surveyId) async {
    return (database.select(database.surveyResponses)
          ..where((tbl) => tbl.surveyId.equals(surveyId)))
        .get();
  }

  /// Mark responses as uploading
  Future<void> markUploading(List<SurveyResponse> responses) async {
    final ids = responses.map((r) => r.id).toList();
    await (database.update(database.surveyResponses)
          ..where((tbl) => tbl.id.isIn(ids)))
        .write(
      SurveyResponsesCompanion(
        uploadStatus: const Value(UploadStatusConverter.uploading),
        uploadProgress: const Value(0.0),
      ),
    );
  }

  /// Mark responses as uploaded
  Future<void> markUploaded(List<SurveyResponse> responses) async {
    final ids = responses.map((r) => r.id).toList();
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await (database.update(database.surveyResponses)
          ..where((tbl) => tbl.id.isIn(ids)))
        .write(
      SurveyResponsesCompanion(
        uploadStatus: const Value(UploadStatusConverter.uploaded),
        uploadProgress: const Value(1.0),
        isDraft: const Value(false),
        dirty: const Value(false),
        updatedAt: Value(now),
      ),
    );
  }

  /// Mark responses as failed
  Future<void> markFailed(List<SurveyResponse> responses) async {
    final ids = responses.map((r) => r.id).toList();
    await (database.update(database.surveyResponses)
          ..where((tbl) => tbl.id.isIn(ids)))
        .write(
      const SurveyResponsesCompanion(
        uploadStatus: Value(UploadStatusConverter.failed),
      ),
    );
  }

  /// Mark responses as pending (for retry)
  Future<void> markPending(List<SurveyResponse> responses) async {
    final ids = responses.map((r) => r.id).toList();
    await (database.update(database.surveyResponses)
          ..where((tbl) => tbl.id.isIn(ids)))
        .write(
      const SurveyResponsesCompanion(
        uploadStatus: Value(UploadStatusConverter.pending),
        uploadProgress: Value(0.0),
      ),
    );
  }

  /// Update upload progress for responses
  Future<void> updateProgress(List<SurveyResponse> responses, double progress) async {
    final ids = responses.map((r) => r.id).toList();
    await (database.update(database.surveyResponses)
          ..where((tbl) => tbl.id.isIn(ids)))
        .write(
      SurveyResponsesCompanion(
        uploadProgress: Value(progress),
      ),
    );
  }

  /// Get field types for a form (cached)
  Future<Map<String, String>> getFieldTypes(String formSlug) async {
    final fields = await (database.select(database.formFields)
          ..where((tbl) => tbl.formSlug.equals(formSlug)))
        .get();

    return {
      for (final field in fields) field.id.toString(): field.type.toLowerCase(),
    };
  }

  /// Decode answers JSON string to Map
  Map<String, dynamic> decodeAnswers(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {}
    return {};
  }

  /// Build FormData for upload
  Future<FormData> buildFormData({
    required String questionnaireSlug,
    required String formSlug,
    required String projectLocalityId,
    required Map<String, dynamic> answers,
    required Map<String, String> fieldTypes,
  }) async {
    final formData = FormData();

    formData.fields.add(MapEntry('project_locality_id', projectLocalityId));
    formData.fields.add(MapEntry('form_slug', formSlug));
    formData.fields.add(MapEntry('questionnaire_slug', questionnaireSlug));

    for (final entry in answers.entries) {
      final fieldId = entry.key;
      final value = entry.value;
      final fieldType = fieldTypes[fieldId]?.toLowerCase() ?? '';
      final dataKey = 'data-$fieldId';

      if (value == null) {
        continue;
      }

      if (fieldType == 'file') {
        final filePath = value is List
            ? _extractFilePathFromList(value)
            : _extractFilePath(value);

        if (filePath == null) {
          continue;
        }

        final file = File(filePath);
        if (!await file.exists()) {
          continue;
        }

        formData.files.add(
          MapEntry(
            dataKey,
            await MultipartFile.fromFile(
              file.path,
              filename: p.basename(file.path),
            ),
          ),
        );
        formData.fields.add(MapEntry(fieldId, projectLocalityId));
      } else {
        final serialized = _serializeForUpload(value);
        if (serialized == null) {
          continue;
        }
        formData.fields.add(MapEntry(dataKey, serialized));
        formData.fields.add(MapEntry(fieldId, projectLocalityId));
      }
    }

    return formData;
  }

  String? _extractFilePathFromList(List<dynamic> values) {
    for (final item in values) {
      final path = _extractFilePath(item);
      if (path != null && path.isNotEmpty) {
        return path;
      }
    }
    return null;
  }

  String? _extractFilePath(dynamic value) {
    if (value == null) return null;
    if (value is String && value.isNotEmpty) {
      return _sanitizeFilePath(value);
    }
    if (value is File) {
      return value.path;
    }
    if (value is Map) {
      for (final key in ['path', 'filePath', 'filepath', 'value', 'url']) {
        final candidate = value[key];
        if (candidate is String && candidate.isNotEmpty) {
          return _sanitizeFilePath(candidate);
        }
      }
    }
    return null;
  }

  String? _sanitizeFilePath(String path) {
    if (path.isEmpty) return null;
    if (path.startsWith('http')) return null;
    return path.startsWith('file://') ? path.replaceFirst('file://', '') : path;
  }

  String? _serializeForUpload(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is num) return value.toString();
    if (value is bool) return value ? 'true' : 'false';
    if (value is List || value is Map) return jsonEncode(value);
    return value.toString();
  }

  /// Upload all pending questionnaires for a module/project
  /// Groups responses by questionnaireSlug and uploads ONE request per questionnaire
  Future<UploadResult> uploadPendingQuestionnaires({
    String? moduleSlug,
    String? projectId,
    void Function(String questionnaireSlug, double progress)? onProgress,
    void Function(String questionnaireSlug, String status)? onStatusChange,
  }) async {
    final responses = await getPendingResponses(
      moduleSlug: moduleSlug,
      projectId: projectId,
    );

    if (responses.isEmpty) {
      return UploadResult(successCount: 0, failureCount: 0, failures: {});
    }

    // Group by questionnaireSlug
    final grouped = <String, List<SurveyResponse>>{};
    for (final r in responses) {
      final slug = r.questionnaireSlug;
      if (slug == null || slug.isEmpty) continue;
      if (r.formSlug == null || r.formSlug!.isEmpty) continue;
      grouped.putIfAbsent(slug, () => []).add(r);
    }

    int successCount = 0;
    int failureCount = 0;
    final failures = <String, String>{};

    for (final entry in grouped.entries) {
      final questionnaireSlug = entry.key;
      final group = entry.value;

      // Skip if already uploaded
      if (group.every((r) => r.uploadStatus == UploadStatusConverter.uploaded)) {
        continue;
      }

      // Skip if any is currently uploading (prevent duplicate uploads)
      if (group.any((r) => r.uploadStatus == UploadStatusConverter.uploading)) {
        continue;
      }

      onStatusChange?.call(questionnaireSlug, 'uploading');
      await markUploading(group);

      try {
        // Merge answers (last-write-wins deduplication)
        final mergedAnswers = <String, dynamic>{};
        String? formSlug;
        String? projectLocalityId;

        // Sort by updatedAt to ensure last-write-wins like Samia
        group.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));

        for (final r in group) {
          formSlug ??= r.formSlug;
          projectLocalityId ??= r.projectId;
          final decoded = decodeAnswers(r.answersJson);
          mergedAnswers.addAll(decoded);
        }

        if (formSlug == null || mergedAnswers.isEmpty || projectLocalityId == null) {
          await markFailed(group);
          failureCount++;
          failures[questionnaireSlug] = 'Invalid form data';
          onStatusChange?.call(questionnaireSlug, 'failed');
          continue;
        }

        // Load field types
        final fieldTypes = await getFieldTypes(formSlug);

        // Build FormData
        final formData = await buildFormData(
          questionnaireSlug: questionnaireSlug,
          formSlug: formSlug,
          projectLocalityId: projectLocalityId,
          answers: mergedAnswers,
          fieldTypes: fieldTypes,
        );

        // Upload with progress tracking
        await dioClient.post(
          '/collect/questionnaire/submit-form-data/',
          data: formData,
          options: Options(contentType: 'multipart/form-data'),
          onSendProgress: (sent, total) {
            final progress = total > 0 ? sent / total : 0.0;
            onProgress?.call(questionnaireSlug, progress);
            updateProgress(group, progress);
          },
        );

        // Mark as uploaded
        await markUploaded(group);
        successCount++;
        onStatusChange?.call(questionnaireSlug, 'uploaded');
      } catch (e) {
        // Mark as failed to retry later
        await markFailed(group);
        failureCount++;
        final errorMsg = _mapUploadError(e);
        failures[questionnaireSlug] = errorMsg;
        onStatusChange?.call(questionnaireSlug, 'failed');
        debugPrint('Upload failed for $questionnaireSlug: $e');
      }
    }

    return UploadResult(
      successCount: successCount,
      failureCount: failureCount,
      failures: failures,
    );
  }

  /// Upload a specific survey by surveyId
  /// Groups all responses for that survey by questionnaireSlug
  Future<UploadResult> uploadSurvey({
    required String surveyId,
    void Function(String questionnaireSlug, double progress)? onProgress,
    void Function(String questionnaireSlug, String status)? onStatusChange,
  }) async {
    final responses = await getResponsesForSurvey(surveyId);

    if (responses.isEmpty) {
      return UploadResult(
        successCount: 0,
        failureCount: 1,
        failures: {surveyId: 'No responses found'},
      );
    }

    // Group by questionnaireSlug
    final grouped = <String, List<SurveyResponse>>{};
    for (final r in responses) {
      final slug = r.questionnaireSlug;
      if (slug == null || slug.isEmpty) continue;
      if (r.formSlug == null || r.formSlug!.isEmpty) continue;
      grouped.putIfAbsent(slug, () => []).add(r);
    }

    int successCount = 0;
    int failureCount = 0;
    final failures = <String, String>{};

    for (final entry in grouped.entries) {
      final questionnaireSlug = entry.key;
      final group = entry.value;

      // Skip if already uploaded
      if (group.every((r) => r.uploadStatus == UploadStatusConverter.uploaded)) {
        continue;
      }

      // Skip if any is currently uploading
      if (group.any((r) => r.uploadStatus == UploadStatusConverter.uploading)) {
        failures[questionnaireSlug] = 'Upload already in progress';
        failureCount++;
        continue;
      }

      onStatusChange?.call(questionnaireSlug, 'uploading');
      await markUploading(group);

      try {
        // Merge answers (last-write-wins)
        final mergedAnswers = <String, dynamic>{};
        String? formSlug;
        String? projectLocalityId;

        group.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));

        for (final r in group) {
          formSlug ??= r.formSlug;
          projectLocalityId ??= r.projectId;
          final decoded = decodeAnswers(r.answersJson);
          mergedAnswers.addAll(decoded);
        }

        if (formSlug == null || mergedAnswers.isEmpty || projectLocalityId == null) {
          await markFailed(group);
          failureCount++;
          failures[questionnaireSlug] = 'Invalid form data';
          onStatusChange?.call(questionnaireSlug, 'failed');
          continue;
        }

        final fieldTypes = await getFieldTypes(formSlug);

        final formData = await buildFormData(
          questionnaireSlug: questionnaireSlug,
          formSlug: formSlug,
          projectLocalityId: projectLocalityId,
          answers: mergedAnswers,
          fieldTypes: fieldTypes,
        );

        await dioClient.post(
          '/collect/questionnaire/submit-form-data/',
          data: formData,
          options: Options(contentType: 'multipart/form-data'),
          onSendProgress: (sent, total) {
            final progress = total > 0 ? sent / total : 0.0;
            onProgress?.call(questionnaireSlug, progress);
            updateProgress(group, progress);
          },
        );

        await markUploaded(group);
        successCount++;
        onStatusChange?.call(questionnaireSlug, 'uploaded');
      } catch (e) {
        await markFailed(group);
        failureCount++;
        final errorMsg = _mapUploadError(e);
        failures[questionnaireSlug] = errorMsg;
        onStatusChange?.call(questionnaireSlug, 'failed');
        debugPrint('Upload failed for $questionnaireSlug: $e');
      }
    }

    return UploadResult(
      successCount: successCount,
      failureCount: failureCount,
      failures: failures,
    );
  }

  String _mapUploadError(Object error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      if (statusCode != null) {
        if (statusCode >= 500) {
          return 'Server error ($statusCode)';
        }
        if (statusCode == 400) {
          final data = error.response?.data;
          if (data is Map && data['message'] is String) {
            return data['message'] as String;
          }
        }
        return 'Server error ($statusCode)';
      }
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return 'Connection timeout';
      }
      if (error.type == DioExceptionType.connectionError) {
        return 'Network unavailable';
      }
      return error.message ?? 'Network error';
    }
    return error.toString();
  }
}

/// Result of an upload operation
class UploadResult {
  final int successCount;
  final int failureCount;
  final Map<String, String> failures;

  UploadResult({
    required this.successCount,
    required this.failureCount,
    required this.failures,
  });

  bool get hasFailures => failureCount > 0;
  bool get allSucceeded => failureCount == 0 && successCount > 0;
}
