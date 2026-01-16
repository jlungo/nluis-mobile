import 'package:equatable/equatable.dart';

class SurveyUploadState extends Equatable {
  final bool isUploading;
  final String? errorMessage;
  final String? successMessage;
  final Map<String, double> uploadProgress;

  const SurveyUploadState({
    required this.isUploading,
    this.errorMessage,
    this.successMessage,
    required this.uploadProgress,
  });

  factory SurveyUploadState.initial() {
    return const SurveyUploadState(
      isUploading: false,
      uploadProgress: {},
    );
  }

  SurveyUploadState copyWith({
    bool? isUploading,
    String? errorMessage,
    String? successMessage,
    Map<String, double>? uploadProgress,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return SurveyUploadState(
      isUploading: isUploading ?? this.isUploading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }

  @override
  List<Object?> get props =>
      [isUploading, errorMessage, successMessage, uploadProgress];
}
