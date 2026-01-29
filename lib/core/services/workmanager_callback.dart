import 'package:workmanager/workmanager.dart';
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// WorkManager callback handler for background sync tasks
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // Check network connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return Future.value(true); // Skip if offline
      }

      // Initialize database
      final database = AppDatabase();

      // Query pending surveys (uploadStatus 0 = pending, 3 = failed)
      final pendingSurveys =
          await (database.select(database.surveyResponses)..where(
            (tbl) => tbl.uploadStatus.isIn([0, 3]) & tbl.isDraft.equals(false),
          )).get();

      if (pendingSurveys.isEmpty) {
        await database.close();
        return Future.value(true);
      }

      // TODO: Implement actual upload logic here
      // This requires access to DioClient and FileUploadService
      // which need to be initialized within the background isolate
      // For now, we just log that we found pending surveys

      print('[WorkManager] Found ${pendingSurveys.length} pending surveys');

      await database.close();
      return Future.value(true);
    } catch (e) {
      print('[WorkManager] Error in background task: $e');
      return Future.value(false);
    }
  });
}
