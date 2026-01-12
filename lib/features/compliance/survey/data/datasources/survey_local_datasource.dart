import 'package:drift/drift.dart' as drift;
import '../../../../../core/database/app_database.dart';
import '../../../../../../shared/models/survey_item.dart';

abstract class SurveyLocalDataSource {
  Stream<List<SurveyItem>> watchSurveys(String projectId, String moduleSlug);
}

class SurveyLocalDataSourceImpl implements SurveyLocalDataSource {
  final AppDatabase database;

  const SurveyLocalDataSourceImpl({required this.database});

  @override
  Stream<List<SurveyItem>> watchSurveys(String projectId, String moduleSlug) {
    return (database.select(database.surveyResponses)
          ..where(
            (tbl) =>
                tbl.projectId.equals(projectId) &
                tbl.moduleSlug.equals(moduleSlug),
          )
          ..orderBy([(tbl) => drift.OrderingTerm.desc(tbl.updatedAt)]))
        .watch()
        .asyncMap((responses) async {
          if (responses.isEmpty) {
            return <SurveyItem>[];
          }

          final Map<String, List<SurveyResponse>> grouped = {};
          for (final response in responses) {
            grouped.putIfAbsent(response.surveyId, () => []).add(response);
          }

          final Map<String, String> questionnaireNameCache = {};
          final List<SurveyItem> surveys = [];

          for (final entry in grouped.entries) {
            final surveyId = entry.key;
            final surveyResponses = entry.value;
            surveyResponses.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

            final firstResponse = surveyResponses.first;
            final questionnaireSlug = firstResponse.questionnaireSlug ?? '';

            String questionnaireName = 'Dodoso';
            if (questionnaireSlug.isNotEmpty) {
              final cachedName = await _resolveQuestionnaireName(
                questionnaireSlug,
                questionnaireNameCache,
              );
              questionnaireName = cachedName ?? questionnaireName;
            }

            final latestUpdatedAt = surveyResponses
                .map((r) => r.updatedAt)
                .reduce((value, element) => element > value ? element : value);

            final isDraft = surveyResponses.any((r) => r.isDraft);
            final isDirty = surveyResponses.any((r) => r.dirty);

            final defaultStatus =
                !isDirty && !isDraft ? UploadStatus.success : UploadStatus.idle;

            surveys.add(
              SurveyItem(
                surveyId: surveyId,
                projectId: firstResponse.projectId,
                questionnaireSlug: questionnaireSlug,
                questionnaireName: questionnaireName,
                isDraft: isDraft,
                isDirty: isDirty,
                formsCount: surveyResponses.length,
                savedDate: _formatDate(
                  DateTime.fromMillisecondsSinceEpoch(latestUpdatedAt * 1000),
                ),
                updatedAt: latestUpdatedAt,
                uploadStatus: defaultStatus,
              ),
            );
          }

          surveys.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          return surveys;
        });
  }

  Future<String?> _resolveQuestionnaireName(
    String slug,
    Map<String, String> cache,
  ) async {
    if (cache.containsKey(slug)) {
      return cache[slug];
    }

    final questionnaire =
        await (database.select(database.questionnaires)
          ..where((tbl) => tbl.slug.equals(slug))).getSingleOrNull();

    final name = questionnaire?.name;
    cache[slug] = name ?? 'Dodoso';
    return name;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m zilizopita';
      }
      return '${difference.inHours}h zilizopita';
    } else if (difference.inDays == 1) {
      return 'Jana';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} siku zilizopita';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
