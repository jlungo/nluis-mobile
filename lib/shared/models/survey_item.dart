import 'package:equatable/equatable.dart';

enum UploadStatus { idle, uploading, success, failure }

class SurveyItem extends Equatable {
  final String surveyId;
  final String projectId;
  final String questionnaireSlug;
  final String questionnaireName;
  final bool isDraft;
  final bool isDirty;
  final int formsCount;
  final String savedDate;
  final int updatedAt;
  final UploadStatus uploadStatus;
  final String? lastError;

  const SurveyItem({
    required this.surveyId,
    required this.projectId,
    required this.questionnaireSlug,
    required this.questionnaireName,
    required this.isDraft,
    required this.isDirty,
    required this.formsCount,
    required this.savedDate,
    required this.updatedAt,
    this.uploadStatus = UploadStatus.idle,
    this.lastError,
  });

  SurveyItem copyWith({
    String? questionnaireName,
    bool? isDraft,
    bool? isDirty,
    int? formsCount,
    String? savedDate,
    int? updatedAt,
    UploadStatus? uploadStatus,
    String? Function()? lastError,
  }) {
    return SurveyItem(
      surveyId: surveyId,
      projectId: projectId,
      questionnaireSlug: questionnaireSlug,
      questionnaireName: questionnaireName ?? this.questionnaireName,
      isDraft: isDraft ?? this.isDraft,
      isDirty: isDirty ?? this.isDirty,
      formsCount: formsCount ?? this.formsCount,
      savedDate: savedDate ?? this.savedDate,
      updatedAt: updatedAt ?? this.updatedAt,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      lastError: lastError != null ? lastError() : this.lastError,
    );
  }

  @override
  List<Object?> get props => [
    surveyId,
    projectId,
    questionnaireSlug,
    questionnaireName,
    isDraft,
    isDirty,
    formsCount,
    savedDate,
    updatedAt,
    uploadStatus,
    lastError,
  ];
}
