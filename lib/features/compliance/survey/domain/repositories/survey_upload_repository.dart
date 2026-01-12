import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';

abstract class SurveyUploadRepository {
  Future<Either<Failure, void>> uploadSurvey(String surveyId);
  Future<Either<Failure, void>> uploadMultipleSurveys(List<String> surveyIds);
}
