import 'package:equatable/equatable.dart';

abstract class SurveyUploadEvent extends Equatable {
  const SurveyUploadEvent();

  @override
  List<Object?> get props => [];
}

class UploadSurvey extends SurveyUploadEvent {
  final String surveyId;

  const UploadSurvey(this.surveyId);

  @override
  List<Object?> get props => [surveyId];
}

class UploadMultipleSurveys extends SurveyUploadEvent {
  final List<String> surveyIds;

  const UploadMultipleSurveys(this.surveyIds);

  @override
  List<Object?> get props => [surveyIds];
}
