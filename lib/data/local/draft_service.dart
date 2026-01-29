import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'database.dart';
import 'dart:convert';

class DraftService {
  final AppDatabase _database;
  static const int draftExpiryDays = 30;

  DraftService(this._database);

  /// Save or update a form within a survey
  Future<String> saveDraft({
    required String projectId,
    required String questionnaireSlug,
    required String formSlug,
    required Map<String, dynamic> formData,
    required String moduleSlug,
    String? surveyId, // If null, creates new survey
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final actualSurveyId = surveyId ?? const Uuid().v4();
    final questionnaireId = await _resolveQuestionnaireId(questionnaireSlug);

    // Check if draft already exists for this survey and form
    final existing =
        await (_database.select(_database.surveyResponses)..where(
          (tbl) =>
              tbl.surveyId.equals(actualSurveyId) &
              tbl.formSlug.equals(formSlug),
        )).getSingleOrNull();

    final answersJson = jsonEncode(formData);

    if (existing != null) {
      // Update existing draft
      await (_database.update(_database.surveyResponses)
        ..where((tbl) => tbl.id.equals(existing.id))).write(
        SurveyResponsesCompanion(
          answersJson: Value(answersJson),
          questionnaireSlug: Value(questionnaireSlug),
          questionnaireId:
              questionnaireId != null
                  ? Value(questionnaireId)
                  : const Value.absent(),
          updatedAt: Value(now),
          dirty: const Value(false),
        ),
      );
      return actualSurveyId;
    } else {
      // Create new form response in this survey
      final responseId = const Uuid().v4();
      await _database
          .into(_database.surveyResponses)
          .insert(
            SurveyResponsesCompanion.insert(
              id: responseId,
              surveyId: actualSurveyId,
              projectId: projectId,
              moduleSlug: Value(moduleSlug),
              questionnaireId: questionnaireId ?? 0,
              questionnaireSlug: Value(questionnaireSlug),
              formSlug: Value(formSlug),
              answersJson: answersJson,
              isDraft: const Value(true),
              updatedAt: now,
              dirty: const Value(false),
            ),
          );
      return actualSurveyId;
    }
  }

  /// Save a survey (mark it as complete/ready)
  Future<bool> saveSurvey({required String surveyId}) async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // Get all forms for this survey
    final forms =
        await (_database.select(_database.surveyResponses)
          ..where((tbl) => tbl.surveyId.equals(surveyId))).get();

    if (forms.isEmpty) {
      return false;
    }

    final questionnaireSlug = forms
        .map((response) => response.questionnaireSlug)
        .firstWhere(
          (slug) => slug != null && slug.isNotEmpty,
          orElse: () => null,
        );
    final questionnaireId =
        questionnaireSlug != null
            ? await _resolveQuestionnaireId(questionnaireSlug)
            : null;

    // Mark survey as saved (not draft = true, but dirty = true for upload)
    await (_database.update(_database.surveyResponses)
      ..where((tbl) => tbl.surveyId.equals(surveyId))).write(
      SurveyResponsesCompanion(
        isDraft: const Value(false),
        updatedAt: Value(now),
        dirty: const Value(true),
        questionnaireId:
            questionnaireId != null
                ? Value(questionnaireId)
                : const Value.absent(),
      ),
    );

    return true;
  }

  /// Get all surveys for a project
  Future<List<String>> getProjectSurveys({required String projectId}) async {
    final responses =
        await (_database.select(_database.surveyResponses)
          ..where((tbl) => tbl.projectId.equals(projectId))).get();

    // Get unique survey IDs
    final surveyIds = responses.map((r) => r.surveyId).toSet().toList();
    return surveyIds;
  }

  /// Check if all forms in a questionnaire have been filled
  Future<bool> isQuestionnaireComplete({
    required String projectId,
    required String questionnaireSlug,
    required int totalFormsCount,
  }) async {
    final drafts =
        await (_database.select(_database.surveyResponses)..where(
          (tbl) =>
              tbl.projectId.equals(projectId) &
              tbl.questionnaireSlug.equals(questionnaireSlug) &
              tbl.isDraft.equals(true),
        )).get();

    // Check if we have drafts for all forms and they have data
    return drafts.length >= totalFormsCount &&
        drafts.every(
          (draft) => draft.answersJson.isNotEmpty && draft.answersJson != '{}',
        );
  }

  /// Get draft for a specific form
  Future<Map<String, dynamic>?> getDraft({
    required String projectId,
    required String formSlug,
  }) async {
    final draft =
        await (_database.select(_database.surveyResponses)..where(
          (tbl) =>
              tbl.projectId.equals(projectId) &
              tbl.formSlug.equals(formSlug) &
              tbl.isDraft.equals(true),
        )).getSingleOrNull();

    if (draft == null) return null;

    return jsonDecode(draft.answersJson) as Map<String, dynamic>;
  }

  /// Get all drafts for a project
  Future<List<SurveyResponse>> getProjectDrafts(String projectId) async {
    return await (_database.select(_database.surveyResponses)
          ..where(
            (tbl) => tbl.projectId.equals(projectId) & tbl.isDraft.equals(true),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .get();
  }

  /// Get all submitted (completed) questionnaires for a project
  Future<List<SurveyResponse>> getProjectCompletedQuestionnaires(
    String projectId,
  ) async {
    return await (_database.select(_database.surveyResponses)
          ..where(
            (tbl) =>
                tbl.projectId.equals(projectId) & tbl.isDraft.equals(false),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .get();
  }

  /// Get all drafts with count by project
  Future<Map<String, int>> getDraftCounts() async {
    final drafts =
        await (_database.select(_database.surveyResponses)
          ..where((tbl) => tbl.isDraft.equals(true))).get();

    final Map<String, int> counts = {};
    for (final draft in drafts) {
      counts[draft.projectId] = (counts[draft.projectId] ?? 0) + 1;
    }
    return counts;
  }

  /// Delete expired drafts (older than 30 days)
  Future<int> deleteExpiredDrafts() async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final expiryTimestamp = now - (draftExpiryDays * 24 * 60 * 60);

    return await (_database.delete(_database.surveyResponses)..where(
      (tbl) =>
          tbl.isDraft.equals(true) &
          tbl.updatedAt.isSmallerThanValue(expiryTimestamp),
    )).go();
  }

  /// Delete a specific draft
  Future<bool> deleteDraft(String draftId) async {
    final deleted =
        await (_database.delete(_database.surveyResponses)
          ..where((tbl) => tbl.id.equals(draftId))).go();
    return deleted > 0;
  }

  /// Clear all data from database
  Future<void> clearAllData() async {
    await _database.transaction(() async {
      await _database.delete(_database.surveyResponses).go();
      await _database.delete(_database.zoningFeatures).go();
      await _database.delete(_database.baseMaps).go();
      await _database.delete(_database.formFields).go();
      await _database.delete(_database.forms).go();
      await _database.delete(_database.questionnaires).go();
      await _database.delete(_database.questionnaireTypes).go();
      await _database.delete(_database.projectPacks).go();
      await _database.delete(_database.projects).go();
      await _database.delete(_database.syncLogs).go();
      // Keep users table for authentication
    });
  }

  /// Clear drafts only (isDraft = true)
  Future<int> clearDrafts() async {
    return await (_database.delete(_database.surveyResponses)
      ..where((tbl) => tbl.isDraft.equals(true))).go();
  }

  /// Clear completed surveys waiting for upload (isDraft = false, dirty = true)
  Future<int> clearPendingUploads() async {
    return await (_database.delete(
      _database.surveyResponses,
    )..where((tbl) => tbl.isDraft.equals(false) & tbl.dirty.equals(true))).go();
  }

  /// Clear uploaded surveys (isDraft = false, dirty = false)
  Future<int> clearUploadedSurveys() async {
    return await (_database.delete(_database.surveyResponses)..where(
      (tbl) => tbl.isDraft.equals(false) & tbl.dirty.equals(false),
    )).go();
  }

  /// Clear all survey responses
  Future<int> clearAllSurveyResponses() async {
    return await _database.delete(_database.surveyResponses).go();
  }

  /// Clear downloaded projects and related data
  Future<void> clearDownloadedProjects() async {
    await _database.transaction(() async {
      await _database.delete(_database.projectPacks).go();
      await _database.delete(_database.projects).go();
    });
  }

  /// Clear questionnaires and forms
  Future<void> clearQuestionnaires() async {
    await _database.transaction(() async {
      await _database.delete(_database.formFields).go();
      await _database.delete(_database.forms).go();
      await _database.delete(_database.questionnaires).go();
      await _database.delete(_database.questionnaireTypes).go();
    });
  }

  /// Clear zoning features
  Future<int> clearZoningFeatures() async {
    return await _database.delete(_database.zoningFeatures).go();
  }

  /// Clear base maps
  Future<int> clearBaseMaps() async {
    return await _database.delete(_database.baseMaps).go();
  }

  /// Clear sync logs
  Future<int> clearSyncLogs() async {
    return await _database.delete(_database.syncLogs).go();
  }

  /// Selective data clearing based on options
  Future<void> clearSelectedData({
    bool drafts = false,
    bool pendingUploads = false,
    bool uploadedSurveys = false,
    bool downloadedProjects = false,
    bool questionnaires = false,
    bool zoningFeatures = false,
    bool baseMaps = false,
    bool syncLogs = false,
  }) async {
    await _database.transaction(() async {
      if (drafts) await clearDrafts();
      if (pendingUploads) await clearPendingUploads();
      if (uploadedSurveys) await clearUploadedSurveys();
      if (downloadedProjects) await clearDownloadedProjects();
      if (questionnaires) await clearQuestionnaires();
      if (zoningFeatures) await clearZoningFeatures();
      if (baseMaps) await clearBaseMaps();
      if (syncLogs) await clearSyncLogs();
    });
  }

  /// Get draft age in days
  int getDraftAgeInDays(int updatedAtTimestamp) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final ageInSeconds = now - updatedAtTimestamp;
    return ageInSeconds ~/ (24 * 60 * 60);
  }

  Future<int?> _resolveQuestionnaireId(String questionnaireSlug) async {
    if (questionnaireSlug.isEmpty) return null;
    final record =
        await (_database.select(_database.questionnaires)..where(
          (tbl) => tbl.slug.equals(questionnaireSlug),
        )).getSingleOrNull();
    return record?.id;
  }

  // ============ SIZE CALCULATION METHODS ============

  /// Get storage sizes for all data types
  Future<Map<String, int>> getStorageSizes() async {
    return {
      'drafts': await _getDraftsSize(),
      'pendingUploads': await _getPendingUploadsSize(),
      'uploadedSurveys': await _getUploadedSurveysSize(),
      'downloadedProjects': await _getDownloadedProjectsSize(),
      'questionnaires': await _getQuestionnairesSize(),
      'zoningFeatures': await _getZoningFeaturesSize(),
      'baseMaps': await _getBaseMapsSize(),
      'syncLogs': await _getSyncLogsSize(),
    };
  }

  Future<int> _getDraftsSize() async {
    final drafts =
        await (_database.select(_database.surveyResponses)
          ..where((tbl) => tbl.isDraft.equals(true))).get();
    return _calculateResponsesSize(drafts);
  }

  Future<int> _getPendingUploadsSize() async {
    final pending =
        await (_database.select(_database.surveyResponses)..where(
          (tbl) => tbl.isDraft.equals(false) & tbl.dirty.equals(true),
        )).get();
    return _calculateResponsesSize(pending);
  }

  Future<int> _getUploadedSurveysSize() async {
    final uploaded =
        await (_database.select(_database.surveyResponses)..where(
          (tbl) => tbl.isDraft.equals(false) & tbl.dirty.equals(false),
        )).get();
    return _calculateResponsesSize(uploaded);
  }

  int _calculateResponsesSize(List<SurveyResponse> responses) {
    int size = 0;
    for (final response in responses) {
      size += response.id.length;
      size += response.surveyId.length;
      size += response.projectId.length;
      size += response.answersJson.length;
      size += response.questionnaireSlug?.length ?? 0;
      size += response.formSlug?.length ?? 0;
      size += response.moduleSlug.length;
      size += 50; // Approximate overhead for other fields
    }
    return size;
  }

  Future<int> _getDownloadedProjectsSize() async {
    final projects = await _database.select(_database.projects).get();
    final packs = await _database.select(_database.projectPacks).get();
    int size = 0;
    for (final project in projects) {
      size += project.id.length;
      size += project.name.length;
      size += project.status.length;
      size += 100; // Approximate overhead
    }
    for (final pack in packs) {
      size += pack.projectId.length;
      size += pack.status.length;
      size += pack.sizeBytes ?? 0;
      size += 50;
    }
    return size;
  }

  Future<int> _getQuestionnairesSize() async {
    final questionnaires =
        await _database.select(_database.questionnaires).get();
    final forms = await _database.select(_database.forms).get();
    final fields = await _database.select(_database.formFields).get();
    final types = await _database.select(_database.questionnaireTypes).get();
    int size = 0;
    for (final q in questionnaires) {
      size += q.name.length;
      size += q.slug.length;
      size += q.description.length;
      size += 50;
    }
    for (final f in forms) {
      size += f.name.length;
      size += f.slug.length;
      size += f.description.length;
      size += 50;
    }
    for (final field in fields) {
      size += field.name.length;
      size += field.label.length;
      size += field.type.length;
      size += field.optionsJson?.length ?? 0;
      size += 100;
    }
    size += types.length * 50;
    return size;
  }

  Future<int> _getZoningFeaturesSize() async {
    final features = await _database.select(_database.zoningFeatures).get();
    int size = 0;
    for (final feature in features) {
      size += feature.clientUuid.length;
      size += feature.projectId.length;
      size += feature.coordsJson.length;
      size += feature.propertiesJson?.length ?? 0;
      size += 100;
    }
    return size;
  }

  Future<int> _getBaseMapsSize() async {
    final maps = await _database.select(_database.baseMaps).get();
    int size = 0;
    for (final map in maps) {
      size += map.geoJson.length;
      size += 50;
    }
    return size;
  }

  Future<int> _getSyncLogsSize() async {
    final logs = await _database.select(_database.syncLogs).get();
    int size = 0;
    for (final log in logs) {
      size += log.id.length;
      size += log.refType.length;
      size += log.refId.length;
      size += log.lastError?.length ?? 0;
      size += 50;
    }
    return size;
  }
}
