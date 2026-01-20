import 'dart:async';

import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../data/local/database.dart';
import '../../../../../data/local/draft_provider.dart';

enum MadodosoStatus { draft, completed, uploaded }

class MadodosoEntry {
  final String surveyId;
  final String projectId;
  final String projectName;
  final String questionnaireSlug;
  final String questionnaireName;
  final MadodosoStatus status;
  final DateTime updatedAt;
  final int completedForms;
  final int totalForms;
  final bool isDraft;
  final bool dirty;

  const MadodosoEntry({
    required this.surveyId,
    required this.projectId,
    required this.projectName,
    required this.questionnaireSlug,
    required this.questionnaireName,
    required this.status,
    required this.updatedAt,
    required this.completedForms,
    required this.totalForms,
    required this.isDraft,
    required this.dirty,
  });

  /// Returns true if the survey is uploaded and should be read-only
  bool get isReadOnly => !isDraft && !dirty;
}

class MadodosoState {
  final List<MadodosoEntry> drafts;
  final List<MadodosoEntry> completed;
  final List<MadodosoEntry> uploaded;

  const MadodosoState({
    required this.drafts,
    required this.completed,
    required this.uploaded,
  });

  int get draftCount => drafts.length;
  int get completedCount => completed.length;
  int get uploadedCount => uploaded.length;

  static const empty = MadodosoState(drafts: [], completed: [], uploaded: []);
}

class _SurveyAccumulator {
  final String surveyId;
  final String projectId;
  final String? questionnaireSlug;
  final List<SurveyResponse> responses;
  bool hasDraft;
  bool hasDirty;
  int latestUpdatedAt;

  _SurveyAccumulator({
    required this.surveyId,
    required this.projectId,
    required this.questionnaireSlug,
    required SurveyResponse response,
  }) : responses = [response],
       hasDraft = response.isDraft,
       hasDirty = response.dirty,
       latestUpdatedAt = response.updatedAt;

  void add(SurveyResponse response) {
    responses.add(response);
    hasDraft = hasDraft || response.isDraft;
    hasDirty = hasDirty || response.dirty;
    if (response.updatedAt > latestUpdatedAt) {
      latestUpdatedAt = response.updatedAt;
    }
  }
}

/// Provider family that accepts an optional module slug filter
/// Pass null to get all surveys, or a module slug to filter by module
final madodosoStateProviderFamily = StreamProvider.family<
  MadodosoState,
  String?
>((ref, moduleSlug) {
  final database = ref.watch(databaseProvider);

  Stream<List<SurveyResponse>> responsesStream() {
    final query = database.select(database.surveyResponses)
      ..orderBy([(tbl) => drift.OrderingTerm.desc(tbl.updatedAt)]);
    return query.watch();
  }

  return responsesStream().asyncMap((responses) async {
    if (responses.isEmpty) {
      return MadodosoState.empty;
    }

    // Filter by module if specified
    List<SurveyResponse> filteredResponses = responses;
    if (moduleSlug != null) {
      final moduleQuestionnaires =
          await (database.select(database.questionnaires)
            ..where((tbl) => tbl.moduleSlug.equals(moduleSlug))).get();
      final moduleSlugs = moduleQuestionnaires.map((q) => q.slug).toSet();
      filteredResponses =
          responses
              .where(
                (r) =>
                    r.questionnaireSlug != null &&
                    moduleSlugs.contains(r.questionnaireSlug),
              )
              .toList();

      if (filteredResponses.isEmpty) {
        return MadodosoState.empty;
      }
    }

    final accumulators = <String, _SurveyAccumulator>{};
    final projectIds = <String>{};
    final questionnaireSlugs = <String>{};

    for (final response in filteredResponses) {
      final surveyId =
          response.surveyId.isNotEmpty ? response.surveyId : response.id;
      final accumulator = accumulators.putIfAbsent(
        surveyId,
        () => _SurveyAccumulator(
          surveyId: surveyId,
          projectId: response.projectId,
          questionnaireSlug: response.questionnaireSlug,
          response: response,
        ),
      );

      if (!identical(accumulator.responses.last, response)) {
        accumulator.add(response);
      }

      projectIds.add(response.projectId);
      final slug = response.questionnaireSlug;
      if (slug != null && slug.isNotEmpty) {
        questionnaireSlugs.add(slug);
      }
    }

    final projectsMap = <String, Project>{};
    if (projectIds.isNotEmpty) {
      final projectQuery = database.select(database.projects)
        ..where((tbl) => tbl.id.isIn(projectIds.toList()));
      final projectRecords = await projectQuery.get();
      for (final project in projectRecords) {
        projectsMap[project.id] = project;
      }
    }

    final questionnairesBySlug = <String, Questionnaire>{};
    final formsByQuestionnaireId = <int, List<Form>>{};
    if (questionnaireSlugs.isNotEmpty) {
      final questionnaireQuery = database.select(database.questionnaires)
        ..where((tbl) => tbl.slug.isIn(questionnaireSlugs.toList()));
      final questionnaireRecords = await questionnaireQuery.get();
      for (final questionnaire in questionnaireRecords) {
        questionnairesBySlug[questionnaire.slug] = questionnaire;
      }

      final questionnaireIds =
          questionnaireRecords.map((record) => record.id).toSet();

      if (questionnaireIds.isNotEmpty) {
        final formsQuery = database.select(database.forms)
          ..where((tbl) => tbl.questionnaireId.isIn(questionnaireIds.toList()));
        final formsRecords = await formsQuery.get();
        for (final form in formsRecords) {
          formsByQuestionnaireId
              .putIfAbsent(form.questionnaireId ?? 0, () => [])
              .add(form);
        }
      }
    }

    final drafts = <MadodosoEntry>[];
    final completed = <MadodosoEntry>[];
    final uploaded = <MadodosoEntry>[];

    for (final accumulator in accumulators.values) {
      final questionnaire =
          accumulator.questionnaireSlug != null
              ? questionnairesBySlug[accumulator.questionnaireSlug!]
              : null;
      final project = projectsMap[accumulator.projectId];
      final answeredForms =
          accumulator.responses
              .where((response) => response.answersJson.isNotEmpty)
              .map((response) => response.formSlug ?? '')
              .where((slug) => slug.isNotEmpty)
              .toSet();

      final questionnaireId = questionnaire?.id ?? 0;
      final totalForms =
          questionnaireId != 0
              ? formsByQuestionnaireId[questionnaireId]?.length ?? 0
              : answeredForms.length;

      final status =
          accumulator.hasDraft
              ? MadodosoStatus.draft
              : (accumulator.hasDirty
                  ? MadodosoStatus.completed
                  : MadodosoStatus.uploaded);

      final entry = MadodosoEntry(
        surveyId: accumulator.surveyId,
        projectId: accumulator.projectId,
        projectName: project?.name ?? 'Mradi #${accumulator.projectId}',
        questionnaireSlug:
            accumulator.questionnaireSlug ?? questionnaire?.slug ?? '',
        questionnaireName:
            questionnaire?.name ?? accumulator.questionnaireSlug ?? 'Dodoso',
        status: status,
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          accumulator.latestUpdatedAt * 1000,
        ),
        completedForms: answeredForms.length,
        totalForms: totalForms,
        isDraft: accumulator.hasDraft,
        dirty: accumulator.hasDirty,
      );

      switch (status) {
        case MadodosoStatus.draft:
          drafts.add(entry);
        case MadodosoStatus.completed:
          completed.add(entry);
        case MadodosoStatus.uploaded:
          uploaded.add(entry);
      }
    }

    int sortByUpdated(MadodosoEntry a, MadodosoEntry b) =>
        b.updatedAt.compareTo(a.updatedAt);

    drafts.sort(sortByUpdated);
    completed.sort(sortByUpdated);
    uploaded.sort(sortByUpdated);

    return MadodosoState(
      drafts: drafts,
      completed: completed,
      uploaded: uploaded,
    );
  });
});

/// Default provider that shows all surveys (no module filter)
/// This is for backward compatibility
final madodosoStateProvider = madodosoStateProviderFamily(null);
