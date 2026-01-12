import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/network/network_info.dart';
import '../../../../../data/local/draft_provider.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/utils/responsive_utils.dart';
import '../../../../../shared/utils/snackbar_utils.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../domain/entities/zoning_feature.dart';
import '../../domain/entities/locality_project.dart';
import '../providers/zoning_manager_providers.dart';
import '../providers/zoning_providers.dart';

enum FeatureFilter { all, draft, saved, uploaded }

/// Page showing all features for a specific locality, organized by status
class LocalityFeaturesPage extends ConsumerStatefulWidget {
  final LocalityProject localityProject;

  const LocalityFeaturesPage({super.key, required this.localityProject});

  @override
  ConsumerState<LocalityFeaturesPage> createState() =>
      _LocalityFeaturesPageState();
}

class _LocalityFeaturesPageState extends ConsumerState<LocalityFeaturesPage> {
  FeatureFilter _currentFilter = FeatureFilter.all;
  final Set<String> _selectedIds = {};
  bool _isUploading = false;

  bool get _isSelectionMode => _selectedIds.isNotEmpty;

  bool _canSelectFeature(ZoningFeature feature) {
    // Can only select saved (not draft, not uploaded) features for upload
    return !feature.isDraft && !feature.uploaded;
  }

  void _toggleSelection(ZoningFeature feature) {
    setState(() {
      if (_selectedIds.contains(feature.clientUuid)) {
        _selectedIds.remove(feature.clientUuid);
      } else {
        _selectedIds.add(feature.clientUuid);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedIds.clear();
    });
  }

  void _selectAllEligible(List<ZoningFeature> features) {
    setState(() {
      for (final feature in features) {
        if (_canSelectFeature(feature)) {
          _selectedIds.add(feature.clientUuid);
        }
      }
    });
  }

  Future<void> _uploadSelected(List<ZoningFeature> allFeatures) async {
    final selectedFeatures = allFeatures
        .where((f) => _selectedIds.contains(f.clientUuid))
        .toList();

    if (selectedFeatures.isEmpty) return;

    setState(() => _isUploading = true);

    try {
      final zoningApi = ref.read(zoningApiServiceProvider);
      final repository = ref.read(zoningRepositoryProvider);
      final database = ref.read(databaseProvider);

      // Upload features using bulk API
      await zoningApi.bulkUploadZones(features: selectedFeatures);

      // Mark features as uploaded in local database
      for (final feature in selectedFeatures) {
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

      // Refresh providers
      ref.invalidate(localityFeaturesByStatusProvider);
      ref.invalidate(localityProjectsProvider);

      if (mounted) {
        SnackBarUtils.showSuccess(
          context,
          '${selectedFeatures.length} vipengele vimepakiwa',
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

  List<ZoningFeature> _getFilteredFeatures(
    List<ZoningFeature> draft,
    List<ZoningFeature> saved,
    List<ZoningFeature> uploaded,
  ) {
    switch (_currentFilter) {
      case FeatureFilter.all:
        return [...draft, ...saved, ...uploaded]
          ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      case FeatureFilter.draft:
        return draft;
      case FeatureFilter.saved:
        return saved;
      case FeatureFilter.uploaded:
        return uploaded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final localityId = widget.localityProject.localityId;

    // Watch all three status providers
    final draftAsync =
        ref.watch(localityFeaturesByStatusProvider((localityId, 'draft')));
    final savedAsync =
        ref.watch(localityFeaturesByStatusProvider((localityId, 'saved')));
    final uploadedAsync =
        ref.watch(localityFeaturesByStatusProvider((localityId, 'uploaded')));

    final onlineStatus = ref.watch(onlineStatusProvider);
    final isOnline = onlineStatus.maybeWhen(
      data: (value) => value,
      orElse: () => true,
    );

    // Combine async states
    final isLoading =
        draftAsync.isLoading || savedAsync.isLoading || uploadedAsync.isLoading;
    final hasError =
        draftAsync.hasError || savedAsync.hasError || uploadedAsync.hasError;

    final draftFeatures = draftAsync.valueOrNull ?? [];
    final savedFeatures = savedAsync.valueOrNull ?? [];
    final uploadedFeatures = uploadedAsync.valueOrNull ?? [];
    final allFeatures = [...draftFeatures, ...savedFeatures, ...uploadedFeatures];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: _buildAppBar(isDark, theme, allFeatures),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? Center(
                  child: Text(
                    'Imeshindikana kupakia vipengele',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                )
              : Column(
                  children: [
                    if (!_isSelectionMode)
                      _buildFilterChips(
                        isDark,
                        draftFeatures.length,
                        savedFeatures.length,
                        uploadedFeatures.length,
                      ),
                    Expanded(
                      child: isOnline
                          ? RefreshIndicator(
                              onRefresh: () async {
                                ref.invalidate(localityFeaturesByStatusProvider);
                              },
                              child: _buildFeatureList(
                                isDark,
                                draftFeatures,
                                savedFeatures,
                                uploadedFeatures,
                              ),
                            )
                          : _buildFeatureList(
                              isDark,
                              draftFeatures,
                              savedFeatures,
                              uploadedFeatures,
                            ),
                    ),
                  ],
                ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    bool isDark,
    ThemeData theme,
    List<ZoningFeature> allFeatures,
  ) {
    if (_isSelectionMode) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _clearSelection,
        ),
        title: Text(
          '${_selectedIds.length} vimechaguliwa',
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
            onPressed: _isUploading ? null : () => _uploadSelected(allFeatures),
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
                _selectAllEligible(allFeatures);
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
    return CustomAppBar(
      title: widget.localityProject.localityName,
      showBackButton: true,
      showProfile: false,
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
      (FeatureFilter.all, 'Zote', allCount, AppColors.primary),
      (FeatureFilter.draft, 'Rasimu', draftCount, AppColors.warning),
      (FeatureFilter.saved, 'Zilizohifadhiwa', savedCount, AppColors.info),
      (FeatureFilter.uploaded, 'Zimepakiwa', uploadedCount, AppColors.success),
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

  Widget _buildFeatureList(
    bool isDark,
    List<ZoningFeature> draft,
    List<ZoningFeature> saved,
    List<ZoningFeature> uploaded,
  ) {
    final features = _getFilteredFeatures(draft, saved, uploaded);

    if (features.isEmpty) {
      return _EmptyState(filter: _currentFilter);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        final isSelected = _selectedIds.contains(feature.clientUuid);
        final canSelect = _canSelectFeature(feature);

        return _FeatureCard(
          feature: feature,
          isSelected: isSelected,
          isSelectionMode: _isSelectionMode,
          canSelect: canSelect,
          onTap: () {
            if (_isSelectionMode) {
              if (canSelect) {
                _toggleSelection(feature);
              }
            } else {
              // Navigate to zoning page and highlight this feature
              context.pushNamed(
                'luZoning',
                pathParameters: {'projectId': feature.projectId},
                extra: {'highlightFeatureId': feature.clientUuid},
              );
            }
          },
          onLongPress: () {
            if (canSelect) {
              _toggleSelection(feature);
            }
          },
        );
      },
    );
  }
}

class _FeatureCard extends ConsumerWidget {
  final ZoningFeature feature;
  final bool isSelected;
  final bool isSelectionMode;
  final bool canSelect;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _FeatureCard({
    required this.feature,
    required this.isSelected,
    required this.isSelectionMode,
    required this.canSelect,
    required this.onTap,
    required this.onLongPress,
  });

  String _formatMeasurement() {
    if (feature.area != null) {
      if (feature.area! >= 1000000) {
        return '${(feature.area! / 1000000).toStringAsFixed(2)} km²';
      }
      return '${feature.area!.toStringAsFixed(2)} m²';
    }
    if (feature.length != null) {
      if (feature.length! >= 1000) {
        return '${(feature.length! / 1000).toStringAsFixed(2)} km';
      }
      return '${feature.length!.toStringAsFixed(2)} m';
    }
    return '';
  }

  IconData _getFeatureIcon() {
    switch (feature.featureType) {
      case ZoningFeatureType.point:
        return Icons.place;
      case ZoningFeatureType.lineString:
        return Icons.timeline;
      case ZoningFeatureType.polygon:
        return Icons.crop_free;
    }
  }

  String _getTimestampText() {
    final DateTime timestamp = feature.uploaded && feature.uploadedAt != null
        ? feature.uploadedAt!
        : feature.updatedAt;
    
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return feature.uploaded ? 'Uploaded just now' : 'Updated just now';
    } else if (difference.inHours < 1) {
      return feature.uploaded
          ? 'Uploaded ${difference.inMinutes}m ago'
          : 'Updated ${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return feature.uploaded
          ? 'Uploaded ${difference.inHours}h ago'
          : 'Updated ${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return feature.uploaded
          ? 'Uploaded ${difference.inDays}d ago'
          : 'Updated ${difference.inDays}d ago';
    } else {
      return feature.uploaded
          ? 'Uploaded ${timestamp.day}/${timestamp.month}/${timestamp.year}'
          : 'Updated ${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final landUseMap = ref.watch(landUseMapProvider);
    final landUseColors = ref.watch(landUseColorMapProvider);

    final landUse =
        feature.landUseId != null ? landUseMap[feature.landUseId!] : null;
    final color =
        feature.landUseId != null
            ? (landUseColors[feature.landUseId!] ?? Colors.grey)
            : Colors.grey;

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
                  // Feature icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(_getFeatureIcon(), color: color, size: 20),
                  ),
                  const SizedBox(width: AppConstants.spacingMd),
                  // Feature details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          feature.plotName?.isNotEmpty == true
                              ? feature.plotName!
                              : feature.plotId ??
                                  'Feature ${feature.clientUuid.substring(0, 8)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (landUse != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            landUse.name,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                        if (_formatMeasurement().isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            _formatMeasurement(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              feature.uploaded
                                  ? Icons.cloud_upload_rounded
                                  : Icons.update_rounded,
                              size: 14,
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
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (!isSelectionMode)
                    Icon(
                      Icons.chevron_right,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final FeatureFilter filter;

  const _EmptyState({required this.filter});

  String _getMessage() {
    switch (filter) {
      case FeatureFilter.all:
        return 'Hakuna vipengele';
      case FeatureFilter.draft:
        return 'Hakuna rasimu za kipengele bado';
      case FeatureFilter.saved:
        return 'Hakuna vipengele vilivyohifadhiwa bado';
      case FeatureFilter.uploaded:
        return 'Hakuna vipengele vilivyopakiwa bado';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.map_outlined,
            size: 64,
            color:
                isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            _getMessage(),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color:
                  isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
