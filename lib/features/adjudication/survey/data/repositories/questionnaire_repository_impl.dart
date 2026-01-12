import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../../../../shared/models/questionnaire.dart';
import '../../domain/repositories/questionnaire_repository.dart';
import '../datasources/questionnaire_remote_datasource.dart';

class QuestionnaireRepositoryImpl implements QuestionnaireRepository {
  final QuestionnaireRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const QuestionnaireRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Questionnaire>>> getQuestionnaires({
    String? keyword,
    required String module,
    String? category,
  }) async {
    final isOnline = await networkInfo.isConnected;
    
    if (!isOnline) {
      return const Left(
        ServerFailure('Hakuna muunganisho wa mtandao. Washa mtandao ili kupakia madodoso.'),
      );
    }

    return await remoteDataSource.getQuestionnaires(
      keyword: keyword,
      module: module,
      category: category,
    );
  }
}
