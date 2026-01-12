import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../widgets/survey_filter_sheet.dart';

abstract class SurveyListEvent extends Equatable {
  const SurveyListEvent();

  @override
  List<Object?> get props => [];
}

class LoadSurveys extends SurveyListEvent {
  final String projectId;
  final String moduleSlug;

  const LoadSurveys({required this.projectId, required this.moduleSlug});

  @override
  List<Object?> get props => [projectId, moduleSlug];
}

class SurveysUpdated extends SurveyListEvent {
  const SurveysUpdated();
}

class FilterSurveys extends SurveyListEvent {
  final SurveyFilterType filter;

  const FilterSurveys(this.filter);

  @override
  List<Object?> get props => [filter];
}

class SearchSurveys extends SurveyListEvent {
  final String query;

  const SearchSurveys(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterByDateRange extends SurveyListEvent {
  final DateTimeRange? dateRange;

  const FilterByDateRange(this.dateRange);

  @override
  List<Object?> get props => [dateRange];
}

class UploadSurveys extends SurveyListEvent {
  final List<String> surveyIds;

  const UploadSurveys(this.surveyIds);

  @override
  List<Object?> get props => [surveyIds];
}

class UpdateSurveyUploadStatus extends SurveyListEvent {
  final String surveyId;
  final String status;
  final String? error;

  const UpdateSurveyUploadStatus({
    required this.surveyId,
    required this.status,
    this.error,
  });

  @override
  List<Object?> get props => [surveyId, status, error];
}
