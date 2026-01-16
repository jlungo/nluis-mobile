import '../../../../../core/database/app_database.dart';
import '../../domain/entities/survey_dashboard_stats.dart';

abstract class SurveyStatsLocalDataSource {
  Stream<SurveyDashboardStats> watchSurveyStats(String moduleSlug);
}

class SurveyStatsLocalDataSourceImpl implements SurveyStatsLocalDataSource {
  final AppDatabase database;

  const SurveyStatsLocalDataSourceImpl({required this.database});

  @override
  Stream<SurveyDashboardStats> watchSurveyStats(String moduleSlug) {
    return (database.select(database.surveyResponses)..where(
      (tbl) => tbl.moduleSlug.equals(moduleSlug),
    )).watch().map((responses) {
      if (responses.isEmpty) {
        return const SurveyDashboardStats(
          total: 0,
          completed: 0,
          drafts: 0,
          uploaded: 0,
        );
      }

      final Map<String, _SurveyAggregate> aggregates = {};

      for (final response in responses) {
        final aggregate = aggregates.putIfAbsent(
          response.surveyId,
          () => _SurveyAggregate(),
        );

        aggregate.isDraft = aggregate.isDraft && response.isDraft;
        aggregate.hasDirtyData = aggregate.hasDirtyData || response.dirty;
      }

      var drafts = 0;
      var completed = 0;
      var uploaded = 0;

      for (final aggregate in aggregates.values) {
        if (aggregate.isDraft) {
          drafts++;
        } else {
          completed++;
          if (!aggregate.hasDirtyData) {
            uploaded++;
          }
        }
      }

      return SurveyDashboardStats(
        total: aggregates.length,
        completed: completed,
        drafts: drafts,
        uploaded: uploaded,
      );
    });
  }
}

class _SurveyAggregate {
  bool isDraft = true;
  bool hasDirtyData = false;
}
