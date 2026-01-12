import '../entities/survey_dashboard_stats.dart';

abstract class SurveyStatsRepository {
  Stream<SurveyDashboardStats> watchSurveyStats(String moduleSlug);
}
