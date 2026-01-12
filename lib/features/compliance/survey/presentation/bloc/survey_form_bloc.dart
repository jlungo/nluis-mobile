import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/services/draft_service.dart';
import '../../../../../shared/utils/form_progress_calculator.dart';
import '../../domain/repositories/questionnaire_detail_repository.dart';
import 'survey_form_event.dart';
import 'survey_form_state.dart';

class SurveyFormBloc extends Bloc<SurveyFormEvent, SurveyFormState> {
  final QuestionnaireDetailRepository questionnaireDetailRepository;
  final DraftService draftService;

  SurveyFormBloc({
    required this.questionnaireDetailRepository,
    required this.draftService,
  }) : super(SurveyFormState.initial()) {
    on<LoadQuestionnaireDetail>(_onLoadQuestionnaireDetail);
    on<LoadExistingDraft>(_onLoadExistingDraft);
    on<UpdateFormField>(_onUpdateFormField);
    on<SaveFormDraft>(_onSaveFormDraft);
    on<CompleteSurvey>(_onCompleteSurvey);
  }

  Future<void> _onLoadQuestionnaireDetail(
    LoadQuestionnaireDetail event,
    Emitter<SurveyFormState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await questionnaireDetailRepository.getQuestionnaireDetail(
      event.questionnaireSlug,
    );

    await result.fold(
      (failure) async => emit(
        state.copyWith(isLoading: false, errorMessage: failure.toString()),
      ),
      (detail) async {
        Map<String, Map<String, dynamic>> loadedFormData = {};
        String? loadedSurveyId = event.surveyId;

        if (event.surveyId != null) {
          try {
            loadedFormData = await draftService.loadSurveyData(
              surveyId: event.surveyId!,
            );
          } catch (e) {
            // Error loading draft data - continue with empty form
          }
        }

        emit(
          state.copyWith(
            isLoading: false,
            questionnaireDetail: detail,
            formDataByFormSlug: loadedFormData,
            currentSurveyId: loadedSurveyId,
          ),
        );
      },
    );
  }

  Future<void> _onLoadExistingDraft(
    LoadExistingDraft event,
    Emitter<SurveyFormState> emit,
  ) async {
    try {
      final draftData = await draftService.getDraftByProjectAndQuestionnaire(
        projectId: event.projectId,
        questionnaireSlug: event.questionnaireSlug,
      );

      if (draftData.isNotEmpty) {
        final surveyId = draftData['surveyId'] as String?;
        final formData =
            draftData['formData'] as Map<String, Map<String, dynamic>>? ?? {};

        emit(
          state.copyWith(
            currentSurveyId: surveyId,
            formDataByFormSlug: formData,
            successMessage: 'Draft imehifadhiwa imepakiwa',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Hitilafu ya kupakia draft: $e'));
    }
  }

  void _onUpdateFormField(
    UpdateFormField event,
    Emitter<SurveyFormState> emit,
  ) {
    final updatedFormData = Map<String, Map<String, dynamic>>.from(
      state.formDataByFormSlug,
    );

    final formData = updatedFormData.putIfAbsent(
      event.formSlug,
      () => <String, dynamic>{},
    );

    if (_isMeaningfulValue(event.value)) {
      formData[event.fieldId] = event.value;
    } else {
      formData.remove(event.fieldId);
    }

    if (formData.isEmpty) {
      updatedFormData.remove(event.formSlug);
    }

    emit(
      state.copyWith(
        formDataByFormSlug: updatedFormData,
        clearSuccess: true,
        clearError: true,
      ),
    );
  }

  Future<void> _onSaveFormDraft(
    SaveFormDraft event,
    Emitter<SurveyFormState> emit,
  ) async {
    if (state.formDataByFormSlug.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: 'Jaza angalau sehemu moja kabla ya kuhifadhi.',
        ),
      );
      return;
    }

    emit(state.copyWith(isSaving: true, clearError: true, clearSuccess: true));

    try {
      String? latestSurveyId = state.currentSurveyId;

      for (final entry in state.formDataByFormSlug.entries) {
        latestSurveyId = await draftService.saveDraft(
          projectId: event.projectId,
          questionnaireSlug: event.questionnaireSlug,
          formSlug: entry.key,
          formData: entry.value,
          moduleSlug: event.moduleSlug,
          surveyId: latestSurveyId,
        );
      }

      emit(
        state.copyWith(
          isSaving: false,
          currentSurveyId: latestSurveyId,
          successMessage: 'Dodoso limehifadhiwa kama draft',
        ),
      );
    } catch (e) {
      emit(state.copyWith(isSaving: false, errorMessage: 'Hitilafu: $e'));
    }
  }

  Future<void> _onCompleteSurvey(
    CompleteSurvey event,
    Emitter<SurveyFormState> emit,
  ) async {
    // Auto-save draft first if not yet saved
    if (state.currentSurveyId == null) {
      if (state.formDataByFormSlug.isEmpty) {
        emit(
          state.copyWith(
            errorMessage: 'Jaza angalau sehemu moja kabla ya kuhifadhi.',
            clearError: false,
          ),
        );
        return;
      }

      emit(state.copyWith(isSaving: true, clearError: true));

      try {
        String? latestSurveyId;

        for (final entry in state.formDataByFormSlug.entries) {
          latestSurveyId = await draftService.saveDraft(
            projectId: event.projectId,
            questionnaireSlug: event.questionnaireSlug,
            formSlug: entry.key,
            formData: entry.value,
            moduleSlug: event.moduleSlug,
            surveyId: latestSurveyId,
          );
        }

        emit(state.copyWith(currentSurveyId: latestSurveyId, isSaving: false));
      } catch (e) {
        emit(
          state.copyWith(
            isSaving: false,
            errorMessage: 'Hitilafu ya kuhifadhi: $e',
          ),
        );
        return;
      }
    }

    // Validate required fields
    if (state.questionnaireDetail != null) {
      final isComplete = FormProgressCalculator.areRequiredFieldsComplete(
        questionnaireDetail: state.questionnaireDetail!,
        formDataByFormSlug: state.formDataByFormSlug,
      );

      if (!isComplete) {
        final incompleteFields =
            FormProgressCalculator.getIncompleteRequiredFields(
              questionnaireDetail: state.questionnaireDetail!,
              formDataByFormSlug: state.formDataByFormSlug,
            );

        emit(
          state.copyWith(
            errorMessage:
                'Tafadhali jaza sehemu zote zinazohitajika: ${incompleteFields.take(3).join(", ")}${incompleteFields.length > 3 ? "..." : ""}',
            clearError: false,
          ),
        );
        return;
      }
    }

    emit(state.copyWith(isSaving: true));

    try {
      final success = await draftService.saveSurvey(
        surveyId: state.currentSurveyId!,
      );

      if (success) {
        emit(state.copyWith(isSaving: false, successMessage: 'complete'));
      } else {
        emit(
          state.copyWith(
            isSaving: false,
            errorMessage: 'Imeshindikana kuhifadhi dodoso',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isSaving: false,
          errorMessage: 'Hitilafu: ${e.toString()}',
        ),
      );
    }
  }

  bool _isMeaningfulValue(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) return value.trim().isNotEmpty;
    if (value is num) return true;
    if (value is DateTime) return true;
    if (value is List) return value.any(_isMeaningfulValue);
    if (value is Map<String, dynamic>) {
      return value.values.any(_isMeaningfulValue);
    }
    return true;
  }
}
