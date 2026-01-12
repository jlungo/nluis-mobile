import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';

import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/utils/responsive_utils.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../domain/entities/zoning_feature.dart';

/// Visual map-based coordinate editor with drag-and-drop functionality
class CoordinateEditorMap extends ConsumerStatefulWidget {
  final ZoningFeature feature;
  final Function(List<LatLng>) onSave;
  final VoidCallback onCancel;

  const CoordinateEditorMap({
    super.key,
    required this.feature,
    required this.onSave,
    required this.onCancel,
  });

  @override
  ConsumerState<CoordinateEditorMap> createState() =>
      _CoordinateEditorMapState();
}

class _CoordinateEditorMapState extends ConsumerState<CoordinateEditorMap> {
  late MapController _mapController;
  late List<LatLng> _coordinates;
  int? _draggedPointIndex;
  bool _isAddingPoint = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _coordinates = List.from(widget.feature.coordinates);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fitToFeature();
    });
  }

  void _fitToFeature() {
    if (_coordinates.isEmpty) return;

    if (_coordinates.length == 1) {
      _mapController.move(_coordinates.first, AppConstants.mapLocationZoom);
    } else {
      final bounds = LatLngBounds.fromPoints(_coordinates);
      _mapController.fitCamera(
        CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(100.0)),
      );
    }
  }

  void _deletePoint(int index) {
    if (_coordinates.length <= _getMinimumPoints()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cannot delete. Minimum ${_getMinimumPoints()} point(s) required.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _coordinates.removeAt(index);
    });
  }

  int _getMinimumPoints() {
    switch (widget.feature.featureType) {
      case ZoningFeatureType.point:
        return 1;
      case ZoningFeatureType.lineString:
        return 2;
      case ZoningFeatureType.polygon:
        return 3;
    }
  }

  void _addPointBetween(int afterIndex) {
    if (widget.feature.featureType == ZoningFeatureType.point) return;

    final nextIndex = (afterIndex + 1) % _coordinates.length;
    final midPoint = LatLng(
      (_coordinates[afterIndex].latitude + _coordinates[nextIndex].latitude) /
          2,
      (_coordinates[afterIndex].longitude + _coordinates[nextIndex].longitude) /
          2,
    );

    setState(() {
      _coordinates.insert(afterIndex + 1, midPoint);
    });
  }

  void _onMapTap(LatLng position) {
    if (_isAddingPoint &&
        widget.feature.featureType != ZoningFeatureType.point) {
      setState(() {
        _coordinates.add(position);
      });
    }
  }

  void _save() {
    if (_coordinates.length < _getMinimumPoints()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Minimum ${_getMinimumPoints()} point(s) required.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    widget.onSave(_coordinates);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter:
                  _coordinates.isNotEmpty
                      ? _coordinates.first
                      : const LatLng(0, 0),
              initialZoom: AppConstants.mapDefaultZoom,
              minZoom: AppConstants.mapMinZoom,
              maxZoom: AppConstants.mapMaxZoom,
              onTap: (_, position) => _onMapTap(position),
            ),
            children: [
              // Base map tiles
              _buildTileLayer(isDark),

              // Feature preview
              if (widget.feature.featureType == ZoningFeatureType.polygon &&
                  _coordinates.length >= 3)
                PolygonLayer(
                  polygons: [
                    Polygon(
                      points: _coordinates,
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderColor: AppColors.primary,
                      borderStrokeWidth: 3.0,
                    ),
                  ],
                ),

              if (widget.feature.featureType == ZoningFeatureType.lineString &&
                  _coordinates.length >= 2)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _coordinates,
                      color: AppColors.primary,
                      strokeWidth: 3.0,
                    ),
                  ],
                ),

              // Draggable markers for each point
              MarkerLayer(
                markers:
                    _coordinates.asMap().entries.map((entry) {
                      final index = entry.key;
                      final point = entry.value;
                      final isDragging = _draggedPointIndex == index;

                      return Marker(
                        point: point,
                        width: AppConstants.mapPointMarkerSize,
                        height: AppConstants.mapPointMarkerSize,
                        child: GestureDetector(
                          onLongPress: () => _deletePoint(index),
                          onTap: () {
                            // TODO: Implement drag to move functionality
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: isDragging ? AppConstants.mapPointMarkerSize + 4.0 : AppConstants.mapPointMarkerSize,
                                height: isDragging ? AppConstants.mapPointMarkerSize + 4.0 : AppConstants.mapPointMarkerSize,
                                decoration: BoxDecoration(
                                  color:
                                      isDragging
                                          ? AppColors.accent
                                          : AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ResponsiveUtils.fontSize(context, 14),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),

              // Mid-point add buttons (for lines and polygons)
              if (!_isAddingPoint &&
                  widget.feature.featureType != ZoningFeatureType.point)
                MarkerLayer(
                  markers:
                      _coordinates
                          .asMap()
                          .entries
                          .map((entry) {
                            final index = entry.key;
                            final nextIndex = (index + 1) % _coordinates.length;

                            // Skip last segment for line strings
                            if (widget.feature.featureType ==
                                    ZoningFeatureType.lineString &&
                                index == _coordinates.length - 1) {
                              return null;
                            }

                            final midPoint = LatLng(
                              (_coordinates[index].latitude +
                                      _coordinates[nextIndex].latitude) /
                                  2,
                              (_coordinates[index].longitude +
                                      _coordinates[nextIndex].longitude) /
                                  2,
                            );

                            return Marker(
                              point: midPoint,
                              width: 30,
                              height: 30,
                              child: GestureDetector(
                                onTap: () => _addPointBetween(index),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withValues(
                                      alpha: 0.8,
                                    ),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            );
                          })
                          .whereType<Marker>()
                          .toList(),
                ),
            ],
          ),

          // Top toolbar
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    isDark
                        ? AppColors.darkSurface.withValues(alpha: 0.95)
                        : Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edit Coordinates',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextPrimary : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_coordinates.length} point(s) • Drag to move • Long press to delete',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color:
                                isDark
                                    ? AppColors.darkTextSecondary
                                    : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.feature.featureType != ZoningFeatureType.point)
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isAddingPoint = !_isAddingPoint;
                        });
                      },
                      icon: Icon(
                        _isAddingPoint ? Icons.close : Icons.add_location_alt,
                        color:
                            _isAddingPoint
                                ? AppColors.accent
                                : AppColors.primary,
                      ),
                      tooltip:
                          _isAddingPoint
                              ? 'Cancel adding'
                              : 'Add point by tapping map',
                    ),
                ],
              ),
            ),
          ),

          // Bottom action bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).padding.bottom + 16,
              ),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onCancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                          color:
                              isDark
                                  ? AppColors.darkTextSecondary
                                  : Colors.grey,
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextPrimary : null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: AppButton(
                      label: 'Save Changes',
                      onPressed: _save,
                      gradientColors: [
                        AppColors.primary,
                        AppColors.primary.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TileLayer _buildTileLayer(bool isDark) {
    final String urlTemplate;
    final String storeName;

    if (isDark) {
      urlTemplate = AppConstants.mapTileDark;
      storeName = 'darkMap';
    } else {
      urlTemplate = AppConstants.mapTileStandard;
      storeName = 'standardMap';
    }

    return TileLayer(
      urlTemplate: urlTemplate,
      userAgentPackageName: 'com.nluis.app',
      tileProvider: FMTCTileProvider(stores: {storeName: null}),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
