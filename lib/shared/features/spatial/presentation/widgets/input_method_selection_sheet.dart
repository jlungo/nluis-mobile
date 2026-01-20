import 'package:flutter/material.dart';
import '../../../../constants/app_constants.dart';
import '../../../../theme/app_colors.dart';

enum InputMethod {
  tapping,
  manualEntry,
  automaticRecording,
}

/// Generic bottom sheet for selecting geometry input method
/// Can be used for both zoning features and CCRO parcels
class InputMethodSelectionSheet extends StatelessWidget {
  final String featureTypeName; // "Point", "Line", "Polygon", "Parcel"
  final IconData featureTypeIcon;
  final Function(InputMethod) onMethodSelected;
  final String title; // e.g., "Unda Polygon" or "Rekodi Kipande"
  final String subtitle; // e.g., "Chagua njia ya kuingiza data"

  const InputMethodSelectionSheet({
    super.key,
    required this.featureTypeName,
    required this.featureTypeIcon,
    required this.onMethodSelected,
    this.title = '',
    this.subtitle = 'Chagua njia ya kuingiza data',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final displayTitle = title.isNotEmpty ? title : 'Unda $featureTypeName';

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
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

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
                      featureTypeIcon,
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
                          displayTitle,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          subtitle,
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
