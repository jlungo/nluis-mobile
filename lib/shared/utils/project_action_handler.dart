import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/download_provider.dart';
import '../../features/land_use/dashboard/presentation/providers/project_providers.dart';
import '../models/project.dart';
import 'dialog_utils.dart';
import 'snackbar_utils.dart';

/// Reusable handler for project actions (download, upload, etc.)
/// Use this in any page that needs to handle project downloads
class ProjectActionHandler {
  final BuildContext context;
  final WidgetRef ref;

  ProjectActionHandler(this.context, this.ref);

  /// Handles downloading project data (questionnaires, forms, fields)
  /// Shows loading dialog and snackbar feedback
  Future<void> downloadProject(Project project, bool isOnline) async {
    // Check if online
    if (!isOnline) {
      SnackBarUtils.showError(
        context,
        'Mtandao haupatikani. Tafadhali washa mtandao ili kupakua.',
      );
      return;
    }

    if (!context.mounted) return;

    // Show loading dialog
    DialogUtils.showLoading(
      context,
      message: 'Inapakua dodoso...',
    );

    try {
      final downloadService = ref.read(downloadServiceProvider);
      final result = await downloadService.downloadProjectData(project.id);

      // Hide loading dialog
      if (context.mounted) {
        await DialogUtils.hideLoading(context);

        // Show result
        if (result.success) {
          SnackBarUtils.showSuccess(context, result.message);
          // Refresh the projects list to update UI
          ref.invalidate(assignedProjectsProvider);
        } else {
          SnackBarUtils.showError(context, result.message);
        }
      }
    } catch (e) {
      // Hide loading dialog
      if (context.mounted) {
        await DialogUtils.hideLoading(context);
        SnackBarUtils.showError(context, 'Hitilafu: $e');
      }
    }
  }

  /// Checks if a project is downloaded
  Future<bool> isProjectDownloaded(String projectId) async {
    final downloadService = ref.read(downloadServiceProvider);
    return await downloadService.isProjectDownloaded(projectId);
  }

  /// Handles project tap - checks if downloadable offline
  Future<bool> canAccessProject(Project project, bool isOnline) async {
    if (isOnline) return true; // Always accessible when online

    // Offline - check if downloaded
    final isDownloaded = await isProjectDownloaded(project.id);

    if (!isDownloaded) {
      SnackBarUtils.showError(
        context,
        'Mradi huu haukupakuliwa. Tafadhali washa mtandao ili kuupakua kwanza.',
      );
      return false;
    }

    return true;
  }
}
