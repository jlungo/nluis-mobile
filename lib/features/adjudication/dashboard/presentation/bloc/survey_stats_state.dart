import 'package:equatable/equatable.dart';
import '../../domain/entities/survey_dashboard_stats.dart';

class SurveyStatsState extends Equatable {
  final SurveyDashboardStats stats;
  final bool isLoading;

  const SurveyStatsState({
    required this.stats,
    this.isLoading = false,
  });

  factory SurveyStatsState.initial() {
    return const SurveyStatsState(
      stats: SurveyDashboardStats(
        total: 0,
        completed: 0,
        drafts: 0,
        uploaded: 0,
      ),
      isLoading: true,
    );
  }

  SurveyStatsState copyWith({
    SurveyDashboardStats? stats,
    bool? isLoading,
  }) {
    return SurveyStatsState(
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [stats, isLoading];
}
