import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/questionnaire_repository.dart';
import 'questionnaire_event.dart';
import 'questionnaire_state.dart';

class QuestionnaireBloc extends Bloc<QuestionnaireEvent, QuestionnaireState> {
  final QuestionnaireRepository repository;

  QuestionnaireBloc({required this.repository})
      : super(QuestionnaireState.initial()) {
    on<LoadQuestionnaires>(_onLoadQuestionnaires);
    on<SearchQuestionnaires>(_onSearchQuestionnaires);
  }

  Future<void> _onLoadQuestionnaires(
    LoadQuestionnaires event,
    Emitter<QuestionnaireState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await repository.getQuestionnaires(
      keyword: event.keyword,
      module: event.module,
      category: event.category,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.toString(),
      )),
      (questionnaires) => emit(state.copyWith(
        questionnaires: questionnaires,
        isLoading: false,
        errorMessage: null,
      )),
    );
  }

  Future<void> _onSearchQuestionnaires(
    SearchQuestionnaires event,
    Emitter<QuestionnaireState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query));
  }
}
