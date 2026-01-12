import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/utils/responsive_utils.dart';
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

enum ZoningFilter { all, draft, saved, uploaded }

class ZoningManagerPage extends ConsumerStatefulWidget {
  const ZoningManagerPage({super.key});

  @override
  ConsumerState<ZoningManagerPage> createState() => _ZoningManagerPageState();
}

class _ZoningManagerPageState extends ConsumerState<ZoningManagerPage> {
  ZoningFilter _currentFilter = ZoningFilter.all;
  final Set<String> _selectedLocalityIds = {};
  bool _isUploading = false;

  bool get _isSelectionMode => _selectedLocalityIds.isNotEmpty;

  bool _canSelectLocality(LocalityProject project) {
    // Can only select localities with saved (not draft, not uploaded) features
    return project.savedCount > 0;
  }

  void _toggleSelection(LocalityProject project) {
    setState(() {
      if (_selectedLocalityIds.contains(project.localityId)) {
        _selectedLocalityIds.remove(project.localityId);
      } else {
        _selectedLocalityIds.add(project.localityId);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedLocalityIds.clear();
    });
  }

  void _selectAllEligible(List<LocalityProject> projects) {
    setState(() {
      for (final project in projects) {
        if (_canSelectLocality(project)) {
          _selectedLocalityIds.add(project.localityId);
        }
      }
    });
  }

  Future<void> _uploadSelectedLocalities(List<LocalityProject> allProjects) async {
    final selectedProjects = allProjects
        .where((p) => _selectedLocalityIds.contains(p.localityId))
        .toList();

    if (selectedProjects.isEmpty) return;

    setState(() => _isUploading = true);

    try {
      final repository = ref.read(zoningRepositoryProvider);
      final zoningApi = ref.read(zoningApiServiceProvider);
      final database = ref.read(databaseProvider);

      int totalUploaded = 0;

      for (final project in selectedProjects) {
        // Get saved features for this locality
        final savedResult = await repository.getFeaturesByStatus(
          isDraft: false,
          uploaded: false,
        );

        final savedFeatures = savedResult.fold(
          (failure) => <ZoningFeature>[],
          (features) =>
              features.where((f) => f.localityId == project.localityId).toList(),
        );

        if (savedFeatures.isNotEmpty) {
          // Upload features using bulk API
          await zoningApi.bulkUploadZones(features: savedFeatures);

          // Mark features as uploaded in local database
          for (final feature in savedFeatures) {
            final updatedFeature = feature.copyWith(
              uploaded: true,
              uploadedAt: DateTime.now(),
            );
            await repository.updateFeature(updatedFeature);

            // Delete feature history after successful upload
            await (database.delete(database.zoningFeatureHistory)
                  ..where((tbl) => tbl.featureId.equals(feature.clientUuid)))
                .go();
          }

          totalUploaded += savedFeatures.length;
        }
      }

      // Refresh providers
      ref.invalidate(localityProjectsProvider);

      if (mounted) {
        SnackBarUtils.showSuccess(
          context,
          '$totalUploaded vipengele vimepakiwa',
        );
      }

      _clearSelection();
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(context, 'Imeshindikana kupakia: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  List<LocalityProject> _getFilteredProjects(List<LocalityProject> projects) {
    switch (_currentFilter) {
      case ZoningFilter.all:
        return projects
            .where((p) =>
                p.draftCount > 0 || p.savedCount > 0 || p.uploadedCount > 0)
            .toList();
      case ZoningFilter.draft:
        return projects.where((p) => p.draftCount > 0).toList();
      case ZoningFilter.saved:
        return projects.where((p) => p.savedCount > 0).toList();
      case ZoningFilter.uploaded:
        return projects.where((p) => p.uploadedCount > 0).toList();
    }
  }

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final localityProjectsAsync = ref.watch(localityProjectsProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      drawer: _isSelectionMode ? null : const AppDrawer(),
      appBar: _buildAppBar(isDark, theme, localityProjectsAsync.valueOrNull ?? []),
      body: localityProjectsAsync.when(
        data: (projects) {
          final filteredProjects = _getFilteredProjects(projects);
          final draftCount = projects.fold(0, (sum, p) => sum + p.draftCount);
          final savedCount = projects.fold(0, (sum, p) => sum + p.savedCount);
          final uploadedCount = projects.fold(0, (sum, p) => sum + p.uploadedCount);

          return Column(
            children: [
              if (!_isSelectionMode)
                _buildFilterChips(isDark, draftCount, savedCount, uploadedCount),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(localityProjectsProvider);
                  },
                  child: _buildProjectList(isDark, projects, filteredProjects),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    bool isDark,
    ThemeData theme,
    List<LocalityProject> allProjects,
  ) {
    if (_isSelectionMode) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _clearSelection,
        ),
        title: Text(
          '${_selectedLocalityIds.length} vimechaguliwa',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        foregroundColor:
            isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        elevation: 1,
        actions: [
          TextButton.icon(
            onPressed: _isUploading
                ? null
                : () => _uploadSelectedLocalities(allProjects),
            icon: _isUploading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.cloud_upload_outlined),
            label: Text(_isUploading ? 'Inapakia...' : 'Pakia'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'select_all') {
                _selectAllEligible(allProjects);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'select_all',
                child: Text('Chagua Zote'),
              ),
            ],
          ),
        ],
      );
    }
    return const CustomAppBar(
      title: 'Zoning',
      showBackButton: false,
      showProfile: true,
    );
  }

  Widget _buildFilterChips(
    bool isDark,
    int draftCount,
    int savedCount,
    int uploadedCount,
  ) {
    final allCount = draftCount + savedCount + uploadedCount;

    final filters = [
      (ZoningFilter.all, 'Zote', allCount, AppColors.primary),
      (ZoningFilter.draft, 'Rasimu', draftCount, AppColors.warning),
      (ZoningFilter.saved, 'Zilizohifadhiwa', savedCount, AppColors.info),
      (ZoningFilter.uploaded, 'Zimepakiwa', uploadedCount, AppColors.success),
    ];

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd,
          vertical: AppConstants.spacingSm,
        ),
        itemCount: filters.length,
        separatorBuilder: (_, i) =>
            const SizedBox(width: AppConstants.spacingSm),
        itemBuilder: (context, index) {
          final (filter, label, count, color) = filters[index];
          final isActive = _currentFilter == filter;

          return FilterChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label),
                const SizedBox(width: 6),
                Container(
                  constraints: const BoxConstraints(minWidth: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isActive
                        ? color
                        : (isDark
                            ? Colors.grey.shade700
                            : Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    count.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.fontSize(context, 11),
                      fontWeight: FontWeight.w700,
                      color: isActive
                          ? Colors.white
                          : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary),
                    ),
                  ),
                ),
              ],
            ),
            selected: isActive,
            onSelected: (_) => setState(() => _currentFilter = filter),
            selectedColor: color.withValues(alpha: 0.2),
            checkmarkColor: color,
            labelStyle: TextStyle(
              color: isActive
                  ? color
                  : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary),
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
            backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
            side: BorderSide(
              color: isActive
                  ? color
                  : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            ),
            showCheckmark: false,
            padding: const EdgeInsets.symmetric(horizontal: 4),
          );
        },
      ),
    );
  }

  Widget _buildProjectList(
    bool isDark,
    List<LocalityProject> allProjects,
    List<LocalityProject> filteredProjects,
  ) {
    if (filteredProjects.isEmpty) {
      return _ZoningEmpty(filter: _currentFilter);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      itemCount: filteredProjects.length,
      itemBuilder: (context, index) {
        final project = filteredProjects[index];
        final isSelected = _selectedLocalityIds.contains(project.localityId);
        final canSelect = _canSelectLocality(project);

        return _LocalityProjectCard(
          project: project,
          filter: _currentFilter,
          isSelected: isSelected,
          isSelectionMode: _isSelectionMode,
          canSelect: canSelect,
          onTap: () {
            if (_isSelectionMode) {
              if (canSelect) {
                _toggleSelection(project);
              }
            } else {
              _showLocalityActions(context, project, _getStatusFromFilter());
            }
          },
          onLongPress: () {
            if (canSelect) {
              _toggleSelection(project);
            }
          },
        );
      },
    );
  }

  String _getStatusFromFilter() {
    switch (_currentFilter) {
      case ZoningFilter.all:
        return 'all';
      case ZoningFilter.draft:
        return 'draft';
      case ZoningFilter.saved:
        return 'saved';
      case ZoningFilter.uploaded:
        return 'uploaded';
    }
  }
}

class _LocalityProjectCard extends StatelessWidget {
  final LocalityProject project;
  final ZoningFilter filter;
  final bool isSelected;
  final bool isSelectionMode;
  final bool canSelect;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _LocalityProjectCard({
    required this.project,
    required this.filter,
    required this.isSelected,
    required this.isSelectionMode,
    required this.canSelect,
    required this.onTap,
    required this.onLongPress,
  });

  int _getCount() {
    switch (filter) {
      case ZoningFilter.all:
        return project.draftCount + project.savedCount + project.uploadedCount;
      case ZoningFilter.draft:
        return project.draftCount;
      case ZoningFilter.saved:
        return project.savedCount;
      case ZoningFilter.uploaded:
        return project.uploadedCount;
    }
  }

  Color _getStatusColor() {
    switch (filter) {
      case ZoningFilter.all:
        return AppColors.primary;
      case ZoningFilter.draft:
        return AppColors.warning;
      case ZoningFilter.saved:
        return AppColors.info;
      case ZoningFilter.uploaded:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final count = _getCount();
    final color = _getStatusColor();

    return GestureDetector(
      onLongPress: canSelect ? onLongPress : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: isSelected
              ? Border.all(
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                  width: 2,
                )
              : null,
        ),
        child: Card(
          margin: EdgeInsets.zero,
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
                  // Selection indicator
                  if (isSelectionMode && canSelect) ...[
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                            : Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                              : (isDark ? Colors.grey.shade600 : Colors.grey.shade400),
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, size: 16, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: AppConstants.spacingMd),
                  ],
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
                          '$count ${count == 1 ? "kipengele" : "vipengele"}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark
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
                                size: ResponsiveUtils.iconSize(context, 14),
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _getTimestampText(),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary,
                                  fontSize: ResponsiveUtils.fontSize(context, 12),
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
                      style: TextStyle(
                        fontSize: ResponsiveUtils.fontSize(context, 14),
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (!isSelectionMode) ...[
                    const SizedBox(width: AppConstants.spacingSm),
                    Icon(
                      Icons.chevron_right,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _shouldShowTimestamp() {
    return (filter == ZoningFilter.draft || filter == ZoningFilter.saved) &&
            project.lastUpdatedAt != null ||
        filter == ZoningFilter.uploaded && project.uploadedAt != null;
  }

  IconData _getTimestampIcon() {
    if (filter == ZoningFilter.uploaded) {
      return Icons.cloud_upload_rounded;
    }
    return Icons.update_rounded;
  }

  String _getTimestampText() {
    final DateTime? timestamp =
        filter == ZoningFilter.uploaded ? project.uploadedAt : project.lastUpdatedAt;

    if (timestamp == null) return '';

    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return filter == ZoningFilter.uploaded ? 'Imepakiwa sasa' : 'Imesasishwa sasa';
    } else if (difference.inHours < 1) {
      return filter == ZoningFilter.uploaded
          ? 'Imepakiwa dakika ${difference.inMinutes} zilizopita'
          : 'Imesasishwa dakika ${difference.inMinutes} zilizopita';
    } else if (difference.inDays < 1) {
      return filter == ZoningFilter.uploaded
          ? 'Imepakiwa saa ${difference.inHours} zilizopita'
          : 'Imesasishwa saa ${difference.inHours} zilizopita';
    } else if (difference.inDays < 7) {
      return filter == ZoningFilter.uploaded
          ? 'Imepakiwa siku ${difference.inDays} zilizopita'
          : 'Imesasishwa siku ${difference.inDays} zilizopita';
    } else {
      return filter == ZoningFilter.uploaded
          ? 'Imepakiwa ${timestamp.day}/${timestamp.month}/${timestamp.year}'
          : 'Imesasishwa ${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

class _ZoningEmpty extends StatelessWidget {
  final ZoningFilter filter;

  const _ZoningEmpty({required this.filter});

  String _getMessage() {
    switch (filter) {
      case ZoningFilter.all:
        return 'Hakuna miradi yenye vipengele.';
      case ZoningFilter.draft:
        return 'Hakuna miradi yenye rasimu za vipengele.';
      case ZoningFilter.saved:
        return 'Hakuna miradi yenye vipengele vilivyohifadhiwa.';
      case ZoningFilter.uploaded:
        return 'Hakuna miradi yenye vipengele vilivyopakiwa.';
    }
  }

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
                    color: isDark
                        ? AppColors.darkPrimary.withValues(alpha: 0.1)
                        : AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.map_outlined,
                    size: 64,
                    color: isDark
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
                    _getMessage(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark
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
