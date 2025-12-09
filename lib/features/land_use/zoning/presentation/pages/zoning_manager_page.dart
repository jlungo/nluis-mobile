import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/widgets/app_drawer.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/action_menu_item.dart';
import '../../../../../shared/utils/snackbar_utils.dart';
import '../../domain/entities/locality_project.dart';
import '../providers/zoning_manager_providers.dart';
import 'locality_features_page.dart';
import '../../domain/entities/zoning_feature.dart';
import '../providers/zoning_providers.dart';
import '../../../../../data/local/draft_provider.dart';

class ZoningManagerPage extends ConsumerStatefulWidget {
  const ZoningManagerPage({super.key});

  @override
  ConsumerState<ZoningManagerPage> createState() => _ZoningManagerPageState();
}

class _ZoningManagerPageState extends ConsumerState<ZoningManagerPage> {
  Future<void> _exportLocalityToCSV(
    BuildContext context,
    String localityId,
    String localityName,
  ) async {
    try {
      final repository = ref.read(zoningRepositoryProvider);
      final features = <ZoningFeature>[];

      // Collect all features from the locality
      // Get draft features
      final draftResult = await repository.getFeaturesByStatus(
        isDraft: true,
        uploaded: false,
      );
      draftResult.fold(
        (failure) => null,
        (draftFeatures) => features.addAll(
          draftFeatures.where((f) => f.localityId == localityId),
        ),
      );

      // Get saved features
      final savedResult = await repository.getFeaturesByStatus(
        isDraft: false,
        uploaded: false,
      );
      savedResult.fold(
        (failure) => null,
        (savedFeatures) => features.addAll(
          savedFeatures.where((f) => f.localityId == localityId),
        ),
      );

      // Get uploaded features
      final uploadedResult = await repository.getFeaturesByStatus(
        uploaded: true,
      );
      uploadedResult.fold(
        (failure) => null,
        (uploadedFeatures) => features.addAll(
          uploadedFeatures.where((f) => f.localityId == localityId),
        ),
      );

      if (features.isEmpty) {
        if (context.mounted) {
          SnackBarUtils.showInfo(context, 'Hakuna vipengele vya kuhamisha');
        }
        return;
      }

      // Create CSV data
      final List<List<dynamic>> csvData = [
        [
          'Locality Project ID',
          'Feature Type',
          'Latitude',
          'Longitude',
          'Is Proposed',
        ],
      ];

      for (final feature in features) {
        for (final coord in feature.coordinates) {
          csvData.add([
            feature.localityId,
            feature.featureType.name,
            coord.latitude,
            coord.longitude,
            feature.isProposed ? 'Yes' : 'No',
          ]);
        }
      }

      // Convert to CSV string
      final csvString = const ListToCsvConverter().convert(csvData);

      // Save to file
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      // Sanitize locality name for filename (remove special characters)
      final sanitizedName =
          localityName
              .replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_')
              .replaceAll(RegExp(r'_+'), '_')
              .trim();
      final file = File('${directory.path}/${sanitizedName}_$timestamp.csv');
      await file.writeAsString(csvString);

      // Share the file
      final xFile = XFile(file.path);
      await Share.shareXFiles([xFile], subject: 'Zoning Features Export');

      if (context.mounted) {
        SnackBarUtils.showSuccess(
          context,
          'Features ${features.length} exported successfully',
        );
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarUtils.showError(context, 'Export error: $e');
      }
    }
  }

  Future<void> _uploadLocality(BuildContext context, String localityId) async {
    try {
      final repository = ref.read(zoningRepositoryProvider);
      final zoningApi = ref.read(zoningApiServiceProvider);

      // Get saved (not draft, not uploaded) features for this locality
      final savedResult = await repository.getFeaturesByStatus(
        isDraft: false,
        uploaded: false,
      );

      final savedFeatures = savedResult.fold(
        (failure) => <ZoningFeature>[],
        (features) =>
            features.where((f) => f.localityId == localityId).toList(),
      );

      if (savedFeatures.isEmpty) {
        if (context.mounted) {
          SnackBarUtils.showInfo(
            context,
            'No saved features to upload for this locality',
          );
        }
        return;
      }

      // Show loading
      if (context.mounted) {
        SnackBarUtils.showInfo(
          context,
          'Uploading ${savedFeatures.length} features...',
        );
      }

      // Upload features using bulk API
      await zoningApi.bulkUploadZones(features: savedFeatures);

      // Mark features as uploaded in local database
      final database = ref.read(databaseProvider);
      for (final feature in savedFeatures) {
        final updatedFeature = feature.copyWith(
          uploaded: true,
          uploadedAt: DateTime.now(),
        );
        await repository.updateFeature(updatedFeature);

        // Delete feature history after successful upload
        await (database.delete(database.zoningFeatureHistory)
          ..where((tbl) => tbl.featureId.equals(feature.clientUuid))).go();
      }

      // Refresh locality projects list
      ref.invalidate(localityProjectsProvider);

      if (context.mounted) {
        SnackBarUtils.showSuccess(
          context,
          '${savedFeatures.length} features uploaded successfully',
        );
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarUtils.showError(context, 'Upload failed: ${e.toString()}');
      }
    }
  }

  void _navigateToFeatures(BuildContext context, LocalityProject project) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LocalityFeaturesPage(localityProject: project),
      ),
    );
  }

  void _showLocalityActions(
    BuildContext context,
    LocalityProject project,
    String status,
  ) {
    if (status == 'saved') {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder:
            (context) => _LocalityActionsSheet(
              project: project,
              onViewFeatures: () {
                Navigator.pop(context);
                _navigateToFeatures(context, project);
              },
              onExportCSV: () {
                Navigator.pop(context);
                _exportLocalityToCSV(
                  context,
                  project.localityId,
                  project.localityName,
                );
              },
              onUpload: () {
                Navigator.pop(context);
                _uploadLocality(context, project.localityId);
              },
            ),
      );
    } else {
      _navigateToFeatures(context, project);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localityProjectsAsync = ref.watch(localityProjectsProvider);

    // Calculate total counts
    final totalCounts = localityProjectsAsync.when(
      data:
          (projects) => (
            projects.fold(0, (sum, p) => sum + p.draftCount),
            projects.fold(0, (sum, p) => sum + p.savedCount),
            projects.fold(0, (sum, p) => sum + p.uploadedCount),
          ),
      loading: () => (0, 0, 0),
      error: (error, stack) => (0, 0, 0),
    );

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: const AppDrawer(),
        appBar: CustomAppBar(
          title: 'Zoning',
          bottom: _ZoningTabBar(counts: totalCounts),
        ),
        body: localityProjectsAsync.when(
          data:
              (projects) => TabBarView(
                children: [
                  _LocalityProjectsList(
                    projects: projects,
                    filterStatus: 'draft',
                    onProjectTap:
                        (context, project) =>
                            _showLocalityActions(context, project, 'draft'),
                  ),
                  _LocalityProjectsList(
                    projects: projects,
                    filterStatus: 'saved',
                    onProjectTap:
                        (context, project) =>
                            _showLocalityActions(context, project, 'saved'),
                  ),
                  _LocalityProjectsList(
                    projects: projects,
                    filterStatus: 'uploaded',
                    onProjectTap:
                        (context, project) =>
                            _showLocalityActions(context, project, 'uploaded'),
                  ),
                ],
              ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}

class _ZoningTabBar extends StatelessWidget implements PreferredSizeWidget {
  final (int draft, int saved, int uploaded) counts;

  const _ZoningTabBar({required this.counts});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget buildTab(String label, int count, Color color) {
      return Tab(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMd,
            vertical: AppConstants.spacingXs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              _ModernBadge(count: count, color: color, isDark: isDark),
            ],
          ),
        ),
      );
    }

    return TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.center,
      labelColor: isDark ? AppColors.darkPrimary : AppColors.primary,
      unselectedLabelColor:
          isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
      dividerColor: isDark ? AppColors.darkDivider : AppColors.divider,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingSm),
      tabs: [
        buildTab('Rasimu', counts.$1, AppColors.warning),
        buildTab('Zilizohifadhiwa', counts.$2, AppColors.info),
        buildTab('Zimepakiwa', counts.$3, AppColors.success),
      ],
    );
  }
}

class _ModernBadge extends StatelessWidget {
  final int count;
  final Color color;
  final bool isDark;

  const _ModernBadge({
    required this.count,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 24),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: isDark ? 0.9 : 1.0),
            color.withValues(alpha: isDark ? 0.7 : 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        count.toString(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          height: 1.2,
        ),
      ),
    );
  }
}

class _LocalityProjectsList extends StatelessWidget {
  final List<LocalityProject> projects;
  final String filterStatus;
  final Function(BuildContext, LocalityProject) onProjectTap;

  const _LocalityProjectsList({
    required this.projects,
    required this.filterStatus,
    required this.onProjectTap,
  });

  @override
  Widget build(BuildContext context) {
    // Filter projects that have features in this status
    final filteredProjects =
        projects.where((project) {
          switch (filterStatus) {
            case 'draft':
              return project.draftCount > 0;
            case 'saved':
              return project.savedCount > 0;
            case 'uploaded':
              return project.uploadedCount > 0;
            default:
              return false;
          }
        }).toList();

    if (filteredProjects.isEmpty) {
      return _ZoningEmpty(message: _getEmptyMessage());
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Trigger refresh
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        itemCount: filteredProjects.length,
        itemBuilder: (context, index) {
          final project = filteredProjects[index];
          return _LocalityProjectCard(
            project: project,
            status: filterStatus,
            onTap: () => onProjectTap(context, project),
          );
        },
      ),
    );
  }

  String _getEmptyMessage() {
    switch (filterStatus) {
      case 'draft':
        return 'Hakuna miradi yenye rasimu za vipengele.';
      case 'saved':
        return 'Hakuna miradi yenye vipengele vilivyohifadhiwa.';
      case 'uploaded':
        return 'Hakuna miradi yenye vipengele vilivyopakiwa.';
      default:
        return 'Hakuna miradi yenye vipengele.';
    }
  }
}

class _LocalityProjectCard extends StatelessWidget {
  final LocalityProject project;
  final String status;
  final VoidCallback onTap;

  const _LocalityProjectCard({
    required this.project,
    required this.status,
    required this.onTap,
  });

  int _getCount() {
    switch (status) {
      case 'draft':
        return project.draftCount;
      case 'saved':
        return project.savedCount;
      case 'uploaded':
        return project.uploadedCount;
      default:
        return 0;
    }
  }

  Color _getStatusColor() {
    switch (status) {
      case 'draft':
        return AppColors.warning;
      case 'saved':
        return AppColors.info;
      case 'uploaded':
        return AppColors.success;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final count = _getCount();
    final color = _getStatusColor();

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Row(
            children: [
              // Locality icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.location_city, color: color, size: 28),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              // Locality details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.localityName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$count ${count == 1 ? "feature" : "features"}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                      ),
                    ),
                    if (_shouldShowTimestamp()) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            _getTimestampIcon(),
                            size: 14,
                            color:
                                isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getTimestampText(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // Badge
              Container(
                constraints: const BoxConstraints(minWidth: 40),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  count.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingSm),
              Icon(
                Icons.chevron_right,
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _shouldShowTimestamp() {
    return (status == 'draft' || status == 'saved') &&
            project.lastUpdatedAt != null ||
        status == 'uploaded' && project.uploadedAt != null;
  }

  IconData _getTimestampIcon() {
    if (status == 'uploaded') {
      return Icons.cloud_upload_rounded;
    }
    return Icons.update_rounded;
  }

  String _getTimestampText() {
    final DateTime? timestamp =
        status == 'uploaded' ? project.uploadedAt : project.lastUpdatedAt;

    if (timestamp == null) return '';

    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return status == 'uploaded' ? 'Uploaded just now' : 'Updated just now';
    } else if (difference.inHours < 1) {
      return status == 'uploaded'
          ? 'Uploaded ${difference.inMinutes}m ago'
          : 'Updated ${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return status == 'uploaded'
          ? 'Uploaded ${difference.inHours}h ago'
          : 'Updated ${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return status == 'uploaded'
          ? 'Uploaded ${difference.inDays}d ago'
          : 'Updated ${difference.inDays}d ago';
    } else {
      return status == 'uploaded'
          ? 'Uploaded ${timestamp.day}/${timestamp.month}/${timestamp.year}'
          : 'Updated ${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

class _ZoningEmpty extends StatelessWidget {
  final String message;

  const _ZoningEmpty({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacingLg),
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? AppColors.darkPrimary.withValues(alpha: 0.1)
                            : AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.map_outlined,
                    size: 64,
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLg),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingXl,
                  ),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LocalityActionsSheet extends StatelessWidget {
  final LocalityProject project;
  final VoidCallback onViewFeatures;
  final VoidCallback onExportCSV;
  final VoidCallback onUpload;

  const _LocalityActionsSheet({
    required this.project,
    required this.onViewFeatures,
    required this.onExportCSV,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppConstants.radiusXl),
          topRight: Radius.circular(AppConstants.radiusXl),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppConstants.spacingMd),
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkDivider : AppColors.divider,
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingLg),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingLg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.localityName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color:
                          isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingSm),
                  Text(
                    'Chagua kitendo',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.spacingLg),
            // View Features action
            ActionMenuItem(
              icon: Icons.list_alt,
              label: 'View Features',
              description: 'Angalia vipengele vya eneo hili',
              onTap: onViewFeatures,
            ),
            // Export CSV action
            ActionMenuItem(
              icon: Icons.download,
              label: 'Export CSV',
              description: 'Hamisha vipengele kwa CSV',
              onTap: onExportCSV,
            ),
            // Upload Zones action
            ActionMenuItem(
              icon: Icons.cloud_upload,
              label: 'Upload Zones',
              description: 'Pakia vipengele kwenye seva',
              onTap: onUpload,
            ),
            const SizedBox(height: AppConstants.spacingLg),
          ],
        ),
      ),
    );
  }
}
