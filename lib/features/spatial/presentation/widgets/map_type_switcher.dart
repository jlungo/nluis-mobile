import 'package:flutter/material.dart';
import '../../../../shared/constants/app_constants.dart';
import 'base_map_layer.dart';

/// Map type switcher bottom sheet
class MapTypeSwitcher {
  /// Show map type selection bottom sheet
  static void show({
    required BuildContext context,
    required MapType currentType,
    required Function(MapType) onTypeSelected,
    Duration? bannerDuration,
  }) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.map),
                title: const Text('Standard'),
                subtitle: const Text('Street map view'),
                trailing: currentType == MapType.standard
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  onTypeSelected(MapType.standard);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.satellite_alt),
                title: const Text('Satellite'),
                subtitle: const Text('Aerial imagery view'),
                trailing: currentType == MapType.satellite
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  onTypeSelected(MapType.satellite);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Map type banner widget for showing temporary feedback
class MapTypeBanner extends StatelessWidget {
  final String message;
  final bool isDarkMode;

  const MapTypeBanner({
    super.key,
    required this.message,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Chip(
        label: Text(message),
        backgroundColor: (isDarkMode ? Colors.grey[800] : Colors.black)
            ?.withValues(alpha: 0.8),
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.white : Colors.white,
        ),
      ),
    );
  }
}
