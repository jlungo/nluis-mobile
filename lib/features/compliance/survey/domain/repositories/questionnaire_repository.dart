import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../shared/models/questionnaire.dart';

abstract class QuestionnaireRepository {
  Future<Either<Failure, List<Questionnaire>>> getQuestionnaires({
    String? keyword,
    required String module,
    String? category,
  });
}
