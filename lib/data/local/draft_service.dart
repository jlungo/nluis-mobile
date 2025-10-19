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
    String? surveyId, // If null, creates new survey
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final actualSurveyId = surveyId ?? const Uuid().v4();
    final questionnaireId = await _resolveQuestionnaireId(questionnaireSlug);

    // Check if draft already exists for this survey and form
    final existing = await (_database.select(_database.surveyResponses)
          ..where((tbl) =>
              tbl.surveyId.equals(actualSurveyId) &
              tbl.formSlug.equals(formSlug)))
        .getSingleOrNull();

    final answersJson = jsonEncode(formData);

    if (existing != null) {
      // Update existing draft
      await (_database.update(_database.surveyResponses)
            ..where((tbl) => tbl.id.equals(existing.id)))
          .write(SurveyResponsesCompanion(
            answersJson: Value(answersJson),
            questionnaireSlug: Value(questionnaireSlug),
            questionnaireId:
                questionnaireId != null ? Value(questionnaireId) : const Value.absent(),
            updatedAt: Value(now),
            dirty: const Value(true),
          ));
      return actualSurveyId;
    } else {
      // Create new form response in this survey
      final responseId = const Uuid().v4();
      await _database.into(_database.surveyResponses).insert(
        SurveyResponsesCompanion.insert(
          id: responseId,
          surveyId: actualSurveyId,
          projectId: projectId,
          questionnaireId: questionnaireId ?? 0,
          questionnaireSlug: Value(questionnaireSlug),
          formSlug: Value(formSlug),
          answersJson: answersJson,
          isDraft: const Value(true),
          updatedAt: now,
          dirty: const Value(true),
        ),
      );
      return actualSurveyId;
    }
  }

  /// Save a survey (mark it as complete/ready)
  Future<bool> saveSurvey({
    required String surveyId,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // Get all forms for this survey
    final forms = await (_database.select(_database.surveyResponses)
          ..where((tbl) => tbl.surveyId.equals(surveyId)))
        .get();

    if (forms.isEmpty) {
      return false;
    }

    final questionnaireSlug = forms
        .map((response) => response.questionnaireSlug)
        .firstWhere((slug) => slug != null && slug.isNotEmpty, orElse: () => null);
    final questionnaireId =
        questionnaireSlug != null ? await _resolveQuestionnaireId(questionnaireSlug) : null;

    // Mark survey as saved (not draft = true, but dirty = true for upload)
    await (_database.update(_database.surveyResponses)
          ..where((tbl) => tbl.surveyId.equals(surveyId)))
        .write(SurveyResponsesCompanion(
          isDraft: const Value(false),
          updatedAt: Value(now),
          dirty: const Value(true),
          questionnaireId:
              questionnaireId != null ? Value(questionnaireId) : const Value.absent(),
        ));

    return true;
  }

  /// Get all surveys for a project
  Future<List<String>> getProjectSurveys({
    required String projectId,
  }) async {
    final responses = await (_database.select(_database.surveyResponses)
          ..where((tbl) => tbl.projectId.equals(projectId)))
        .get();

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
    final drafts = await (_database.select(_database.surveyResponses)
          ..where((tbl) =>
              tbl.projectId.equals(projectId) &
              tbl.questionnaireSlug.equals(questionnaireSlug) &
              tbl.isDraft.equals(true)))
        .get();

    // Check if we have drafts for all forms and they have data
    return drafts.length >= totalFormsCount &&
           drafts.every((draft) => draft.answersJson.isNotEmpty && draft.answersJson != '{}');
  }

  /// Get draft for a specific form
  Future<Map<String, dynamic>?> getDraft({
    required String projectId,
    required String formSlug,
  }) async {
    final draft = await (_database.select(_database.surveyResponses)
          ..where((tbl) =>
              tbl.projectId.equals(projectId) &
              tbl.formSlug.equals(formSlug) &
              tbl.isDraft.equals(true)))
        .getSingleOrNull();

    if (draft == null) return null;

    return jsonDecode(draft.answersJson) as Map<String, dynamic>;
  }

  /// Get all drafts for a project
  Future<List<SurveyResponse>> getProjectDrafts(String projectId) async {
    return await (_database.select(_database.surveyResponses)
          ..where((tbl) =>
              tbl.projectId.equals(projectId) &
              tbl.isDraft.equals(true))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .get();
  }

  /// Get all submitted (completed) questionnaires for a project
  Future<List<SurveyResponse>> getProjectCompletedQuestionnaires(String projectId) async {
    return await (_database.select(_database.surveyResponses)
          ..where((tbl) =>
              tbl.projectId.equals(projectId) &
              tbl.isDraft.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .get();
  }

  /// Get all drafts with count by project
  Future<Map<String, int>> getDraftCounts() async {
    final drafts = await (_database.select(_database.surveyResponses)
          ..where((tbl) => tbl.isDraft.equals(true)))
        .get();

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

    return await (_database.delete(_database.surveyResponses)
          ..where((tbl) =>
              tbl.isDraft.equals(true) &
              tbl.updatedAt.isSmallerThanValue(expiryTimestamp)))
        .go();
  }

  /// Delete a specific draft
  Future<bool> deleteDraft(String draftId) async {
    final deleted = await (_database.delete(_database.surveyResponses)
          ..where((tbl) => tbl.id.equals(draftId)))
        .go();
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

  /// Get draft age in days
  int getDraftAgeInDays(int updatedAtTimestamp) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final ageInSeconds = now - updatedAtTimestamp;
    return ageInSeconds ~/ (24 * 60 * 60);
  }

  Future<int?> _resolveQuestionnaireId(String questionnaireSlug) async {
    if (questionnaireSlug.isEmpty) return null;
    final record =
        await (_database.select(_database.questionnaires)
              ..where((tbl) => tbl.slug.equals(questionnaireSlug)))
            .getSingleOrNull();
    return record?.id;
  }
}
