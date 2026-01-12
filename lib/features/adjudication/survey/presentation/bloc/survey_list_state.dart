import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../../../shared/models/survey_item.dart';
import '../widgets/survey_filter_sheet.dart';

class SurveyListState extends Equatable {
  final List<SurveyItem> surveys;
  final bool isLoading;
  final bool isUploading;
  final String? errorMessage;
  final SurveyFilterType filter;
  final String searchQuery;
  final DateTimeRange? dateRange;

  const SurveyListState({
    required this.surveys,
    this.isLoading = false,
    this.isUploading = false,
    this.errorMessage,
    this.filter = SurveyFilterType.all,
    this.searchQuery = '',
    this.dateRange,
  });

  factory SurveyListState.initial() {
    return const SurveyListState(surveys: [], isLoading: true);
  }

  List<SurveyItem> get filteredSurveys {
    var result = surveys;

    // Apply filter
    switch (filter) {
      case SurveyFilterType.drafts:
        result = result.where((s) => s.isDraft).toList();
        break;
      case SurveyFilterType.completed:
        result = result.where((s) => !s.isDraft && !s.isDirty).toList();
        break;
      case SurveyFilterType.pending:
        result = result.where((s) => !s.isDraft && s.isDirty).toList();
        break;
      case SurveyFilterType.failed:
        result =
            result
                .where((s) => s.uploadStatus == UploadStatus.failure)
                .toList();
        break;
      case SurveyFilterType.all:
        break;
    }

    // Apply search
    if (searchQuery.isNotEmpty) {
      result =
          result
              .where(
                (s) => s.questionnaireName.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ),
              )
              .toList();
    }

    // Apply date range filter
    if (dateRange != null) {
      result =
          result.where((s) {
            try {
              // Parse savedDate (format: "2024-03-18 10:30:45" or "18 Mar 2024")
              final dateStr = s.savedDate.split(' ')[0];
              DateTime surveyDate;

              if (dateStr.contains('-')) {
                // ISO format: 2024-03-18
                surveyDate = DateTime.parse(dateStr);
              } else {
                // Try to parse from full savedDate string
                surveyDate = DateTime.parse(s.savedDate);
              }

              return surveyDate.isAfter(
                    dateRange!.start.subtract(const Duration(days: 1)),
                  ) &&
                  surveyDate.isBefore(
                    dateRange!.end.add(const Duration(days: 1)),
                  );
            } catch (e) {
              // If parsing fails, include the survey
              return true;
            }
          }).toList();
    }

    return result;
  }

  SurveyListState copyWith({
    List<SurveyItem>? surveys,
    bool? isLoading,
    bool? isUploading,
    SurveyFilterType? filter,
    String? searchQuery,
    DateTimeRange? dateRange,
    String? errorMessage,
  }) {
    return SurveyListState(
      surveys: surveys ?? this.surveys,
      isLoading: isLoading ?? this.isLoading,
      isUploading: isUploading ?? this.isUploading,
      filter: filter ?? this.filter,
      searchQuery: searchQuery ?? this.searchQuery,
      dateRange: dateRange ?? this.dateRange,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    surveys,
    isLoading,
    isUploading,
    filter,
    searchQuery,
    dateRange,
    errorMessage,
  ];
}
