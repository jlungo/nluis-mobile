import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../spatial/data/services/calculation_service.dart';
import '../../../../spatial/domain/entities/basemap.dart';
import '../../../../spatial/domain/entities/user_location.dart';
import '../../../../spatial/presentation/providers/spatial_providers.dart';
import '../../../../spatial/presentation/widgets/base_map_layer.dart';
import '../../../../spatial/presentation/widgets/location_indicator.dart';
import '../../../../spatial/presentation/widgets/map_controls_widget.dart';
import '../../../../spatial/presentation/widgets/map_type_switcher.dart';
import '../../data/services/parcel_geometry_service.dart';

/// Callback for when parcel geometry is completed
typedef OnParcelGeometryComplete = void Function(List<LatLng> coordinates);

/// CCRO-specific map widget for parcel drawing (polygon only)
class CCROParcelMap extends ConsumerStatefulWidget {
  final String subdivisionApplicationId;
  final int localityId;
  final Basemap basemap;
  final OnParcelGeometryComplete onGeometryComplete;
  final VoidCallback? onCancel;
  final bool showExistingParcels;
  final bool startDrawingImmediately;

  const CCROParcelMap({
    super.key,
    required this.subdivisionApplicationId,
    required this.localityId,
    required this.basemap,
    required this.onGeometryComplete,
    this.onCancel,
    this.showExistingParcels = true,
    this.startDrawingImmediately = false,
  });

  @override
  ConsumerState<CCROParcelMap> createState() => _CCROParcelMapState();
}

class _CCROParcelMapState extends ConsumerState<CCROParcelMap> {
  late final MapController _mapController;
  final List<LatLng> _currentParcelPoints = [];
  UserLocation? _lastLocation;
  MapType _mapType = MapType.standard;
  String? _mapTypeBanner;
  bool _isDrawing = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    // Initialize tile stores
    BaseMapLayer.initializeTileStores();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fitToBoundaries();
      
      // Start drawing immediately if requested
      if (widget.startDrawingImmediately) {
        _startDrawing();
      }
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
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

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    if (!_isDrawing) return;

    setState(() {
      _currentParcelPoints.add(point);
    });
  }

  void _startDrawing() {
    setState(() {
      _isDrawing = true;
      _currentParcelPoints.clear();
    });
  }

  void _undoLastPoint() {
    if (_currentParcelPoints.isNotEmpty) {
      setState(() {
        _currentParcelPoints.removeLast();
      });
    }
  }

  void _completeParcel() {
    if (_currentParcelPoints.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A parcel must have at least 3 points'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Validate polygon
    if (!ParcelGeometryService.validatePolygon(_currentParcelPoints)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invalid polygon geometry. Please check for self-intersections.',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Return coordinates to parent
    widget.onGeometryComplete(_currentParcelPoints);
  }

  void _cancelDrawing() {
    setState(() {
      _isDrawing = false;
      _currentParcelPoints.clear();
    });
    widget.onCancel?.call();
  }

  void _markCurrentLocation() {
    if (_lastLocation != null && _lastLocation!.isInsideBoundary) {
      setState(() {
        _currentParcelPoints.add(_lastLocation!.position);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final locationAsync = ref.watch(
      locationWithBoundaryProvider(widget.basemap.boundary),
    );

    return Stack(
      children: [
        // Main Map
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: widget.basemap.center,
            initialZoom: widget.basemap.zoom,
            onTap: _onMapTap,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
          ),
          children: [
            // Base tile layer
            BaseMapLayer(mapType: _mapType, isDarkMode: isDark),

            // Basemap boundary
            if (widget.basemap.boundary.isNotEmpty)
              PolygonLayer(
                polygons: [
                  Polygon(
                    points: widget.basemap.boundary,
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderColor: AppColors.primary,
                    borderStrokeWidth: 2.0,
                    pattern: StrokePattern.dashed(segments: [10, 5]),
                  ),
                ],
              ),

            // Current parcel being drawn
            if (_isDrawing && _currentParcelPoints.isNotEmpty)
              _buildCurrentParcelLayer(),

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

        // Map controls
        Positioned(
          top: AppConstants.spacingMd,
          left: AppConstants.spacingMd,
          child: MapControlsWidget(
            onMyLocation: () {
              if (_lastLocation != null) {
                _mapController.move(_lastLocation!.position, 16.0);
              }
            },
            onRotateNorth: () {
              _mapController.rotate(0.0);
            },
            onLayerSwitch: () {
              MapTypeSwitcher.show(
                context: context,
                currentType: _mapType,
                onTypeSelected: (type) {
                  setState(() {
                    _mapType = type;
                    _mapTypeBanner =
                        type == MapType.standard
                            ? 'Standard map'
                            : 'Satellite map';
                  });
                  Future.delayed(const Duration(milliseconds: 1200), () {
                    if (!mounted) return;
                    setState(() => _mapTypeBanner = null);
                  });
                },
              );
            },
            isDarkMode: isDark,
          ),
        ),

        // Map type banner
        if (_mapTypeBanner != null)
          Positioned(
            top: AppConstants.spacingMd,
            left: 0,
            right: 0,
            child: MapTypeBanner(message: _mapTypeBanner!, isDarkMode: isDark),
          ),

        // Drawing controls
        if (_isDrawing)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildDrawingControls(theme, isDark),
          ),

        // Start drawing FAB
        if (!_isDrawing)
          Positioned(
            bottom: AppConstants.spacingSm,
            right: AppConstants.spacingSm,
            child: FloatingActionButton.extended(
              onPressed: _startDrawing,
              icon: const Icon(Icons.landscape),
              label: const Text('Rekodi Kipande'),
            ),
          ),
      ],
    );
  }

  Widget _buildCurrentParcelLayer() {
    final color = AppColors.accent;

    return PolygonLayer(
      polygons: [
        Polygon(
          points: _currentParcelPoints,
          color: color.withValues(alpha: 0.3),
          borderColor: color,
          borderStrokeWidth: 2.0,
          pattern: StrokePattern.dotted(spacingFactor: 2),
        ),
      ],
    );
  }

  Widget _buildLocationLayer(UserLocation location) {
    return MarkerLayer(
      markers: [
        Marker(
          point: location.position,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
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

  Widget _buildDrawingControls(ThemeData theme, bool isDark) {
    final pointCount = _currentParcelPoints.length;
    final area =
        pointCount >= 3
            ? CalculationService.calculatePolygonArea(_currentParcelPoints)
            : 0.0;

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
              // Parcel info
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
                      'PARCEL',
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
                  if (pointCount >= 3) ...[
                    const SizedBox(width: AppConstants.spacingSm),
                    Text(
                      '• ${CalculationService.formatArea(area)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            isDark
                                ? AppColors.darkTextSecondary
                                : AppConstants.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppConstants.spacingMd),
              // Action buttons
              Row(
                children: [
                  // Mark Location button (if GPS available)
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
                        _currentParcelPoints.isEmpty ? null : _undoLastPoint,
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
                      onPressed:
                          _currentParcelPoints.length >= 3
                              ? _completeParcel
                              : null,
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
                    onPressed: _cancelDrawing,
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
