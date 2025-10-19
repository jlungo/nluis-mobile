import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import '../local/database.dart';
import '../../core/env/env.dart';

class ProjectDownloadService {
  final AppDatabase _database;
  final Dio _dio;

  ProjectDownloadService(this._database, this._dio);

  /// Download all project data (questionnaires, forms, fields) for offline use
  Future<DownloadResult> downloadProjectData(String projectId) async {
    try {
      // 1. Get project details
      final project =
          await (_database.select(_database.projects)
            ..where((tbl) => tbl.id.equals(projectId))).getSingleOrNull();

      if (project == null) {
        return DownloadResult(success: false, message: 'Mradi haupatikani');
      }

      final queryParameters = <String, dynamic>{};
      queryParameters['module'] = 'land-uses';

      print('Query parameters: ${queryParameters}');

      // 2. Fetch questionnaires for this project's locality -- Download all questionnaires for now
      final questionnairesResponse = await _dio.get(
        // '${Env.baseUrl}/questionnaires/?locality_id=${project.localityId}',
        '${Env.baseUrl}/collect/questionnaire/list/',
        queryParameters: queryParameters,
      );

      print(
        'Questionnaires response status: ${questionnairesResponse.statusCode}',
      );

      if (questionnairesResponse.statusCode != 200) {
        return DownloadResult(
          success: false,
          message: 'Imeshindwa kupakua dodoso',
        );
      }

      final questionnaires =
          questionnairesResponse.data['results'] as List<dynamic>? ??
          questionnairesResponse.data as List<dynamic>;

      int downloadedCount = 0;

      // 3. Download each questionnaire with its forms and fields
      for (final qnData in questionnaires) {
        final questionnaireSlug = qnData['slug'] as String;

        // Fetch full questionnaire details with sections and forms
        final detailResponse = await _dio.get(
          '${Env.baseUrl}/collect/questionnaire/$questionnaireSlug/detail/',
        );

        if (detailResponse.statusCode == 200) {
          await _saveQuestionnaireToDatabase(detailResponse.data);
          downloadedCount++;
        }
      }

      // 4. Mark project as downloaded
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await (_database.update(_database.projects)
        ..where((tbl) => tbl.id.equals(projectId))).write(
        ProjectsCompanion(
          isDownloaded: const drift.Value(true),
          downloadedAt: drift.Value(now),
        ),
      );

      return DownloadResult(
        success: true,
        message: 'Dodoso $downloadedCount zimesafirishwa',
        downloadedCount: downloadedCount,
      );
    } on DioException catch (e) {
      return DownloadResult(
        success: false,
        message: 'Hakuna mtandao: ${e.message}',
        isNetworkError: true,
      );
    } catch (e) {
      return DownloadResult(success: false, message: 'Hitilafu: $e');
    }
  }

  /// Save questionnaire data to local database
  Future<void> _saveQuestionnaireToDatabase(Map<String, dynamic> data) async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // Save questionnaire type
    final category = data['category'] as int;
    await _database
        .into(_database.questionnaireTypes)
        .insertOnConflictUpdate(
          QuestionnaireTypesCompanion.insert(
            id: drift.Value(category),
            name: data['name'] as String? ?? 'Unknown',
            slug: data['slug'] as String,
            localityId: 0, // Will be set from context
          ),
        );

    // Save questionnaire
    await _database
        .into(_database.questionnaires)
        .insertOnConflictUpdate(
          QuestionnairesCompanion.insert(
            id: drift.Value(category),
            name: data['name'] as String,
            slug: data['slug'] as String,
            typeId: category,
            version: (data['version'] as int).toString(),
            updatedAt: now,
            localityId: 0,
          ),
        );

    // Save sections and forms
    final sections = data['questionnaire_sections'] as List<dynamic>? ?? [];
    for (final section in sections) {
      final sectionForms =
          section['questionnaire_section_forms'] as List<dynamic>? ?? [];

      for (final formData in sectionForms) {
        // Save form
        final formSlug = formData['slug'] as String;
        await _database
            .into(_database.forms)
            .insertOnConflictUpdate(
              FormsCompanion.insert(
                slug: formSlug,
                questionnaireId: drift.Value(category),
                name: formData['name'] as String,
                description: formData['description'] as String? ?? '',
                moduleSlug: formData['module_slug'] as String,
                workflowSlug: formData['workflow_slug'] as String? ?? '',
                position: formData['position'] as int,
                updatedAt: now,
              ),
            );

        // Save form fields
        final fields = formData['custom_form_fields'] as List<dynamic>? ?? [];
        for (final field in fields) {
          await _database
              .into(_database.formFields)
              .insertOnConflictUpdate(
                FormFieldsCompanion.insert(
                  id: drift.Value(int.parse(field['id'].toString())),
                  formSlug: formSlug,
                  label: field['label'] as String,
                  type: field['type'] as String,
                  name: field['name'] as String,
                  required: drift.Value(field['required'] as bool? ?? false),
                  position: field['position'] as int,
                  optionsJson: drift.Value(
                    field['questionnaire_select_options'] != null
                        ? jsonEncode(field['questionnaire_select_options'])
                        : null,
                  ),
                ),
              );
        }
      }
    }
  }

  /// Check if project data is downloaded
  Future<bool> isProjectDownloaded(String projectId) async {
    final project =
        await (_database.select(_database.projects)
          ..where((tbl) => tbl.id.equals(projectId))).getSingleOrNull();

    return project?.isDownloaded ?? false;
  }

  /// Get download status for all projects
  Future<Map<String, bool>> getDownloadStatuses() async {
    final projects = await _database.select(_database.projects).get();
    final Map<String, bool> statuses = {};

    for (final project in projects) {
      statuses[project.id] = project.isDownloaded;
    }

    return statuses;
  }
}

class DownloadResult {
  final bool success;
  final String message;
  final int downloadedCount;
  final bool isNetworkError;

  DownloadResult({
    required this.success,
    required this.message,
    this.downloadedCount = 0,
    this.isNetworkError = false,
  });
}
