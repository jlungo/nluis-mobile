import 'package:flutter/material.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../domain/entities/zoning_feature.dart';

enum InputMethod {
  tapping,
  manualEntry,
  automaticRecording,
}

/// Bottom sheet for selecting input method for zone creation
class InputMethodSelectionSheet extends StatelessWidget {
  final ZoningFeatureType featureType;
  final Function(InputMethod) onMethodSelected;

  const InputMethodSelectionSheet({
    super.key,
    required this.featureType,
    required this.onMethodSelected,
  });

  String _getFeatureTypeName() {
    switch (featureType) {
      case ZoningFeatureType.point:
        return 'Point';
      case ZoningFeatureType.lineString:
        return 'Line';
      case ZoningFeatureType.polygon:
        return 'Polygon';
    }
  }

  IconData _getFeatureTypeIcon() {
    switch (featureType) {
      case ZoningFeatureType.point:
        return Icons.place;
      case ZoningFeatureType.lineString:
        return Icons.timeline;
      case ZoningFeatureType.polygon:
        return Icons.crop_free;
    }
  }

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
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingSm),
                    decoration: BoxDecoration(
                      color: (isDark ? AppColors.darkPrimary : AppColors.primary)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                    ),
                    child: Icon(
                      _getFeatureTypeIcon(),
                      color: isDark ? AppColors.darkPrimary : AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingSm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Unda ${_getFeatureTypeName()}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Chagua njia ya kuingiza data',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingLg),

              // Input Method Options
              _buildMethodOption(
                context: context,
                icon: Icons.touch_app,
                title: 'Placement by Tapping',
                description: 'Bofya kwenye ramani kuongeza kuratibu',
                method: InputMethod.tapping,
                isDark: isDark,
              ),
              const SizedBox(height: AppConstants.spacingSm),
              _buildMethodOption(
                context: context,
                icon: Icons.edit_location_alt,
                title: 'Manual Entry',
                description: 'Ingiza kuratibu kwa mkono',
                method: InputMethod.manualEntry,
                isDark: isDark,
              ),
              const SizedBox(height: AppConstants.spacingSm),
              _buildMethodOption(
                context: context,
                icon: Icons.gps_fixed,
                title: 'Automatic Location Recording',
                description: 'Tumia GPS kurekodi mahali ulipo',
                method: InputMethod.automaticRecording,
                isDark: isDark,
              ),
              const SizedBox(height: AppConstants.spacingSm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMethodOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required InputMethod method,
    required bool isDark,
  }) {
    return Card(
      elevation: 0,
      color: (isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant)
          .withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        side: BorderSide(
          color: (isDark ? AppColors.darkPrimary : AppColors.primary)
              .withValues(alpha: 0.1),
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          onMethodSelected(method);
        },
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingSm),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.darkPrimary : AppColors.primary)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
                child: Icon(
                  icon,
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isDark
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
