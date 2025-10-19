import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/download_provider.dart';
import '../../features/land_use/dashboard/presentation/providers/project_providers.dart';
import '../models/project.dart';
import '../theme/app_colors.dart';
import 'dialog_utils.dart';

/// Reusable handler for project actions (download, upload, etc.)
/// Use this in any page that needs to handle project downloads
class ProjectActionHandler {
  final BuildContext context;
  final WidgetRef ref;

  ProjectActionHandler(this.context, this.ref);

  /// Shows a snackbar with a message
  void _showSnackBar(String message, [Color? backgroundColor]) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 30),
        backgroundColor: backgroundColor ?? AppColors.info,
      ),
    );
  }

  /// Handles downloading project data (questionnaires, forms, fields)
  /// Shows loading dialog and snackbar feedback
  Future<void> downloadProject(Project project, bool isOnline) async {
    // Check if online
    if (!isOnline) {
      _showSnackBar(
        'Mtandao haupatikani. Tafadhali washa mtandao ili kupakua.',
        AppColors.error,
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

      print('Download result: ${result.message}');

      // Hide loading dialog
      if (context.mounted) {
        await DialogUtils.hideLoading(context);

        // Show result
        if (result.success) {
          _showSnackBar(result.message, AppColors.success);
          // Refresh the projects list to update UI
          ref.invalidate(assignedProjectsProvider);
        } else {
          _showSnackBar(result.message, AppColors.error);
        }
      }
    } catch (e) {
      // Hide loading dialog
      if (context.mounted) {
        await DialogUtils.hideLoading(context);
        _showSnackBar('Hitilafu: $e', AppColors.error);
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
      _showSnackBar(
        'Mradi huu haukupakuliwa. Tafadhali washa mtandao ili kuupakua kwanza.',
        AppColors.error,
      );
      return false;
    }

    return true;
  }
}
