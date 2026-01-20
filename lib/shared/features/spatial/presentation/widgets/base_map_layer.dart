import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import '../../../../constants/app_constants.dart';

enum MapType { standard, satellite }

/// base map tile layer with caching and theme support
class BaseMapLayer extends StatelessWidget {
  final MapType mapType;
  final bool isDarkMode;
  final String? userAgentPackageName;

  const BaseMapLayer({
    super.key,
    required this.mapType,
    this.isDarkMode = false,
    this.userAgentPackageName = 'tz.go.nlupc.nluis',
  });

  @override
  Widget build(BuildContext context) {
    final tileConfig = _getTileConfiguration();

    return TileLayer(
      key: ValueKey('tile_${isDarkMode ? 'dark' : mapType.name}'),
      urlTemplate: tileConfig.urlTemplate,
      userAgentPackageName: userAgentPackageName ?? 'tz.go.nlupc.nluis',
      tileProvider: FMTCTileProvider(stores: {tileConfig.storeName: null}),
    );
  }

  _TileConfiguration _getTileConfiguration() {
    if (isDarkMode && mapType == MapType.standard) {
      // Dark mode with standard tiles
      return _TileConfiguration(
        urlTemplate: AppConstants.mapTileDark,
        storeName: 'darkMap',
      );
    } else if (mapType == MapType.satellite) {
      return _TileConfiguration(
        urlTemplate: AppConstants.mapTileSatellite,
        storeName: 'satelliteMap',
      );
    } else {
      return _TileConfiguration(
        urlTemplate: AppConstants.mapTileStandard,
        storeName: 'standardMap',
      );
    }
  }

  /// Initialize FMTC tile stores
  /// Call this once during app initialization or before first map usage
  static Future<void> initializeTileStores() async {
    try {
      final stores = await FMTCRoot.stats.storesAvailable;

      const storeNames = [
        'standardMap',
        'satelliteMap',
        'darkMap',
        'labelsMap',
      ];

      for (final storeName in storeNames) {
        if (!stores.contains(storeName)) {
          await FMTCStore(storeName).manage.create();
        }
      }
    } catch (e) {
      // Silently handle tile cache initialization errors
      debugPrint('BaseMapLayer: Tile cache init error: $e');
    }
  }
}

class _TileConfiguration {
  final String urlTemplate;
  final String storeName;

  _TileConfiguration({required this.urlTemplate, required this.storeName});
}
