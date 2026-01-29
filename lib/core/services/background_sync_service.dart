import 'package:drift/drift.dart';
import 'package:workmanager/workmanager.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'workmanager_callback.dart';
import '../database/app_database.dart';

class BackgroundSyncService {
  static const String syncTaskName = 'survey_sync_task';
  static const String syncTaskTag = 'survey_sync';

  /// Initialize background sync
  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  /// Register periodic sync task (runs every 15 minutes when conditions met)
  static Future<void> registerPeriodicSync() async {
    await Workmanager().registerPeriodicTask(
      syncTaskName,
      syncTaskName,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
      tag: syncTaskTag,
    );
  }

  /// Register one-time sync task
  static Future<void> registerOneTimeSync() async {
    await Workmanager().registerOneOffTask(
      '${syncTaskName}_once',
      syncTaskName,
      constraints: Constraints(networkType: NetworkType.connected),
      tag: syncTaskTag,
    );
  }

  /// Cancel all sync tasks
  static Future<void> cancelAllSync() async {
    await Workmanager().cancelByTag(syncTaskTag);
  }

  /// Check if device is online
  static Future<bool> isOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet);
  }

  /// Get pending surveys for upload
  static Future<List<String>> getPendingSurveys(AppDatabase database) async {
    final pendingResponses =
        await (database.select(database.surveyResponses)..where(
          (tbl) => tbl.dirty.equals(true) & tbl.isDraft.equals(false),
        )).get();

    // Group by survey_id
    final surveyIds = <String>{};
    for (final response in pendingResponses) {
      surveyIds.add(response.surveyId);
    }

    return surveyIds.toList();
  }
}

/// Background task dispatcher
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // Check if online
      final isOnline = await BackgroundSyncService.isOnline();
      if (!isOnline) {
        return Future.value(false); // Retry later
      }

      // Get database instance (you'll need to setup GetIt or similar)
      // This is a simplified version - in production you'd need proper DI
      // final database = GetIt.instance<AppDatabase>();

      // Get pending surveys
      // final pendingSurveys = await BackgroundSyncService.getPendingSurveys(database);

      // Upload each survey
      // for (final surveyId in pendingSurveys) {
      //   try {
      //     await uploadRepository.uploadSurvey(surveyId);
      //   } catch (e) {
      //     // Log error but continue with other surveys
      //   }
      // }

      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  });
}
