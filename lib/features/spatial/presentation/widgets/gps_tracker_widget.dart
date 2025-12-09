import 'package:flutter/material.dart';
import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../domain/entities/user_location.dart';

/// GPS tracking indicator and controls
class GpsTrackerWidget extends StatelessWidget {
  final UserLocation? location;
  final bool isTracking;
  final VoidCallback? onStartTracking;
  final VoidCallback? onStopTracking;
  final bool showControls;
  final bool showCoordinates;
  final double accuracyThreshold;

  const GpsTrackerWidget({
    super.key,
    this.location,
    required this.isTracking,
    this.onStartTracking,
    this.onStopTracking,
    this.showControls = true,
    this.showCoordinates = false,
    this.accuracyThreshold = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
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
          // GPS Status Header
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isTracking ? Icons.gps_fixed : Icons.gps_off,
                size: 16,
                color: isTracking ? AppColors.success : AppColors.textSecondary,
              ),
              const SizedBox(width: AppConstants.spacingXs),
              Text(
                isTracking ? 'GPS Active' : 'GPS Inactive',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isTracking ? AppColors.success : AppColors.textSecondary,
                ),
              ),
            ],
          ),

          if (location != null) ...[
            const SizedBox(height: AppConstants.spacingSm),
            const Divider(height: 1),
            const SizedBox(height: AppConstants.spacingSm),

            // Accuracy indicator
            _buildAccuracyIndicator(location!, theme, isDark),

            // Boundary status
            const SizedBox(height: AppConstants.spacingXs),
            _buildBoundaryStatus(location!, theme),

            // Coordinates (optional)
            if (showCoordinates) ...[
              const SizedBox(height: AppConstants.spacingXs),
              Text(
                '${location!.position.latitude.toStringAsFixed(6)}, ${location!.position.longitude.toStringAsFixed(6)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.darkTextHint : AppColors.textHint,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ],

          // Controls
          if (showControls) ...[
            const SizedBox(height: AppConstants.spacingMd),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isTracking && onStartTracking != null)
                  ElevatedButton.icon(
                    onPressed: onStartTracking,
                    icon: const Icon(Icons.play_arrow, size: 16),
                    label: const Text('Start'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingMd,
                        vertical: AppConstants.spacingSm,
                      ),
                    ),
                  ),
                if (isTracking && onStopTracking != null)
                  OutlinedButton.icon(
                    onPressed: onStopTracking,
                    icon: const Icon(Icons.stop, size: 16),
                    label: const Text('Stop'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingMd,
                        vertical: AppConstants.spacingSm,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAccuracyIndicator(
    UserLocation location,
    ThemeData theme,
    bool isDark,
  ) {
    final accuracy = location.accuracy;
    final isGood = accuracy <= accuracyThreshold;
    final isAcceptable = accuracy <= accuracyThreshold * 2;

    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (isGood) {
      statusColor = AppColors.success;
      statusIcon = Icons.gps_fixed;
      statusText = 'Excellent';
    } else if (isAcceptable) {
      statusColor = AppColors.warning;
      statusIcon = Icons.gps_not_fixed;
      statusText = 'Good';
    } else {
      statusColor = AppColors.error;
      statusIcon = Icons.gps_off;
      statusText = 'Poor';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          statusIcon,
          size: 12,
          color: statusColor,
        ),
        const SizedBox(width: AppConstants.spacingXs),
        Text(
          '±${accuracy.toStringAsFixed(1)}m',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: AppConstants.spacingXs),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingXs,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
          ),
          child: Text(
            statusText,
            style: theme.textTheme.labelSmall?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBoundaryStatus(UserLocation location, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: location.isInsideBoundary ? AppColors.success : AppColors.warning,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppConstants.spacingXs),
        Text(
          location.isInsideBoundary ? 'Inside boundary' : 'Outside boundary',
          style: theme.textTheme.bodySmall?.copyWith(
            color:
                location.isInsideBoundary ? AppColors.success : AppColors.warning,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
