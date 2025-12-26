import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/features/spatial/presentation/widgets/gps_tracker_widget.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/features/spatial/domain/entities/basemap.dart';
import '../../../../../shared/features/spatial/domain/entities/user_location.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import '../../domain/entities/zoning_feature.dart';
import '../providers/zoning_providers.dart';
import '../../../../../shared/features/spatial/data/services/calculation_service.dart';
import 'feature_metadata_sheet.dart';
import 'feature_details_sheet.dart';
import 'coordinate_editor_map.dart';
import 'manual_coordinate_entry_sheet.dart';
import '../../../../../shared/features/spatial/data/services/coordinate_converter.dart';

const _uuid = Uuid();

class ZoningMap extends ConsumerStatefulWidget {
  final String projectId;
  final Basemap basemap;
  final ValueChanged<bool>? onCreatingFeatureChanged;
  final ZoningFeatureType? startFeatureCreation;
  final String? inputMethod; // 'tapping', 'manual', or 'automatic'
  final String? highlightFeatureId; // Feature to highlight from external source

  const ZoningMap({
    super.key,
    required this.projectId,
    required this.basemap,
    this.onCreatingFeatureChanged,
    this.startFeatureCreation,
    this.inputMethod,
    this.highlightFeatureId,
  });

  @override
  ConsumerState<ZoningMap> createState() => _ZoningMapState();
}

class _ZoningMapState extends ConsumerState<ZoningMap> {
  late final MapController _mapController;
  bool _isCreatingFeature = false;
  ZoningFeatureType? _activeFeatureType;
  String? _activeInputMethod; // Track which input method is active
  final List<LatLng> _currentFeaturePoints = [];
  UserLocation? _lastLocation;
  String? _selectedFeatureId; // For highlighting selected features

  MapType _mapType = MapType.standard;
  String? _mapTypeBanner;
  bool _showServerFeatures = true;

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
        // Check input method
        if (widget.inputMethod == 'manualEntry') {
          _openManualCoordinateEntry(widget.startFeatureCreation!);
        } else if (widget.inputMethod == 'automaticRecording') {
          _startAutomaticRecording(widget.startFeatureCreation!);
        } else {
          // Default to tapping mode
          _startFeatureCreation(widget.startFeatureCreation!);
        }
      });
    }
    
    // Handle external feature highlighting
    if (widget.highlightFeatureId != null &&
        widget.highlightFeatureId != oldWidget.highlightFeatureId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _highlightAndZoomToFeature(widget.highlightFeatureId!);
      });
    }
  }
  
  void _highlightAndZoomToFeature(String featureId) async {
    final featuresAsync = ref.read(zoningFeaturesProvider(widget.projectId));
    featuresAsync.whenData((features) {
      final feature = features.firstWhere(
        (f) => f.clientUuid == featureId,
        orElse: () => features.first,
      );
      
      setState(() {
        _selectedFeatureId = featureId;
      });
      
      // Zoom to feature
      if (feature.coordinates.isNotEmpty) {
        if (feature.featureType == ZoningFeatureType.point) {
          _mapController.move(feature.coordinates.first, 18.0);
        } else {
          final bounds = LatLngBounds.fromPoints(feature.coordinates);
          _mapController.fitCamera(
            CameraFit.bounds(
              bounds: bounds,
              padding: const EdgeInsets.all(100.0),
            ),
          );
        }
      }
      
      // Show feature details after a short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _showFeatureDetails(feature);
        }
      });
    });
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
    // If creating feature, add point
    if (_isCreatingFeature && _activeFeatureType != null) {
      setState(() {
        _currentFeaturePoints.add(point);
      });

      // Auto-complete for point features
      if (_activeFeatureType == ZoningFeatureType.point) {
        _completeFeature();
      }
      return;
    }

    // Otherwise, check if we tapped on a feature
    final featuresAsync = ref.read(zoningFeaturesProvider(widget.projectId));
    featuresAsync.whenData((features) {
      final tappedFeature = _findFeatureAtPoint(point, features);
      if (tappedFeature != null) {
        _showFeatureDetails(tappedFeature);
      }
    });
  }

  void _onMapLongPress(TapPosition tapPosition, LatLng point) {
    // Don't allow editing while creating a new feature
    if (_isCreatingFeature) return;

    // Find if long-press is on a feature
    final featuresAsync = ref.read(zoningFeaturesProvider(widget.projectId));
    featuresAsync.whenData((features) {
      final tappedFeature = _findFeatureAtPoint(point, features);
        if (tappedFeature != null) {
          // Open coordinate editor for this feature
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CoordinateEditorMap(
                feature: tappedFeature,
                onSave: (updatedCoordinates) {
                  // Recalculate area/length
                  double? area;
                  double? length;

                  if (tappedFeature.featureType == ZoningFeatureType.polygon) {
                    area = CalculationService.calculatePolygonArea(updatedCoordinates);
                  } else if (tappedFeature.featureType == ZoningFeatureType.lineString) {
                    length = CalculationService.calculateLineLength(updatedCoordinates);
                  }

                  final updatedFeature = tappedFeature.copyWith(
                    coordinates: updatedCoordinates,
                    area: area,
                    length: length,
                    updatedAt: DateTime.now(),
                  );

                  ref.read(zoningStateProvider.notifier).updateFeature(updatedFeature);
                  ref.invalidate(zoningFeaturesProvider(widget.projectId));
                  
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Feature coordinates updated successfully'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                onCancel: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          );
        }
    });
  }

  void _startFeatureCreation(ZoningFeatureType featureType) {
    setState(() {
      _isCreatingFeature = true;
      _activeFeatureType = featureType;
      _activeInputMethod = 'tapping'; // Placement by tapping
      _currentFeaturePoints.clear();
    });
    widget.onCreatingFeatureChanged?.call(true);
  }

  void _startAutomaticRecording(ZoningFeatureType featureType) {
    // Check if user is inside basemap boundaries
    if (_lastLocation != null && !(_lastLocation!.isInsideBoundary)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You are not inside the basemap area. Please move to the project area or use manual coordinate entry.',
          ),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 4),
        ),
      );
      // Reset creation state so FAB reappears
      widget.onCreatingFeatureChanged?.call(false);
      return; // Don't start recording
    }

    setState(() {
      _isCreatingFeature = true;
      _activeFeatureType = featureType;
      _activeInputMethod = 'automaticRecording'; // Automatic GPS recording
      _currentFeaturePoints.clear();
    });
    widget.onCreatingFeatureChanged?.call(true);

    // Automatically add the first GPS point
    if (_lastLocation != null) {
      setState(() {
        _currentFeaturePoints.add(_lastLocation!.position);
      });

      // For point features, auto-complete immediately
      if (featureType == ZoningFeatureType.point) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _completeFeature();
          }
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Waiting for GPS location...'),
          duration: Duration(seconds: 2),
        ),
      );
    }
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
      _activeInputMethod = null; // Reset input method
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

  void _openManualCoordinateEntry(ZoningFeatureType featureType) {
    setState(() {
      _isCreatingFeature = true;
      _activeFeatureType = featureType;
      _activeInputMethod = 'manualEntry'; // Manual coordinate entry
    });
    widget.onCreatingFeatureChanged?.call(true);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => ManualCoordinateEntrySheet(
        featureType: featureType,
        onSave: (zoneName, srid, coordinates, isDraft) {
          // Convert coordinates from the selected SRID to WGS84
          CoordinateConverter.initialize();
          final wgs84Coordinates = coordinates.map((coord) {
            return CoordinateConverter.toWGS84(
              x: coord[0],
              y: coord[1],
              fromSrid: srid,
            );
          }).toList();

          setState(() {
            _currentFeaturePoints.clear();
            _currentFeaturePoints.addAll(wgs84Coordinates);
          });

          // Close the manual entry sheet
          Navigator.of(context).pop();

          // Open metadata sheet to complete the feature
          _openMetadataSheet();
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
            minZoom: AppConstants.mapMinZoom,
            maxZoom: AppConstants.mapMaxZoom,
            onTap: _onMapTap,
            onLongPress: _onMapLongPress,
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

            // Existing features (split into local and server)
            featuresAsync.when(
              data: (features) {
                // Separate local and server features
                final localFeatures = features.where((f) => !f.uploaded).toList();
                final serverFeatures = features.where((f) => f.uploaded).toList();
                
                return Stack(
                  children: [
                    // Server features (from MVT tiles) - render first (behind)
                    if (_showServerFeatures && serverFeatures.isNotEmpty)
                      _buildFeaturesLayer(
                        serverFeatures,
                        landUseColors,
                        strokeWidth: 2.0,
                        fillOpacity: 0.15,
                        borderOpacity: 0.6,
                      ),
                    // Local features (created on device) - render on top
                    if (localFeatures.isNotEmpty)
                      _buildFeaturesLayer(
                        localFeatures,
                        landUseColors,
                        strokeWidth: 3.0,
                        fillOpacity: 0.3,
                        borderOpacity: 1.0,
                      ),
                  ],
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),

            // Current feature being created
            if (_isCreatingFeature && _currentFeaturePoints.isNotEmpty)
              _buildCurrentFeatureLayer(),

            // User location indicator
            locationAsync.when(
              data: (location) {
                _lastLocation = location;
                return CurrentLocationLayer(
                  style: LocationMarkerStyle(
                    marker: DefaultLocationMarker(color: AppColors.primary),
                    markerSize: const Size.square(AppConstants.mapMarkerSize),
                    accuracyCircleColor: AppColors.primary.withValues(alpha: 0.15),
                    headingSectorColor: AppColors.primary.withValues(alpha: 0.4),
                    headingSectorRadius: location.accuracy,
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ],
        ),

        // GPSA Tracker indicator
        Positioned(
          top: AppConstants.spacing2xl - 8,
          right: AppConstants.spacingMd,
          child: locationAsync.when(
            data: (location) => GPSTrackerWidget(location: location),
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
          top: AppConstants.spacing2xl - 8,
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
    Map<int, Color> landUseColors, {
    double strokeWidth = 3.0,
    double fillOpacity = 0.3,
    double borderOpacity = 1.0,
  }) {
    final markers = <Marker>[];
    final polylines = <Polyline>[];
    final polygons = <Polygon>[];

    for (final feature in features) {
      final isSelected = _selectedFeatureId == feature.clientUuid;
      
      // Use land-use color, fallback to grey if not available
      final baseColor =
          feature.landUseId != null
              ? (landUseColors[feature.landUseId!] ?? Colors.grey)
              : Colors.grey;
      
      // Apply border opacity to color
      final color = baseColor.withValues(alpha: borderOpacity);

      switch (feature.featureType) {
        case ZoningFeatureType.point:
          markers.add(
            Marker(
              point: feature.coordinates.first,
              child: GestureDetector(
                onTap: () => _showFeatureDetails(feature),
                child: Icon(
                  Icons.location_pin,
                  color: isSelected ? AppColors.accent : color,
                  size: isSelected ? 40 : 32,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: isSelected ? 6 : 4,
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
              color: isSelected ? AppColors.accent : color,
              strokeWidth: isSelected ? (strokeWidth + 2.0) : strokeWidth,
            ),
          );
          break;

        case ZoningFeatureType.polygon:
          polygons.add(
            Polygon(
              points: feature.coordinates,
              color: (isSelected ? AppColors.accent : baseColor).withValues(
                alpha: isSelected ? 0.4 : fillOpacity,
              ),
              borderColor: isSelected ? AppColors.accent : color,
              borderStrokeWidth: isSelected ? (strokeWidth + 1.0) : strokeWidth,
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
        // Server features toggle
        Container(
          margin: const EdgeInsets.only(bottom: AppConstants.spacingSm),
          decoration: BoxDecoration(
            color: _showServerFeatures
                ? AppColors.primary.withValues(alpha: 0.9)
                : (isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant),
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
            icon: Icon(
              _showServerFeatures ? Icons.cloud_done : Icons.cloud_off,
            ),
            tooltip: _showServerFeatures 
                ? 'Ficha vipimo vya seva' 
                : 'Onyesha vipimo vya seva',
            onPressed: () {
              setState(() {
                _showServerFeatures = !_showServerFeatures;
              });
            },
            color: _showServerFeatures
                ? Colors.white
                : (isDark ? AppColors.surfaceVariant : AppColors.darkSurfaceVariant),
          ),
        ),
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

  /// Finds if a tapped point intersects with any feature
  ZoningFeature? _findFeatureAtPoint(
    LatLng tappedPoint,
    List<ZoningFeature> features,
  ) {
    const double tolerance = 0.0001; // ~11 meters at equator

    for (final feature in features) {
      switch (feature.featureType) {
        case ZoningFeatureType.point:
          // Check if tap is near the point marker
          final distance = const Distance().distance(
            tappedPoint,
            feature.coordinates.first,
          );
          if (distance < 30) {
            // 30 meters radius
            return feature;
          }
          break;

        case ZoningFeatureType.lineString:
          // Check if tap is near any line segment
          if (_isPointNearPolyline(tappedPoint, feature.coordinates, tolerance)) {
            return feature;
          }
          break;

        case ZoningFeatureType.polygon:
          // Check if point is inside polygon or near boundary
          if (_isPointInPolygon(tappedPoint, feature.coordinates) ||
              _isPointNearPolyline(tappedPoint, feature.coordinates, tolerance)) {
            return feature;
          }
          break;
      }
    }
    return null;
  }

  /// Check if point is inside a polygon using ray casting algorithm
  bool _isPointInPolygon(LatLng point, List<LatLng> polygon) {
    int intersections = 0;
    for (int i = 0; i < polygon.length; i++) {
      final v1 = polygon[i];
      final v2 = polygon[(i + 1) % polygon.length];

      if ((v1.latitude <= point.latitude && point.latitude < v2.latitude) ||
          (v2.latitude <= point.latitude && point.latitude < v1.latitude)) {
        final xIntersect = (point.latitude - v1.latitude) *
                (v2.longitude - v1.longitude) /
                (v2.latitude - v1.latitude) +
            v1.longitude;

        if (point.longitude < xIntersect) {
          intersections++;
        }
      }
    }
    return intersections % 2 == 1;
  }

  /// Check if point is near a polyline/polygon boundary
  bool _isPointNearPolyline(
    LatLng point,
    List<LatLng> polyline,
    double tolerance,
  ) {
    for (int i = 0; i < polyline.length - 1; i++) {
      final p1 = polyline[i];
      final p2 = polyline[i + 1];

      final distance = _distanceToSegment(point, p1, p2);
      if (distance < tolerance) {
        return true;
      }
    }
    return false;
  }

  /// Calculate perpendicular distance from point to line segment
  double _distanceToSegment(LatLng point, LatLng lineStart, LatLng lineEnd) {
    final x0 = point.longitude;
    final y0 = point.latitude;
    final x1 = lineStart.longitude;
    final y1 = lineStart.latitude;
    final x2 = lineEnd.longitude;
    final y2 = lineEnd.latitude;

    final dx = x2 - x1;
    final dy = y2 - y1;

    if (dx == 0 && dy == 0) {
      // Line segment is a point
      return ((x0 - x1) * (x0 - x1) + (y0 - y1) * (y0 - y1)).abs();
    }

    final t = ((x0 - x1) * dx + (y0 - y1) * dy) / (dx * dx + dy * dy);

    if (t < 0) {
      // Beyond start point
      return ((x0 - x1) * (x0 - x1) + (y0 - y1) * (y0 - y1)).abs();
    } else if (t > 1) {
      // Beyond end point
      return ((x0 - x2) * (x0 - x2) + (y0 - y2) * (y0 - y2)).abs();
    }

    // Closest point is on the segment
    final projX = x1 + t * dx;
    final projY = y1 + t * dy;
    return ((x0 - projX) * (x0 - projX) + (y0 - projY) * (y0 - projY)).abs();
  }

  void _showFeatureDetails(ZoningFeature feature) {
    setState(() {
      _selectedFeatureId = feature.clientUuid;
    });

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
    ).whenComplete(() {
      setState(() {
        _selectedFeatureId = null;
      });
    });
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
                  // Only show 'Mark Location' for automatic recording mode
                  if (_activeInputMethod == 'automaticRecording' &&
                      (_lastLocation?.isInsideBoundary ?? false)) ...[
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
