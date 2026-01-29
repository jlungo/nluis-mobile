import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../../core/network/dio_client.dart';
import '../../core/network/network_info.dart';
import '../local/database.dart';
import 'survey_upload_service.dart';

const String uploadTaskName = 'uploadPendingQuestionnaires';
const String uploadTaskTag = 'questionnaire-upload';

/// Initialize WorkManager and register the callback dispatcher
void initializeWorkManager() {
  Workmanager().initialize(callbackDispatcher);
}

/// The entry point for background tasks - must be a top-level function
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      switch (task) {
        case uploadTaskName:
          await UploadWorker.uploadPendingQuestionnaires(
            moduleSlug: inputData?['moduleSlug'] as String?,
            projectId: inputData?['projectId'] as String?,
          );
          break;
        case Workmanager.iOSBackgroundTask:
          await UploadWorker.uploadPendingQuestionnaires();
          break;
      }
      return true;
    } catch (e) {
      debugPrint('Background upload task failed: $e');
      return false;
    }
  });
}

/// Worker class for handling background uploads
class UploadWorker {
  /// Schedule a one-off upload task
  static void scheduleUpload({String? moduleSlug, String? projectId}) {
    final inputData = <String, dynamic>{};
    if (moduleSlug != null) inputData['moduleSlug'] = moduleSlug;
    if (projectId != null) inputData['projectId'] = projectId;

    Workmanager().registerOneOffTask(
      'uploadTask_${DateTime.now().millisecondsSinceEpoch}',
      uploadTaskName,
      tag: uploadTaskTag,
      constraints: Constraints(networkType: NetworkType.connected),
      inputData: inputData,
      existingWorkPolicy: ExistingWorkPolicy.keep,
    );
  }

  /// Schedule periodic upload task (minimum 15 minutes on Android)
  static void schedulePeriodicUpload({
    Duration frequency = const Duration(minutes: 15),
  }) {
    Workmanager().registerPeriodicTask(
      'uploadTaskPeriodic',
      uploadTaskName,
      tag: uploadTaskTag,
      frequency: frequency,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }

  /// Cancel all scheduled upload tasks
  static void cancelAllUploads() {
    Workmanager().cancelByTag(uploadTaskTag);
  }

  /// Execute the upload task (called from background or foreground)
  static Future<void> uploadPendingQuestionnaires({
    String? moduleSlug,
    String? projectId,
  }) async {
    final database = AppDatabase();

    // Initialize DioClient dependencies for background context
    const secureStorage = FlutterSecureStorage();
    final sharedPreferences = await SharedPreferences.getInstance();
    final networkInfo = NetworkInfoImpl(Connectivity());

    final dioClient = DioClient(
      // secureStorage: secureStorage,
      networkInfo: networkInfo,
      sharedPreferences: sharedPreferences,
    );

    try {
      final uploadService = SurveyUploadService(
        database: database,
        dioClient: dioClient,
      );

      final result = await uploadService.uploadPendingQuestionnaires(
        moduleSlug: moduleSlug,
        projectId: projectId,
        onProgress: (slug, progress) {
          debugPrint(
            'Upload progress for $slug: ${(progress * 100).toStringAsFixed(1)}%',
          );
        },
        onStatusChange: (slug, status) {
          debugPrint('Upload status for $slug: $status');
        },
      );

      debugPrint(
        'Background upload completed: ${result.successCount} succeeded, ${result.failureCount} failed',
      );
    } finally {
      await database.close();
    }
  }
}
