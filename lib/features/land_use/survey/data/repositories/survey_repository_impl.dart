import '../../../../../../shared/models/survey_item.dart';
import '../../domain/repositories/survey_repository.dart';
import '../datasources/survey_local_datasource.dart';

class SurveyRepositoryImpl implements SurveyRepository {
  final SurveyLocalDataSource localDataSource;

  const SurveyRepositoryImpl({required this.localDataSource});

  @override
  Stream<List<SurveyItem>> watchSurveys(String projectId, String moduleSlug) {
    return localDataSource.watchSurveys(projectId, moduleSlug);
  }
}
