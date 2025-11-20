import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../domain/entities/zoning_feature.dart';
import '../../domain/entities/locality_project.dart';
import '../providers/zoning_manager_providers.dart';
import '../providers/zoning_providers.dart';

/// Page showing all features for a specific locality, organized by status
class LocalityFeaturesPage extends ConsumerWidget {
  final LocalityProject localityProject;

  const LocalityFeaturesPage({super.key, required this.localityProject});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppBar(
          title: localityProject.localityName,
          bottom: _LocalityTabBar(localityProject: localityProject),
          showBackButton: true,
          showProfile: false,
        ),
        body: TabBarView(
          children: [
            _FeaturesList(
              localityId: localityProject.localityId,
              status: 'draft',
            ),
            _FeaturesList(
              localityId: localityProject.localityId,
              status: 'saved',
            ),
            _FeaturesList(
              localityId: localityProject.localityId,
              status: 'uploaded',
            ),
          ],
        ),
      ),
    );
  }
}

class _LocalityTabBar extends StatelessWidget implements PreferredSizeWidget {
  final LocalityProject localityProject;

  const _LocalityTabBar({required this.localityProject});

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
              _CountBadge(count: count, color: color, isDark: isDark),
            ],
          ),
        ),
      );
    }

    return TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      labelColor: isDark ? AppColors.darkPrimary : AppColors.primaryDark,
      unselectedLabelColor:
          isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
      dividerColor: isDark ? AppColors.darkDivider : AppColors.divider,
      indicatorColor: isDark ? AppColors.darkPrimary : AppColors.primaryDark,
      indicatorWeight: 3,
      indicatorSize: TabBarIndicatorSize.tab,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingSm),
      tabs: [
        buildTab('Rasimu', localityProject.draftCount, AppColors.warning),
        buildTab('Zilizohifadhiwa', localityProject.savedCount, AppColors.info),
        buildTab(
          'Zimepakiwa',
          localityProject.uploadedCount,
          AppColors.success,
        ),
      ],
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int count;
  final Color color;
  final bool isDark;

  const _CountBadge({
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

class _FeaturesList extends ConsumerWidget {
  final String localityId;
  final String status;

  const _FeaturesList({required this.localityId, required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuresAsync = ref.watch(
      localityFeaturesByStatusProvider((localityId, status)),
    );

    return featuresAsync.when(
      data: (features) {
        if (features.isEmpty) {
          return _EmptyState(status: status);
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(localityFeaturesByStatusProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            itemCount: features.length,
            itemBuilder: (context, index) {
              return _FeatureCard(feature: features[index]);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

class _FeatureCard extends ConsumerWidget {
  final ZoningFeature feature;

  const _FeatureCard({required this.feature});

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

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to zoning page and try to highlight this feature
          context.pushNamed(
            'luZoning',
            pathParameters: {'projectId': feature.projectId},
            extra: {'highlightFeatureId': feature.clientUuid},
          );
        },
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Row(
            children: [
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
                          color:
                              isDark
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
                ),
              ),
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
}

class _EmptyState extends StatelessWidget {
  final String status;

  const _EmptyState({required this.status});

  String _getMessage() {
    switch (status) {
      case 'draft':
        return 'Hakuna rasimu za kipengele bado';
      case 'saved':
        return 'Hakuna vipengele vilivyohifadhiwa bado';
      case 'uploaded':
        return 'Hakuna vipengele vilivyopakiwa bado';
      default:
        return 'Hakuna vipengele';
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
