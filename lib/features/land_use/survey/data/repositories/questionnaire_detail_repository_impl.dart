import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../../../../shared/models/questionnaire.dart';
import '../../domain/repositories/questionnaire_detail_repository.dart';
import '../datasources/questionnaire_detail_remote_datasource.dart';

class QuestionnaireDetailRepositoryImpl
    implements QuestionnaireDetailRepository {
  final QuestionnaireDetailRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const QuestionnaireDetailRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, QuestionnaireDetail>> getQuestionnaireDetail(
    String slug,
  ) async {
    final isOnline = await networkInfo.isConnected;

    if (!isOnline) {
      return const Left(
        ServerFailure(
          'Hakuna muunganisho wa mtandao. Washa mtandao ili kupakia dodoso.',
        ),
      );
    }

    return await remoteDataSource.getQuestionnaireDetail(slug);
  }
}
