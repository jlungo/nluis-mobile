import 'package:equatable/equatable.dart';

abstract class SurveyFormEvent extends Equatable {
  const SurveyFormEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuestionnaireDetail extends SurveyFormEvent {
  final String questionnaireSlug;
  final String? surveyId;

  const LoadQuestionnaireDetail(this.questionnaireSlug, {this.surveyId});

  @override
  List<Object?> get props => [questionnaireSlug, surveyId];
}

class LoadExistingDraft extends SurveyFormEvent {
  final String projectId;
  final String questionnaireSlug;

  const LoadExistingDraft({
    required this.projectId,
    required this.questionnaireSlug,
  });

  @override
  List<Object?> get props => [projectId, questionnaireSlug];
}

class UpdateFormField extends SurveyFormEvent {
  final String formSlug;
  final String fieldId;
  final dynamic value;

  const UpdateFormField({
    required this.formSlug,
    required this.fieldId,
    required this.value,
  });

  @override
  List<Object?> get props => [formSlug, fieldId, value];
}

class SaveFormDraft extends SurveyFormEvent {
  final String projectId;
  final String questionnaireSlug;
  final String moduleSlug;

  const SaveFormDraft({
    required this.projectId,
    required this.questionnaireSlug,
    required this.moduleSlug,
  });

  @override
  List<Object?> get props => [projectId, questionnaireSlug, moduleSlug];
}

class CompleteSurvey extends SurveyFormEvent {
  final String projectId;
  final String questionnaireSlug;
  final String moduleSlug;

  const CompleteSurvey({
    required this.projectId,
    required this.questionnaireSlug,
    required this.moduleSlug,
  });

  @override
  List<Object?> get props => [projectId, questionnaireSlug, moduleSlug];
}
