import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

class DraftService {
  final AppDatabase _database;
  static const int draftExpiryDays = 30;

  DraftService(this._database);

  Future<String> saveDraft({
    required String projectId,
    required String questionnaireSlug,
    required String formSlug,
    required Map<String, dynamic> formData,
    required String moduleSlug,
    String? surveyId,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final actualSurveyId = surveyId ?? const Uuid().v4();
    final questionnaireId = await _resolveQuestionnaireId(questionnaireSlug);

    final existing =
        await (_database.select(_database.surveyResponses)..where(
          (tbl) =>
              tbl.surveyId.equals(actualSurveyId) &
              tbl.formSlug.equals(formSlug),
        )).getSingleOrNull();

    final answersJson = jsonEncode(formData);

    if (existing != null) {
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

  Future<bool> saveSurvey({required String surveyId}) async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

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

  Future<void> deleteExpiredDrafts() async {
    final expiryDate =
        DateTime.now()
            .subtract(const Duration(days: draftExpiryDays))
            .millisecondsSinceEpoch ~/
        1000;

    await (_database.delete(_database.surveyResponses)..where(
      (tbl) =>
          tbl.isDraft.equals(true) &
          tbl.updatedAt.isSmallerThanValue(expiryDate),
    )).go();
  }

  /// Load all form data for a survey
  Future<Map<String, Map<String, dynamic>>> loadSurveyData({
    required String surveyId,
  }) async {
    final responses =
        await (_database.select(_database.surveyResponses)
          ..where((tbl) => tbl.surveyId.equals(surveyId))).get();

    final formDataByFormSlug = <String, Map<String, dynamic>>{};

    for (final response in responses) {
      if (response.formSlug != null &&
          response.answersJson != null &&
          response.answersJson.isNotEmpty) {
        try {
          final data = jsonDecode(response.answersJson) as Map<String, dynamic>;
          formDataByFormSlug[response.formSlug!] = data;
        } catch (e) {
          // Error loading form data - skip this entry
        }
      }
    }

    return formDataByFormSlug;
  }

  /// Get survey metadata
  Future<SurveyResponse?> getSurveyMetadata({required String surveyId}) async {
    final responses =
        await (_database.select(_database.surveyResponses)
              ..where((tbl) => tbl.surveyId.equals(surveyId))
              ..limit(1))
            .get();

    return responses.isNotEmpty ? responses.first : null;
  }

  /// Get draft data for a specific project and questionnaire
  Future<Map<String, dynamic>> getDraftByProjectAndQuestionnaire({
    required String projectId,
    required String questionnaireSlug,
  }) async {
    final responses =
        await (_database.select(_database.surveyResponses)
              ..where(
                (tbl) =>
                    tbl.projectId.equals(projectId) &
                    tbl.questionnaireSlug.equals(questionnaireSlug) &
                    tbl.isDraft.equals(true),
              )
              ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)])
              ..limit(1))
            .get();

    if (responses.isEmpty) {
      return {};
    }

    final surveyId = responses.first.surveyId;
    final formData = await loadSurveyData(surveyId: surveyId);

    return {'surveyId': surveyId, 'formData': formData};
  }

  Future<int?> _resolveQuestionnaireId(String questionnaireSlug) async {
    final questionnaire =
        await (_database.select(_database.questionnaires)..where(
          (tbl) => tbl.slug.equals(questionnaireSlug),
        )).getSingleOrNull();

    return questionnaire?.id;
  }
}
