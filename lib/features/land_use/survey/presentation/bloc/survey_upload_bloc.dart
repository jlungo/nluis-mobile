import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/survey_upload_repository.dart';
import 'survey_upload_event.dart';
import 'survey_upload_state.dart';

class SurveyUploadBloc extends Bloc<SurveyUploadEvent, SurveyUploadState> {
  final SurveyUploadRepository repository;

  SurveyUploadBloc({required this.repository})
      : super(SurveyUploadState.initial()) {
    on<UploadSurvey>(_onUploadSurvey);
    on<UploadMultipleSurveys>(_onUploadMultipleSurveys);
  }

  Future<void> _onUploadSurvey(
    UploadSurvey event,
    Emitter<SurveyUploadState> emit,
  ) async {
    emit(state.copyWith(
      isUploading: true,
      uploadProgress: {event.surveyId: 0.0},
      clearError: true,
      clearSuccess: true,
    ));

    final result = await repository.uploadSurvey(event.surveyId);

    result.fold(
      (failure) => emit(state.copyWith(
        isUploading: false,
        errorMessage: failure.toString(),
        uploadProgress: {event.surveyId: 0.0},
      )),
      (_) => emit(state.copyWith(
        isUploading: false,
        successMessage: 'Dodoso limepakiwa!',
        uploadProgress: {event.surveyId: 1.0},
      )),
    );
  }

  Future<void> _onUploadMultipleSurveys(
    UploadMultipleSurveys event,
    Emitter<SurveyUploadState> emit,
  ) async {
    emit(state.copyWith(
      isUploading: true,
      clearError: true,
      clearSuccess: true,
    ));

    final result = await repository.uploadMultipleSurveys(event.surveyIds);

    result.fold(
      (failure) => emit(state.copyWith(
        isUploading: false,
        errorMessage: failure.toString(),
      )),
      (_) => emit(state.copyWith(
        isUploading: false,
        successMessage: '${event.surveyIds.length} dodoso zimepakiwa!',
      )),
    );
  }
}
