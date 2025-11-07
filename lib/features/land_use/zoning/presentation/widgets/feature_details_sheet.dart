import 'package:flutter/material.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../domain/entities/zoning_feature.dart';
import 'coordinate_editor_map.dart';

class FeatureDetailsSheet extends StatelessWidget {
  final ZoningFeature feature;
  final Function(ZoningFeature) onEdit;
  final VoidCallback onDelete;

  const FeatureDetailsSheet({
    super.key,
    required this.feature,
    required this.onEdit,
    required this.onDelete,
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
            // Handle
            const SizedBox(height: AppConstants.spacingMd),
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
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingSm),
                    decoration: BoxDecoration(
                      color: _getZoningTypeColor(feature.zoningType)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                    ),
                    child: Icon(
                      _getFeatureIcon(feature.featureType),
                      color: _getZoningTypeColor(feature.zoningType),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          feature.plotName?.isNotEmpty == true
                              ? feature.plotName!
                              : feature.plotId ?? 'Unnamed Feature',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${feature.featureType.name.toUpperCase()} • ${_getZoningTypeLabel(feature.zoningType)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (feature.isDraft)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingSm,
                        vertical: AppConstants.spacingXs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                        border: Border.all(
                          color: AppColors.warning.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        'DRAFT',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: AppConstants.spacingLg),
            
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingLg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Measurements
                    if (feature.area != null || feature.length != null) ...[
                      _buildSectionHeader('Measurements', theme, isDark),
                      const SizedBox(height: AppConstants.spacingSm),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppConstants.spacingMd),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurfaceVariant
                              : AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusMd,
                          ),
                        ),
                        child: Row(
                          children: [
                            if (feature.area != null) ...[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Area',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                    Text(
                                      '${feature.area!.toStringAsFixed(2)} m²',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? AppColors.darkTextPrimary
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            if (feature.length != null) ...[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Length',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                    Text(
                                      '${feature.length!.toStringAsFixed(2)} m',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? AppColors.darkTextPrimary
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Points',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  '${feature.coordinates.length}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingLg),
                    ],
                    
                    // Details
                    _buildSectionHeader('Details', theme, isDark),
                    const SizedBox(height: AppConstants.spacingSm),
                    
                    if (feature.plotId?.isNotEmpty == true)
                      _buildDetailRow('Plot ID', feature.plotId!, theme, isDark),
                    
                    if (feature.notes?.isNotEmpty == true)
                      _buildDetailRow('Notes', feature.notes!, theme, isDark),
                    
                    _buildDetailRow(
                      'Created',
                      _formatDate(feature.createdAt),
                      theme,
                      isDark,
                    ),
                    
                    if (feature.updatedAt != feature.createdAt)
                      _buildDetailRow(
                        'Updated',
                        _formatDate(feature.updatedAt),
                        theme,
                        isDark,
                      ),
                    
                    _buildDetailRow(
                      'Status',
                      feature.needsSync ? 'Needs sync' : 'Synced',
                      theme,
                      isDark,
                      valueColor: feature.needsSync ? AppColors.warning : AppColors.success,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppConstants.spacingLg),
            
            // Uploaded features notice
            if (feature.uploaded)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.spacingMd),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                    border: Border.all(
                      color: AppColors.info.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.cloud_done,
                        color: AppColors.info,
                        size: 20,
                      ),
                      const SizedBox(width: AppConstants.spacingSm),
                      Expanded(
                        child: Text(
                          'This feature has been uploaded and cannot be edited or deleted.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.info,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            if (feature.uploaded)
              const SizedBox(height: AppConstants.spacingMd),
            
            // Actions
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingLg),
              child: Row(
                children: [
                  Expanded(
                    child: Opacity(
                      opacity: feature.uploaded ? 0.5 : 1.0,
                      child: AbsorbPointer(
                        absorbing: feature.uploaded,
                        child: AppButton(
                          label: 'Delete',
                          onPressed: () {
                            Navigator.of(context).pop();
                            _showDeleteConfirmation(context);
                          },
                          gradientColors: [AppColors.error.withValues(alpha: 0.1), AppColors.error.withValues(alpha: 0.2)],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingMd),
                  Expanded(
                    child: Opacity(
                      opacity: feature.uploaded ? 0.5 : 1.0,
                      child: AbsorbPointer(
                        absorbing: feature.uploaded,
                        child: AppButton(
                          label: 'Edit Coordinates',
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CoordinateEditorMap(
                                  feature: feature,
                                  onSave: (updatedCoordinates) {
                                    final updatedFeature = feature.copyWith(
                                      coordinates: updatedCoordinates,
                                      updatedAt: DateTime.now(),
                                    );
                                    onEdit(updatedFeature);
                                    Navigator.of(context).pop();
                                  },
                                  onCancel: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            );
                          },
                          gradientColors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme, bool isDark) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    ThemeData theme,
    bool isDark, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: valueColor ??
                    (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        ),
        title: Text(
          'Delete Feature',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this feature? This action cannot be undone.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDelete();
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFeatureIcon(ZoningFeatureType type) {
    switch (type) {
      case ZoningFeatureType.point:
        return Icons.place;
      case ZoningFeatureType.lineString:
        return Icons.timeline;
      case ZoningFeatureType.polygon:
        return Icons.crop_free;
    }
  }

  Color _getZoningTypeColor(ZoningType type) {
    switch (type) {
      case ZoningType.residential:
        return Colors.green;
      case ZoningType.commercial:
        return Colors.blue;
      case ZoningType.industrial:
        return Colors.orange;
      case ZoningType.agricultural:
        return Colors.brown;
      case ZoningType.recreational:
        return Colors.purple;
      case ZoningType.institutional:
        return Colors.red;
      case ZoningType.mixed:
        return Colors.teal;
      case ZoningType.other:
        return Colors.grey;
    }
  }

  String _getZoningTypeLabel(ZoningType type) {
    switch (type) {
      case ZoningType.residential:
        return 'Residential';
      case ZoningType.commercial:
        return 'Commercial';
      case ZoningType.industrial:
        return 'Industrial';
      case ZoningType.agricultural:
        return 'Agricultural';
      case ZoningType.recreational:
        return 'Recreational';
      case ZoningType.institutional:
        return 'Institutional';
      case ZoningType.mixed:
        return 'Mixed Use';
      case ZoningType.other:
        return 'Other';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
