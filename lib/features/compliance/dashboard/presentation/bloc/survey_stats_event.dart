import 'package:equatable/equatable.dart';

abstract class SurveyStatsEvent extends Equatable {
  const SurveyStatsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSurveyStats extends SurveyStatsEvent {
  final String moduleSlug;

  const LoadSurveyStats(this.moduleSlug);

  @override
  List<Object?> get props => [moduleSlug];
}

class SurveyStatsUpdated extends SurveyStatsEvent {
  const SurveyStatsUpdated();
}
