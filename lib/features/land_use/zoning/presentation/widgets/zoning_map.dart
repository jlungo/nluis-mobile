import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../domain/entities/basemap.dart';
import '../../domain/entities/user_location.dart';
import '../../domain/entities/zoning_feature.dart';
import '../providers/zoning_providers.dart';
import '../../data/services/calculation_service.dart';
import 'feature_metadata_sheet.dart';
import 'feature_details_sheet.dart';
import 'location_indicator.dart';

const _uuid = Uuid();

class ZoningMap extends ConsumerStatefulWidget {
  final String projectId;
  final Basemap basemap;
  final ValueChanged<bool>? onCreatingFeatureChanged;
  final ZoningFeatureType? startFeatureCreation;

  const ZoningMap({
    super.key,
    required this.projectId,
    required this.basemap,
    this.onCreatingFeatureChanged,
    this.startFeatureCreation,
  });

  @override
  ConsumerState<ZoningMap> createState() => _ZoningMapState();
}

class _ZoningMapState extends ConsumerState<ZoningMap> {
  late final MapController _mapController;
  bool _isCreatingFeature = false;
  ZoningFeatureType? _activeFeatureType;
  final List<LatLng> _currentFeaturePoints = [];
  UserLocation? _lastLocation;

  MapType _mapType = MapType.standard;
  String? _mapTypeBanner;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _initializeTileStores();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fitToBoundaries();
      if (widget.startFeatureCreation != null) {
        _startFeatureCreation(widget.startFeatureCreation!);
      }
    });
  }

  @override
  void didUpdateWidget(ZoningMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.startFeatureCreation != null &&
        widget.startFeatureCreation != oldWidget.startFeatureCreation) {
      // Defer the call to after build phase completes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startFeatureCreation(widget.startFeatureCreation!);
      });
    }
  }

  Future<void> _initializeTileStores() async {
    try {
      final stores = await FMTCRoot.stats.storesAvailable;
      final storeNames = stores.map((s) => s.storeName).toList();

      if (!storeNames.contains('standardMap')) {
        await FMTCStore('standardMap').manage.create();
      }

      if (!storeNames.contains('satelliteMap')) {
        await FMTCStore('satelliteMap').manage.create();
      }

      if (!storeNames.contains('darkMap')) {
        await FMTCStore('darkMap').manage.create();
      }

      if (!storeNames.contains('labelsMap')) {
        await FMTCStore('labelsMap').manage.create();
      }
    } catch (e) {
      // Silently handle tile cache initialization errors
      debugPrint('Tile cache init error: $e');
    }
  }

  void _fitToBoundaries() {
    if (widget.basemap.boundary.isEmpty) return;
    final bounds = LatLngBounds.fromPoints(widget.basemap.boundary);
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(AppConstants.mapBoundaryFitPadding),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    if (!_isCreatingFeature || _activeFeatureType == null) return;

    setState(() {
      _currentFeaturePoints.add(point);
    });

    // Auto-complete for point features
    if (_activeFeatureType == ZoningFeatureType.point) {
      _completeFeature();
    }
  }

  void _startFeatureCreation(ZoningFeatureType featureType) {
    setState(() {
      _isCreatingFeature = true;
      _activeFeatureType = featureType;
      _currentFeaturePoints.clear();
    });
    widget.onCreatingFeatureChanged?.call(true);
  }

  void _completeFeature() {
    if (_currentFeaturePoints.isEmpty) return;

    // Minimum points validation
    if (_activeFeatureType == ZoningFeatureType.lineString &&
        _currentFeaturePoints.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Line requires at least 2 points')),
      );
      return;
    }
    if (_activeFeatureType == ZoningFeatureType.polygon &&
        _currentFeaturePoints.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Polygon requires at least 3 points')),
      );
      return;
    }

    // Open metadata bottom sheet
    _openMetadataSheet();
  }

  void _markCurrentLocation() {
    if (_lastLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Waiting for GPS location...')),
      );
      return;
    }

    setState(() {
      _currentFeaturePoints.add(_lastLocation!.position);
    });

    // Auto-complete for point features
    if (_activeFeatureType == ZoningFeatureType.point) {
      _completeFeature();
    }
  }

  void _cancelFeatureCreation() {
    setState(() {
      _isCreatingFeature = false;
      _activeFeatureType = null;
      _currentFeaturePoints.clear();
    });
    widget.onCreatingFeatureChanged?.call(false);
  }

  void _undoLastPoint() {
    if (_currentFeaturePoints.isNotEmpty) {
      setState(() {
        _currentFeaturePoints.removeLast();
      });
    }
  }

  void _openMetadataSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => FeatureMetadataSheet(
            featureType: _activeFeatureType!,
            coordinates: _currentFeaturePoints,
            onSave: (metadata) {
              _saveFeature(metadata);
              Navigator.of(context).pop();
            },
            onCancel: () {
              Navigator.of(context).pop();
              _cancelFeatureCreation();
            },
          ),
    );
  }

  void _saveFeature(Map<String, dynamic> metadata) async {
    if (_activeFeatureType == null || _currentFeaturePoints.isEmpty) return;

    // Calculate area or length
    double? area;
    double? length;

    if (_activeFeatureType == ZoningFeatureType.polygon) {
      area = CalculationService.calculatePolygonArea(_currentFeaturePoints);
    } else if (_activeFeatureType == ZoningFeatureType.lineString) {
      length = CalculationService.calculateLineLength(_currentFeaturePoints);
    }

    // TODO: Remove dummy fields like ownershipDetails
    final now = DateTime.now();
    final feature = ZoningFeature(
      clientUuid: _uuid.v4(),
      projectId: widget.projectId,
      localityId: widget.basemap.localityId.toString(),
      landUseId: metadata['landUseId'],
      featureType: _activeFeatureType!,
      srid: 4326,
      coordinates: List.from(_currentFeaturePoints),
      zoningType: ZoningType.other,
      plotId: metadata['plotId'],
      plotName: metadata['plotName'],
      notes: metadata['notes'],
      ownershipDetails: metadata['ownershipDetails'],
      area: area,
      length: length,
      isProposed: metadata['isProposed'] ?? false,
      status: 'Draft',
      source: 'mobile_app',
      version: 1,
      uploaded: false,
      isDraft: metadata['isDraft'] ?? true,
      needsSync: true,
      createdAt: now,
      updatedAt: now,
    );

    // Save feature
    await ref.read(zoningStateProvider.notifier).createFeature(feature);

    // Reset creation state
    _cancelFeatureCreation();

    // Refresh features list
    ref.invalidate(zoningFeaturesProvider(widget.projectId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final featuresAsync = ref.watch(zoningFeaturesProvider(widget.projectId));
    final locationAsync = ref.watch(
      locationStreamProvider(widget.basemap.boundary),
    );
    final landUseColors = ref.watch(landUseColorMapProvider);

    return Stack(
      children: [
        // Main Map
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: widget.basemap.center,
            initialZoom: widget.basemap.zoom,
            // minZoom: 8.0,
            maxZoom: 20.0,
            onTap: _onMapTap,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
          ),
          children: [
            // Base tile layer with caching and dark mode support
            AnimatedSwitcher(
              duration: Duration(milliseconds: AppConstants.mapFadeDuration),
              transitionBuilder:
                  (child, anim) => FadeTransition(opacity: anim, child: child),
              child: _buildTileLayer(isDark),
            ),

            // Labels overlay for satellite/dark modes
            if (_mapType != MapType.standard)
              TileLayer(
                urlTemplate: AppConstants.mapTileLabels,
                userAgentPackageName: 'tz.go.nlupc.nluis',
                tileProvider: FMTCTileProvider(stores: {'labelsMap': null}),
              ),

            // Project boundary
            PolygonLayer(
              polygons: [
                Polygon(
                  points: widget.basemap.boundary,
                  color: (isDark ? AppColors.darkPrimary : AppColors.primary)
                      .withValues(alpha: AppConstants.mapPolygonAlpha),
                  borderColor:
                      isDark ? AppColors.darkPrimary : AppColors.primary,
                  borderStrokeWidth: AppConstants.mapPolygonBorderWidth,
                  pattern: const StrokePattern.dotted(),
                ),
              ],
            ),

            // Existing features
            featuresAsync.when(
              data: (features) => _buildFeaturesLayer(features, landUseColors),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),

            // Current feature being created
            if (_isCreatingFeature && _currentFeaturePoints.isNotEmpty)
              _buildCurrentFeatureLayer(),

            // User location
            locationAsync.when(
              data: (location) {
                _lastLocation = location;
                return _buildLocationLayer(location);
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ],
        ),

        // Location indicator
        Positioned(
          top: AppConstants.spacingMd,
          right: AppConstants.spacingMd,
          child: locationAsync.when(
            data: (location) => LocationIndicator(location: location),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
        ),

        // Fixed bottom bar for feature creation controls
        if (_isCreatingFeature)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildCreationBottomBar(theme, isDark),
          ),

        // Map controls (top-left)
        Positioned(
          top: AppConstants.spacingMd,
          left: AppConstants.spacingMd,
          child: _buildMapControls(theme, isDark),
        ),

        // Short banner when switching map type
        if (_mapTypeBanner != null)
          Positioned(
            top: AppConstants.spacingMd,
            left: 0,
            right: 0,
            child: Center(
              child: Chip(
                label: Text(_mapTypeBanner!),
                backgroundColor: (isDark ? AppColors.darkSurface : Colors.black)
                    .withValues(alpha: 0.8),
                labelStyle: TextStyle(
                  color: isDark ? AppColors.darkTextPrimary : Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFeaturesLayer(
    List<ZoningFeature> features,
    Map<int, Color> landUseColors,
  ) {
    final markers = <Marker>[];
    final polylines = <Polyline>[];
    final polygons = <Polygon>[];

    for (final feature in features) {
      // Use land-use color, fallback to grey if not available
      final color =
          feature.landUseId != null
              ? (landUseColors[feature.landUseId!] ?? Colors.grey)
              : Colors.grey;

      switch (feature.featureType) {
        case ZoningFeatureType.point:
          markers.add(
            Marker(
              point: feature.coordinates.first,
              child: GestureDetector(
                onTap: () => _showFeatureDetails(feature),
                child: Icon(
                  Icons.location_pin,
                  color: color,
                  size: 32,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          );
          break;

        case ZoningFeatureType.lineString:
          polylines.add(
            Polyline(
              points: feature.coordinates,
              color: color,
              strokeWidth: 3.0,
            ),
          );
          break;

        case ZoningFeatureType.polygon:
          polygons.add(
            Polygon(
              points: feature.coordinates,
              color: color.withValues(alpha: 0.3),
              borderColor: color,
              borderStrokeWidth: 2.0,
            ),
          );
          break;
      }
    }

    return Stack(
      children: [
        if (polygons.isNotEmpty) PolygonLayer(polygons: polygons),
        if (polylines.isNotEmpty) PolylineLayer(polylines: polylines),
        if (markers.isNotEmpty) MarkerLayer(markers: markers),
      ],
    );
  }

  Widget _buildCurrentFeatureLayer() {
    if (_activeFeatureType == null || _currentFeaturePoints.isEmpty) {
      return const SizedBox.shrink();
    }

    final color = AppColors.accent;

    switch (_activeFeatureType!) {
      case ZoningFeatureType.point:
        return MarkerLayer(
          markers: [
            Marker(
              point: _currentFeaturePoints.first,
              child: Icon(
                Icons.location_pin,
                color: color,
                size: 32,
              ),
            ),
          ],
        );

      case ZoningFeatureType.lineString:
        return PolylineLayer(
          polylines: [
            Polyline(
              points: _currentFeaturePoints,
              color: color,
              strokeWidth: 3.0,
              pattern: const StrokePattern.dotted(),
            ),
          ],
        );

      case ZoningFeatureType.polygon:
        return PolygonLayer(
          polygons: [
            Polygon(
              points: _currentFeaturePoints,
              color: color.withValues(alpha: 0.3),
              borderColor: color,
              borderStrokeWidth: 2.0,
              pattern: const StrokePattern.dotted(),
            ),
          ],
        );
    }
  }

  Widget _buildLocationLayer(UserLocation location) {
    return MarkerLayer(
      markers: [
        Marker(
          point: location.position,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color:
                  location.isInsideBoundary
                      ? AppColors.success
                      : AppColors.warning,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapControls(ThemeData theme, bool isDark) {
    Widget control(IconData icon, VoidCallback onPressed) {
      return Container(
        margin: const EdgeInsets.only(bottom: AppConstants.spacingSm),
        decoration: BoxDecoration(
          color:
              isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
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
          onPressed: onPressed,
          color:
              isDark ? AppColors.surfaceVariant : AppColors.darkSurfaceVariant,
        ),
      );
    }

    return Column(
      children: [
        control(Icons.my_location, () {
          if (_lastLocation != null) {
            _mapController.move(_lastLocation!.position, 16.0);
          }
        }),
        control(Icons.explore, () {
          // Reset rotation to North
          _mapController.rotate(0.0);
        }),
        control(Icons.layers, () {
          _showMapTypeSheet();
        }),
      ],
    );
  }

  void _showMapTypeSheet() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: AppConstants.spacingMd),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.map),
                title: const Text('Standard'),
                onTap: () {
                  setState(() {
                    _mapType = MapType.standard;
                    _mapTypeBanner = 'Standard map';
                  });
                  Future.delayed(const Duration(milliseconds: 1200), () {
                    if (!mounted) return;
                    setState(() => _mapTypeBanner = null);
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.satellite_alt),
                title: const Text('Satellite'),
                onTap: () {
                  setState(() {
                    _mapType = MapType.satellite;
                    _mapTypeBanner = 'Satellite map';
                  });
                  Future.delayed(const Duration(milliseconds: 1200), () {
                    if (!mounted) return;
                    setState(() => _mapTypeBanner = null);
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFeatureDetails(ZoningFeature feature) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => FeatureDetailsSheet(
            feature: feature,
            onEdit: (updatedFeature) {
              ref
                  .read(zoningStateProvider.notifier)
                  .updateFeature(updatedFeature);
              ref.invalidate(zoningFeaturesProvider(widget.projectId));
            },
            onDelete: () {
              ref
                  .read(zoningStateProvider.notifier)
                  .deleteFeature(feature.clientUuid);
              ref.invalidate(zoningFeaturesProvider(widget.projectId));
            },
          ),
    );
  }

  Widget _buildTileLayer(bool isDark) {
    String urlTemplate;
    String storeName;

    if (isDark && _mapType == MapType.standard) {
      // Dark mode with standard tiles
      urlTemplate = AppConstants.mapTileDark;
      storeName = 'darkMap';
    } else if (_mapType == MapType.satellite) {
      urlTemplate = AppConstants.mapTileSatellite;
      storeName = 'satelliteMap';
    } else {
      urlTemplate = AppConstants.mapTileStandard;
      storeName = 'standardMap';
    }

    return TileLayer(
      key: ValueKey('tile_${isDark ? 'dark' : _mapType.name}'),
      urlTemplate: urlTemplate,
      userAgentPackageName: 'tz.go.nlupc.nluis',
      tileProvider: FMTCTileProvider(stores: {storeName: null}),
    );
  }

  Widget _buildCreationBottomBar(ThemeData theme, bool isDark) {
    final featureTypeName = _activeFeatureType?.name.toUpperCase() ?? '';
    final pointCount = _currentFeaturePoints.length;

    return Container(
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
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Feature info
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingSm,
                      vertical: AppConstants.spacingXs,
                    ),
                    decoration: BoxDecoration(
                      color: (isDark
                              ? AppColors.darkPrimary
                              : AppColors.primary)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusSm,
                      ),
                    ),
                    child: Text(
                      featureTypeName,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color:
                            isDark ? AppColors.darkPrimary : AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingSm),
                  Text(
                    '$pointCount point${pointCount != 1 ? 's' : ''}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingMd),
              // Action buttons
              Row(
                children: [
                  // Only show 'Mark Location' when user is inside boundary
                  if (_lastLocation?.isInsideBoundary ?? false) ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _markCurrentLocation,
                        icon: const Icon(Icons.my_location, size: 18),
                        label: const Text('Mark Location'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppConstants.spacingSm,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingSm),
                  ],
                  IconButton(
                    onPressed:
                        _currentFeaturePoints.isEmpty ? null : _undoLastPoint,
                    icon: const Icon(Icons.undo),
                    tooltip: 'Undo',
                    style: IconButton.styleFrom(
                      backgroundColor:
                          isDark
                              ? AppColors.darkSurfaceVariant
                              : AppColors.surfaceVariant,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingSm),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _completeFeature,
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Complete'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.spacingSm,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingSm),
                  IconButton(
                    onPressed: _cancelFeatureCreation,
                    icon: const Icon(Icons.close),
                    tooltip: 'Cancel',
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.error.withValues(alpha: 0.1),
                      foregroundColor: AppColors.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum MapType { standard, satellite }
