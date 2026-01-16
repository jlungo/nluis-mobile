import '../entities/survey_item.dart';

abstract class SurveyRepository {
  Stream<List<SurveyItem>> watchSurveys(String projectId, String moduleSlug);
}
