import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/survey_repository.dart';
import 'survey_list_event.dart';
import 'survey_list_state.dart';

class SurveyListBloc extends Bloc<SurveyListEvent, SurveyListState> {
  final SurveyRepository repository;
  StreamSubscription? _surveysSubscription;

  SurveyListBloc({required this.repository})
    : super(SurveyListState.initial()) {
    on<LoadSurveys>(_onLoadSurveys);
    on<SurveysUpdated>(_onSurveysUpdated);
    on<FilterSurveys>(_onFilterSurveys);
    on<SearchSurveys>(_onSearchSurveys);
    on<FilterByDateRange>(_onFilterByDateRange);
  }

  Future<void> _onLoadSurveys(
    LoadSurveys event,
    Emitter<SurveyListState> emit,
  ) async {
    await _surveysSubscription?.cancel();

    _surveysSubscription = repository
        .watchSurveys(event.projectId, event.moduleSlug)
        .listen(
          (surveys) {
            if (!emit.isDone) {
              add(const SurveysUpdated());
              emit(state.copyWith(surveys: surveys, isLoading: false));
            }
          },
          onError: (error) {
            if (!emit.isDone) {
              emit(
                state.copyWith(
                  isLoading: false,
                  errorMessage: error.toString(),
                ),
              );
            }
          },
        );
  }

  Future<void> _onSurveysUpdated(
    SurveysUpdated event,
    Emitter<SurveyListState> emit,
  ) async {}

  Future<void> _onFilterSurveys(
    FilterSurveys event,
    Emitter<SurveyListState> emit,
  ) async {
    emit(state.copyWith(filter: event.filter));
  }

  Future<void> _onSearchSurveys(
    SearchSurveys event,
    Emitter<SurveyListState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query));
  }

  Future<void> _onFilterByDateRange(
    FilterByDateRange event,
    Emitter<SurveyListState> emit,
  ) async {
    emit(state.copyWith(dateRange: event.dateRange));
  }

  @override
  Future<void> close() {
    _surveysSubscription?.cancel();
    return super.close();
  }
}
