import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:latlong2/latlong.dart';

enum MapType { standard, satellite }

class ParcelMappingPage extends ConsumerStatefulWidget {
  final int applicationId;
  final int localityId;
  final String applicationNumber;

  const ParcelMappingPage({
    super.key,
    required this.applicationId,
    required this.localityId,
    required this.applicationNumber,
  });

  @override
  ConsumerState<ParcelMappingPage> createState() => _ParcelMappingPageState();
}

class _ParcelMappingPageState extends ConsumerState<ParcelMappingPage> {
  late final MapController _mapController;
  bool _isMapReady = false;
  InputMethod? _selectedInputMethod;
  bool _isRecording = false;
  final List<LatLng> _currentFeaturePoints = [];
  UserLocation? _lastLocation;

  // For basemap and parcels
  List<LatLng> _localityBoundary = [];
  List<List<LatLng>> _existingParcels = [];

  // Map configuration
  MapType _mapType = MapType.standard;
  String? _mapTypeBanner;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _initializeTileStores();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkBasemap();
    });
  }

  Future<void> _initializeTileStores() async {
    try {
      final stores = await FMTCRoot.stats.storesAvailable;

      const storeNames = ['standardMap', 'satelliteMap'];

      for (final storeName in storeNames) {
        if (!stores.contains(storeName)) {
          await FMTCStore(storeName).manage.create();
        }
      }
    } catch (e) {
      // Silently handle tile cache initialization errors
      debugPrint('Tile cache init error: $e');
    }
  }

  Future<void> _checkBasemap() async {
    final basemapService = ref.read(basemapServiceProvider);
    final isDownloaded = await basemapService.isBasemapDownloaded(
      widget.localityId.toString(),
    );

    if (!isDownloaded && mounted) {
      _showBasemapDownloadDialog();
    } else {
      _loadBasemap();
    }
  }

  void _showBasemapDownloadDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => BasemapDownloadDialog(
            projectId: widget.applicationId.toString(),
            localityId: widget.localityId.toString(),
            onDownloadComplete: () {
              Navigator.of(context).pop();
              _loadBasemap();
            },
            onCancel: () {
              Navigator.of(context).pop();
              _loadLocalityBoundaryFromApi(); // Fall back to API
            },
          ),
    );
  }

  Future<void> _loadBasemap() async {
    try {
      // First try to load from local storage using basemapService
      final basemapService = ref.read(basemapServiceProvider);
      final basemap = await basemapService.loadBasemap(
        widget.localityId.toString(),
      );

      if (basemap != null) {
        _extractLocalityBoundary(basemap.geoJson);
        _fitToBoundaries();
      } else {
        // If basemap not available locally, fetch directly from API
        await _loadLocalityBoundaryFromApi();
      }

      // Load existing parcels
      await _loadExistingParcels();

      setState(() {
        _isMapReady = true;
      });
    } catch (e) {
      debugPrint('Error loading basemap: $e');
      // If all else fails, try to load directly from API
      await _loadLocalityBoundaryFromApi();
    }
  }

  Future<void> _loadLocalityBoundaryFromApi() async {
    try {
      final apiService = ref.read(adjudicationApiServiceProvider);
      final geojson = await apiService.getLocalityBoundary(widget.localityId);
      _extractLocalityBoundary(geojson);
      _fitToBoundaries();
    } catch (e) {
      debugPrint('Error loading locality boundary from API: $e');
      setState(() {
        _isMapReady = true; // Set to true anyway to show the map
      });
    }
  }

  void _extractLocalityBoundary(Map<String, dynamic> geojson) {
    try {
      if (geojson['features'] == null ||
          (geojson['features'] as List).isEmpty ||
          geojson['features'][0]['geometry'] == null ||
          geojson['features'][0]['geometry']['coordinates'] == null) {
        return;
      }

      final feature = geojson['features'][0];
      final geometry = feature['geometry'];

      List<List<List<double>>> coordinates;

      // Extract coordinates based on geometry type
      if (geometry['type'] == 'MultiPolygon') {
        // For MultiPolygon, take first polygon's coordinates
        coordinates =
            (geometry['coordinates'][0] as List)
                .map<List<List<double>>>(
                  (ring) =>
                      (ring as List)
                          .map<List<double>>(
                            (coord) => (coord as List).cast<double>(),
                          )
                          .toList(),
                )
                .toList();
      } else if (geometry['type'] == 'Polygon') {
        // For Polygon, take the coordinates directly
        coordinates =
            (geometry['coordinates'] as List)
                .map<List<List<double>>>(
                  (ring) =>
                      (ring as List)
                          .map<List<double>>(
                            (coord) => (coord as List).cast<double>(),
                          )
                          .toList(),
                )
                .toList();
      } else {
        return; // Unsupported geometry type
      }

      // Convert to LatLng points for the first ring (outer boundary)
      if (coordinates.isNotEmpty) {
        _localityBoundary =
            coordinates[0].map((coord) => LatLng(coord[1], coord[0])).toList();
      }
    } catch (e) {
      debugPrint('Error extracting locality boundary: $e');
    }
  }

  void _fitToBoundaries() {
    if (_localityBoundary.isEmpty) return;
    final bounds = LatLngBounds.fromPoints(_localityBoundary);
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(AppConstants.mapBoundaryFitPadding),
      ),
    );
  }

  Future<void> _loadExistingParcels() async {
    // Load existing parcels from API
    try {
      final apiService = ref.read(adjudicationApiServiceProvider);
      final geojson = await apiService.getParcelsGeoJson(widget.applicationId);
      _extractParcels(geojson);
    } catch (e) {
      debugPrint('Error loading existing parcels: $e');
    }
  }

  void _extractParcels(Map<String, dynamic> geojson) {
    try {
      if (geojson['features'] == null) return;

      _existingParcels = [];

      for (final feature in geojson['features']) {
        if (feature['geometry'] == null ||
            feature['geometry']['coordinates'] == null) {
          continue;
        }

        final geometry = feature['geometry'];

        List<List<double>> coordinates;

        if (geometry['type'] == 'Polygon') {
          // Take the outer ring of the polygon
          coordinates =
              (geometry['coordinates'][0] as List)
                  .map<List<double>>((coord) => (coord as List).cast<double>())
                  .toList();

          // Convert to LatLng points
          final parcel =
              coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();

          _existingParcels.add(parcel);
        }
      }
    } catch (e) {
      debugPrint('Error extracting parcels: $e');
    }
  }

  void _showInputMethodSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => InputMethodSelectionSheet(
            featureType: ZoningFeatureType.polygon, // Parcels are polygons
            onMethodSelected: (inputMethod) {
              setState(() {
                _selectedInputMethod = inputMethod;
                _isRecording = true;
                _currentFeaturePoints.clear();
              });
            },
          ),
    );
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    // If creating feature, add point
    if (_isRecording && _selectedInputMethod != null) {
      setState(() {
        _currentFeaturePoints.add(point);
      });
    }
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
  }

  void _undoLastPoint() {
    if (_currentFeaturePoints.isNotEmpty) {
      setState(() {
        _currentFeaturePoints.removeLast();
      });
    }
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
      _selectedInputMethod = null;
    });
  }

  Future<void> _saveParcel() async {
    if (_currentFeaturePoints.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Polygon requires at least 3 points'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    try {
      // Calculate area
      final area = CalculationService.calculatePolygonArea(
        _currentFeaturePoints,
      );

      // Convert the points to the format expected by the API
      final List<List<List<double>>> coordinates = [
        _currentFeaturePoints
            .map((point) => [point.longitude, point.latitude])
            .toList(),
      ];

      // Ensure the polygon is closed
      if (coordinates[0].first[0] != coordinates[0].last[0] ||
          coordinates[0].first[1] != coordinates[0].last[1]) {
        coordinates[0].add(coordinates[0].first);
      }

      // Create parcel data
      final parcelData = {
        'application': widget.applicationId,
        'geometry': {'type': 'Polygon', 'coordinates': coordinates},
        'area_acres': area * 0.000247105, // Convert square meters to acres
        'meta': {
          'input_method': _selectedInputMethod?.name ?? 'manual',
          'recorded_by_app': true,
        },
      };

      final repository = ref.read(adjudicationRepositoryProvider);
      final result = await repository.createParcel(parcelData);

      result.fold(
        (failure) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Hitilafu: ${failure.message}'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        (parcel) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Kiwanja kimehifadhiwa'),
                backgroundColor: AppColors.success,
              ),
            );

            // Reload parcels to show the newly created one
            _loadExistingParcels();

            // Reset recording state
            setState(() {
              _isRecording = false;
              _selectedInputMethod = null;
              _currentFeaturePoints.clear();
            });
          }
        },
      );
    } catch (e) {
      debugPrint('Error saving parcel: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hitilafu: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Widget _buildTileLayer(bool isDark) {
    final config = _getTileConfiguration(isDark);
    return TileLayer(
      urlTemplate: config.urlTemplate,
      userAgentPackageName: 'tz.go.nlupc.nluis',
      tileProvider: FMTCTileProvider(stores: {config.storeName: null}),
    );
  }

  _TileConfiguration _getTileConfiguration(bool isDark) {
    if (isDark && _mapType == MapType.standard) {
      return _TileConfiguration(
        urlTemplate: AppConstants.mapTileDark,
        storeName: 'darkMap',
      );
    } else if (_mapType == MapType.satellite) {
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

  void _showMapTypeSheet() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final locationAsync = ref.watch(locationStreamProvider(_localityBoundary));

    return Scaffold(
      appBar: AppBar(
        title: Text('Ramani: ${widget.applicationNumber}'),
        actions: [
          if (_isRecording)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveParcel,
              tooltip: 'Hifadhi',
            ),
          if (_isRecording)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _stopRecording,
              tooltip: 'Ghairi',
            ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(
                -6.7924,
                39.2083,
              ), // Default: Tanzania
              initialZoom: 6.0,
              minZoom: AppConstants.mapMinZoom,
              maxZoom: AppConstants.mapMaxZoom,
              onTap: _onMapTap,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              // Base tile layer
              AnimatedSwitcher(
                duration: Duration(milliseconds: AppConstants.mapFadeDuration),
                transitionBuilder:
                    (child, anim) =>
                        FadeTransition(opacity: anim, child: child),
                child: _buildTileLayer(isDark),
              ),

              // Labels overlay for satellite mode
              if (_mapType == MapType.satellite)
                TileLayer(
                  urlTemplate: AppConstants.mapTileLabels,
                  userAgentPackageName: 'tz.go.nlupc.nluis',
                  tileProvider: FMTCTileProvider(stores: {'labelsMap': null}),
                ),

              // Locality boundary
              if (_localityBoundary.isNotEmpty)
                PolygonLayer(
                  polygons: [
                    Polygon(
                      points: _localityBoundary,
                      color: (isDark
                              ? AppColors.darkPrimary
                              : AppColors.primary)
                          .withValues(alpha: AppConstants.mapPolygonAlpha),
                      borderColor:
                          isDark ? AppColors.darkPrimary : AppColors.primary,
                      borderStrokeWidth: AppConstants.mapPolygonBorderWidth,
                      pattern: const StrokePattern.dotted(),
                    ),
                  ],
                ),

              // Existing parcels
              if (_existingParcels.isNotEmpty)
                PolygonLayer(
                  polygons:
                      _existingParcels
                          .map(
                            (parcel) => Polygon(
                              points: parcel,
                              color: AppColors.success.withValues(alpha: 0.3),
                              borderColor: AppColors.success,
                              borderStrokeWidth: 2.0,
                            ),
                          )
                          .toList(),
                ),

              // Current feature being created
              if (_isRecording && _currentFeaturePoints.isNotEmpty)
                PolygonLayer(
                  polygons: [
                    Polygon(
                      points: _currentFeaturePoints,
                      color: AppColors.accent.withValues(alpha: 0.3),
                      borderColor: AppColors.accent,
                      borderStrokeWidth: 2.0,
                      pattern: const StrokePattern.dotted(),
                    ),
                  ],
                ),

              // Current points as markers
              if (_isRecording && _currentFeaturePoints.isNotEmpty)
                MarkerLayer(
                  markers:
                      _currentFeaturePoints
                          .map(
                            (point) => Marker(
                              point: point,
                              child: Icon(
                                Icons.circle,
                                color: AppColors.accent,
                                size: 12,
                              ),
                            ),
                          )
                          .toList(),
                ),

              // User location indicator
              locationAsync.when(
                data: (location) {
                  _lastLocation = location;
                  return CurrentLocationLayer(
                    style: LocationMarkerStyle(
                      marker: DefaultLocationMarker(color: AppColors.primary),
                      markerSize: const Size.square(AppConstants.mapMarkerSize),
                      accuracyCircleColor: AppColors.primary.withValues(
                        alpha: 0.15,
                      ),
                      headingSectorColor: AppColors.primary.withValues(
                        alpha: 0.4,
                      ),
                      headingSectorRadius: location.accuracy,
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ],
          ),

          // Map controls (top-left)
          Positioned(
            top: AppConstants.spacing2xl - 8,
            left: AppConstants.spacingMd,
            child: _buildMapControls(theme, isDark),
          ),

          // Recording controls
          if (_isRecording)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildCreationBottomBar(theme, isDark),
            ),

          // Loading indicator
          if (!_isMapReady)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator()),
            ),

          // Recording indicator
          if (_isRecording)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                color: AppColors.warning,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.fiber_manual_record,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Inaandika: ${_selectedInputMethod?.name ?? ""}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Map type banner
          if (_mapTypeBanner != null)
            Positioned(
              top: AppConstants.spacingMd,
              left: 0,
              right: 0,
              child: Center(
                child: Chip(
                  label: Text(_mapTypeBanner!),
                  backgroundColor: (isDark
                          ? AppColors.darkSurface
                          : Colors.black)
                      .withValues(alpha: 0.8),
                  labelStyle: TextStyle(
                    color: isDark ? AppColors.darkTextPrimary : Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton:
          !_isRecording && _isMapReady
              ? FloatingActionButton.extended(
                onPressed: _showInputMethodSelection,
                icon: const Icon(Icons.add_location_alt),
                label: const Text('Rekodi Kiwanja'),
              )
              : null,
    );
  }

  Widget _buildMapControls(ThemeData theme, bool isDark) {
    Widget control(IconData icon, VoidCallback onPressed, {String? tooltip}) {
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
          tooltip: tooltip,
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
        }, tooltip: 'Nenda kwenye eneo langu'),
        control(
          Icons.explore,
          () => _mapController.rotate(0.0),
          tooltip: 'Reset compass',
        ),
        control(
          Icons.fit_screen,
          _fitToBoundaries,
          tooltip: 'Onyesha mipaka yote',
        ),
        control(
          Icons.layers,
          _showMapTypeSheet,
          tooltip: 'Badili aina ya ramani',
        ),
      ],
    );
  }

  Widget _buildCreationBottomBar(ThemeData theme, bool isDark) {
    return Container(
      color: isDark ? AppColors.darkSurface : AppColors.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: AppConstants.spacingSm,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCreationButton(
              icon: Icons.undo,
              label: 'Futa Mwisho',
              onTap: _undoLastPoint,
              isDisabled: _currentFeaturePoints.isEmpty,
            ),
            _buildCreationButton(
              icon: Icons.my_location,
              label: 'Weka GPS',
              onTap: _markCurrentLocation,
              isDisabled: _lastLocation == null,
            ),
            _buildCreationButton(
              icon: Icons.check,
              label: 'Maliza',
              onTap: _saveParcel,
              isDisabled: _currentFeaturePoints.length < 3,
              isAccent: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreationButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDisabled = false,
    bool isAccent = false,
  }) {
    final color = isAccent ? AppColors.accent : AppColors.primary;

    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: GestureDetector(
        onTap: isDisabled ? null : onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}

class _TileConfiguration {
  final String urlTemplate;
  final String storeName;

  _TileConfiguration({required this.urlTemplate, required this.storeName});
}
