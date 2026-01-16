import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../shared/models/questionnaire.dart';

abstract class QuestionnaireDetailRepository {
  Future<Either<Failure, QuestionnaireDetail>> getQuestionnaireDetail(
    String slug,
  );
}
