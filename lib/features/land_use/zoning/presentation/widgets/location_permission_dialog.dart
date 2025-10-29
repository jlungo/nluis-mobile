import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';

class LocationPermissionDialog extends StatefulWidget {
  final VoidCallback onPermissionGranted;
  final VoidCallback onPermissionDenied;

  const LocationPermissionDialog({
    super.key,
    required this.onPermissionGranted,
    required this.onPermissionDenied,
  });

  @override
  State<LocationPermissionDialog> createState() =>
      _LocationPermissionDialogState();
}

class _LocationPermissionDialogState extends State<LocationPermissionDialog> {
  bool _isRequesting = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      title: Row(
        children: [
          Icon(Icons.location_on_outlined, color: AppColors.primary),
          const SizedBox(width: AppConstants.spacingSm),
          Text(
            'Ruhusa za Mahali',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Programu hii inahitaji ruhusa za kupata mahali yako ili:',
            style: theme.textTheme.bodyMedium?.copyWith(
              color:
                  isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),

          _buildFeatureItem(
            icon: Icons.gps_fixed,
            title: 'Kuonyesha mahali yako kwenye ramani',
            theme: theme,
            isDark: isDark,
          ),

          _buildFeatureItem(
            icon: Icons.check_circle_outline,
            title: 'Kuthibitisha kama uko ndani ya mipaka ya mradi',
            theme: theme,
            isDark: isDark,
          ),

          _buildFeatureItem(
            icon: Icons.add_location,
            title: 'Kurekodi vipengele vya zoning kiotomatiki',
            theme: theme,
            isDark: isDark,
          ),

          const SizedBox(height: AppConstants.spacingMd),

          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.info, size: 20),
                const SizedBox(width: AppConstants.spacingSm),
                Expanded(
                  child: Text(
                    'Bila ruhusa hizi, utaweza kuongeza vipengele kwa mikono tu.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.info,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_errorMessage != null) ...[
            const SizedBox(height: AppConstants.spacingMd),
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: AppColors.error, size: 20),
                  const SizedBox(width: AppConstants.spacingSm),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (_isRequesting) ...[
            const SizedBox(height: AppConstants.spacingMd),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
      actions: [
        if (!_isRequesting) ...[
          TextButton(
            onPressed: () {
              widget.onPermissionDenied();
            },
            child: Text(
              'Endelea Bila Ruhusa',
              style: TextStyle(
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _requestPermission,
            icon: const Icon(Icons.location_on),
            label: const Text('Ruhusu'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingSm),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.success),
          const SizedBox(width: AppConstants.spacingSm),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _requestPermission() async {
    setState(() {
      _isRequesting = true;
      _errorMessage = null;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isRequesting = false;
          _errorMessage =
              'Huduma za mahali zimezimwa. Tafadhali ziwashe kwenye mipangilio ya simu yako.';
        });
        return;
      }

      // Check current permission status
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      setState(() {
        _isRequesting = false;
      });

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        widget.onPermissionGranted();
      } else if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage =
              'Ruhusa za mahali zimekataliwa kabisa. Tafadhali ziruhusu kwenye mipangilio ya programu.';
        });
      } else {
        setState(() {
          _errorMessage = 'Ruhusa za mahali zimekataliwa.';
        });
      }
    } catch (e) {
      setState(() {
        _isRequesting = false;
        _errorMessage =
            'Hitilafu imetokea wakati wa kuomba ruhusa: ${e.toString()}';
      });
    }
  }
}
