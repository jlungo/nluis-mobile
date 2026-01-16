import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/survey_stats_repository.dart';
import 'survey_stats_event.dart';
import 'survey_stats_state.dart';

class SurveyStatsBloc extends Bloc<SurveyStatsEvent, SurveyStatsState> {
  final SurveyStatsRepository repository;
  StreamSubscription? _statsSubscription;

  SurveyStatsBloc({required this.repository})
    : super(SurveyStatsState.initial()) {
    on<LoadSurveyStats>(_onLoadSurveyStats);
    on<SurveyStatsUpdated>(_onSurveyStatsUpdated);
  }

  Future<void> _onLoadSurveyStats(
    LoadSurveyStats event,
    Emitter<SurveyStatsState> emit,
  ) async {
    await _statsSubscription?.cancel();

    _statsSubscription = repository
        .watchSurveyStats(event.moduleSlug)
        .listen(
          (stats) {
            if (!emit.isDone) {
              add(const SurveyStatsUpdated());
              emit(state.copyWith(stats: stats, isLoading: false));
            }
          },
          onError: (error) {
            if (!emit.isDone) {
              emit(state.copyWith(isLoading: false));
            }
          },
        );
  }

  Future<void> _onSurveyStatsUpdated(
    SurveyStatsUpdated event,
    Emitter<SurveyStatsState> emit,
  ) async {}

  @override
  Future<void> close() {
    _statsSubscription?.cancel();
    return super.close();
  }
}
