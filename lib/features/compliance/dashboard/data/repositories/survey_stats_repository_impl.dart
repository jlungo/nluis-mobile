import '../../domain/entities/survey_dashboard_stats.dart';
import '../../domain/repositories/survey_stats_repository.dart';
import '../datasources/survey_stats_local_datasource.dart';

class SurveyStatsRepositoryImpl implements SurveyStatsRepository {
  final SurveyStatsLocalDataSource localDataSource;

  const SurveyStatsRepositoryImpl({required this.localDataSource});

  @override
  Stream<SurveyDashboardStats> watchSurveyStats(String moduleSlug) {
    return localDataSource.watchSurveyStats(moduleSlug);
  }
}
