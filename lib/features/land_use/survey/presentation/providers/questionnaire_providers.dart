import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/network/network_info.dart';
import '../../../../../data/local/draft_provider.dart';
import '../../../../../data/repositories/questionnaire_repository.dart';
import '../../../../../shared/models/questionnaire.dart';
import '../../../../auth/presentation/providers/auth_providers.dart';

class QuestionnaireListParams extends Equatable {
  final String? keyword;
  final String? module;
  final String? category;

  const QuestionnaireListParams({this.keyword, this.module, this.category});

  @override
  List<Object?> get props => [keyword, module, category];
}

final questionnaireRepositoryProvider = Provider<QuestionnaireRepository>((
  ref,
) {
  final dioClient = ref.watch(dioClientProvider);
  final database = ref.watch(databaseProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return QuestionnaireRepositoryImpl(
    dioClient: dioClient,
    database: database,
    networkInfo: networkInfo,
  );
});

// Questionnaire List Provider
final questionnaireListProvider =
    FutureProvider.family<List<Questionnaire>, QuestionnaireListParams>((
      ref,
      params,
    ) async {
      final repository = ref.watch(questionnaireRepositoryProvider);
      final result = await repository.getQuestionnaireList(
        keyword: params.keyword,
        module: params.module,
        category: params.category,
      );

      return result.fold(
        (failure) => throw Exception(failure.toString()),
        (questionnaires) => questionnaires,
      );
    });

// Questionnaire Detail Provider
final questionnaireDetailProvider =
    FutureProvider.family<QuestionnaireDetail, String>((ref, slug) async {
      final repository = ref.watch(questionnaireRepositoryProvider);
      final result = await repository.getQuestionnaireDetail(slug);

      return result.fold(
        (failure) => throw Exception(failure.toString()),
        (detail) => detail,
      );
    });

// Selected Questionnaire Slug State Provider
final selectedQuestionnaireSlugProvider = StateProvider<String?>((ref) => null);
