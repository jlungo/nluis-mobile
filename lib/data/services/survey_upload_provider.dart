import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../local/draft_provider.dart';
import 'survey_upload_service.dart';

/// Provider for the SurveyUploadService
final surveyUploadServiceProvider = Provider<SurveyUploadService>((ref) {
  final database = ref.watch(databaseProvider);
  final dioClient = ref.watch(dioClientProvider);

  return SurveyUploadService(database: database, dioClient: dioClient);
});

/// State for tracking upload progress across surveys
class UploadProgressState {
  final Map<String, double> progress; // survey -> progress (0.0 to 1.0)
  final Map<String, String>
  status; // survey -> status (uploading, uploaded, failed)
  final bool isUploading;
  final int totalCount;
  final int completedCount;

  const UploadProgressState({
    this.progress = const {},
    this.status = const {},
    this.isUploading = false,
    this.totalCount = 0,
    this.completedCount = 0,
  });

  UploadProgressState copyWith({
    Map<String, double>? progress,
    Map<String, String>? status,
    bool? isUploading,
    int? totalCount,
    int? completedCount,
  }) {
    return UploadProgressState(
      progress: progress ?? this.progress,
      status: status ?? this.status,
      isUploading: isUploading ?? this.isUploading,
      totalCount: totalCount ?? this.totalCount,
      completedCount: completedCount ?? this.completedCount,
    );
  }

  double get overallProgress {
    if (totalCount == 0) return 0.0;
    return completedCount / totalCount;
  }
}

/// Notifier for managing upload progress state
class UploadProgressNotifier extends StateNotifier<UploadProgressState> {
  UploadProgressNotifier() : super(const UploadProgressState());

  void startUpload(int totalCount) {
    state = state.copyWith(
      isUploading: true,
      totalCount: totalCount,
      completedCount: 0,
      progress: {},
      status: {},
    );
  }

  void updateProgress(String questionnaireSlug, double progress) {
    final newProgress = Map<String, double>.from(state.progress);
    newProgress[questionnaireSlug] = progress;
    state = state.copyWith(progress: newProgress);
  }

  void updateStatus(String questionnaireSlug, String status) {
    final newStatus = Map<String, String>.from(state.status);
    newStatus[questionnaireSlug] = status;

    int completed = state.completedCount;
    if (status == 'uploaded' || status == 'failed') {
      completed++;
    }

    state = state.copyWith(status: newStatus, completedCount: completed);
  }

  void finishUpload() {
    state = state.copyWith(isUploading: false);
  }

  void reset() {
    state = const UploadProgressState();
  }
}

/// Provider for upload progress state
final uploadProgressProvider =
    StateNotifierProvider<UploadProgressNotifier, UploadProgressState>((ref) {
      return UploadProgressNotifier();
    });
