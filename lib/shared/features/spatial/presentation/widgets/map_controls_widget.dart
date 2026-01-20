import 'package:flutter/material.dart';
import '../../../../constants/app_constants.dart';
import '../../../../theme/app_colors.dart';

/// Reusable map control buttons
class MapControlsWidget extends StatelessWidget {
  final VoidCallback? onMyLocation;
  final VoidCallback? onRotateNorth;
  final VoidCallback? onLayerSwitch;
  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;
  final VoidCallback? onToggleFeatures;
  final bool? showingFeatures;
  final bool isDarkMode;
  final bool showMyLocation;
  final bool showRotateNorth;
  final bool showLayerSwitch;
  final bool showZoomControls;
  final bool showFeaturesToggle;

  const MapControlsWidget({
    super.key,
    this.onMyLocation,
    this.onRotateNorth,
    this.onLayerSwitch,
    this.onZoomIn,
    this.onZoomOut,
    this.onToggleFeatures,
    this.showingFeatures,
    this.isDarkMode = false,
    this.showMyLocation = true,
    this.showRotateNorth = true,
    this.showLayerSwitch = true,
    this.showZoomControls = false,
    this.showFeaturesToggle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showMyLocation && onMyLocation != null)
          _buildControlButton(
            icon: Icons.my_location,
            onPressed: onMyLocation!,
            tooltip: 'My Location',
          ),
        if (showRotateNorth && onRotateNorth != null)
          _buildControlButton(
            icon: Icons.explore,
            onPressed: onRotateNorth!,
            tooltip: 'Rotate to North',
          ),
        if (showLayerSwitch && onLayerSwitch != null)
          _buildControlButton(
            icon: Icons.layers,
            onPressed: onLayerSwitch!,
            tooltip: 'Switch Map Type',
          ),
        if (showZoomControls && onZoomIn != null)
          _buildControlButton(
            icon: Icons.add,
            onPressed: onZoomIn!,
            tooltip: 'Zoom In',
          ),
        if (showZoomControls && onZoomOut != null)
          _buildControlButton(
            icon: Icons.remove,
            onPressed: onZoomOut!,
            tooltip: 'Zoom Out',
          ),
        if (showFeaturesToggle && onToggleFeatures != null)
          _buildToggleButton(
            icon: showingFeatures == true ? Icons.cloud_done : Icons.cloud_off,
            onPressed: onToggleFeatures!,
            tooltip: showingFeatures == true
                ? 'Hide server features'
                : 'Show server features',
            isActive: showingFeatures == true,
          ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingSm),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon),
        tooltip: tooltip,
        onPressed: onPressed,
        color: isDarkMode ? AppColors.darkTextPrimary : AppColors.textPrimary,
      ),
    );
  }

  Widget _buildToggleButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
    required bool isActive,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingSm),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary.withValues(alpha: 0.9)
            : (isDarkMode
                ? AppColors.darkSurfaceVariant
                : AppColors.surfaceVariant),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon),
        tooltip: tooltip,
        onPressed: onPressed,
        color: isActive
            ? Colors.white
            : (isDarkMode
                ? AppColors.surfaceVariant
                : AppColors.darkSurfaceVariant),
      ),
    );
  }
}
