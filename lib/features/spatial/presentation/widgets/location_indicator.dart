import 'package:flutter/material.dart';
import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../domain/entities/user_location.dart';

class LocationIndicator extends StatelessWidget {
  final UserLocation location;
  final bool showBoundaryStatus;

  const LocationIndicator({
    super.key,
    required this.location,
    this.showBoundaryStatus = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: AppConstants.spacingSm,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location status
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color:
                      location.isInsideBoundary
                          ? AppColors.success
                          : AppColors.warning,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppConstants.spacingSm),
              Text(
                location.isInsideBoundary
                    ? 'Inside boundary'
                    : 'Outside boundary',
                style: theme.textTheme.bodySmall?.copyWith(
                  color:
                      location.isInsideBoundary
                          ? AppColors.success
                          : AppColors.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingXs),

          // Accuracy indicator
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getAccuracyIcon(location.accuracy),
                size: 12,
                color: _getAccuracyColor(location.accuracy),
              ),
              const SizedBox(width: AppConstants.spacingXs),
              Text(
                '±${location.accuracy.toStringAsFixed(0)}m',
                style: theme.textTheme.bodySmall?.copyWith(
                  color:
                      isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                ),
              ),
            ],
          ),

          // Coordinates (for debugging)
          if (_shouldShowCoordinates()) ...[
            const SizedBox(height: AppConstants.spacingXs),
            Text(
              '${location.position.latitude.toStringAsFixed(6)}, ${location.position.longitude.toStringAsFixed(6)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.darkTextHint : AppColors.textHint,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getAccuracyIcon(double accuracy) {
    if (accuracy <= 5) return Icons.gps_fixed;
    if (accuracy <= 10) return Icons.gps_not_fixed;
    return Icons.gps_off;
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy <= 5) return AppColors.success;
    if (accuracy <= 10) return AppColors.warning;
    return AppColors.error;
  }

  bool _shouldShowCoordinates() {
    // Only show coordinates in debug mode or for high accuracy
    return location.accuracy <= 10;
  }
}
