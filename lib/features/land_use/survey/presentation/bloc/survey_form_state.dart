import 'package:equatable/equatable.dart';
import '../../../../../shared/models/questionnaire.dart';

class SurveyFormState extends Equatable {
  final QuestionnaireDetail? questionnaireDetail;
  final Map<String, Map<String, dynamic>> formDataByFormSlug;
  final String? currentSurveyId;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final String? successMessage;

  const SurveyFormState({
    this.questionnaireDetail,
    this.formDataByFormSlug = const {},
    this.currentSurveyId,
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
    this.successMessage,
  });

  factory SurveyFormState.initial() {
    return const SurveyFormState();
  }

  SurveyFormState copyWith({
    QuestionnaireDetail? questionnaireDetail,
    Map<String, Map<String, dynamic>>? formDataByFormSlug,
    String? currentSurveyId,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return SurveyFormState(
      questionnaireDetail: questionnaireDetail ?? this.questionnaireDetail,
      formDataByFormSlug:
          formDataByFormSlug != null
              ? Map.from(formDataByFormSlug)
              : Map.from(this.formDataByFormSlug),
      currentSurveyId: currentSurveyId ?? this.currentSurveyId,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
    questionnaireDetail,
    formDataByFormSlug,
    currentSurveyId,
    isLoading,
    isSaving,
    errorMessage,
    successMessage,
  ];
}
