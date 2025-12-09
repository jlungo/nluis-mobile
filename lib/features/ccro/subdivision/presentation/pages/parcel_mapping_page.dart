import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/offline_banner.dart';
import '../../../../../shared/widgets/empty_state_widget.dart';
import '../../../dashboard/presentation/providers/ccro_providers.dart';
import '../../../../../core/network/network_info.dart';
import '../../../../spatial/domain/entities/basemap.dart';
import '../../../../spatial/common/widgets/input_method_selection_sheet.dart';
import '../widgets/ccro_parcel_map.dart';
import '../widgets/parcel_details_sheet.dart';
import '../widgets/manual_parcel_entry_sheet.dart';

/// CCRO Parcel Mapping Page
class ParcelMappingPage extends ConsumerStatefulWidget {
  final String projectId;
  final int localityId;
  final int zoneId;
  final String? applicationId;
  final String? inputMethod;

  const ParcelMappingPage({
    super.key,
    required this.projectId,
    required this.localityId,
    required this.zoneId,
    this.applicationId,
    this.inputMethod,
  });

  @override
  ConsumerState<ParcelMappingPage> createState() => _ParcelMappingPageState();
}

class _ParcelMappingPageState extends ConsumerState<ParcelMappingPage> {
  String? _applicationId;
  bool _hasShownSheet = false;
  InputMethod? _selectedInputMethod;

  @override
  void initState() {
    super.initState();
    _applicationId = widget.applicationId;
    
    // Parse the input method from string
    if (widget.inputMethod != null) {
      switch (widget.inputMethod) {
        case 'tapping':
          _selectedInputMethod = InputMethod.tapping;
          break;
        case 'manualEntry':
          _selectedInputMethod = InputMethod.manualEntry;
          // Show manual entry sheet after frame builds
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _showManualEntrySheet();
          });
          break;
        case 'automaticRecording':
          _selectedInputMethod = InputMethod.automaticRecording;
          break;
      }
    }
  }
  
  
  void _showManualEntrySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (context) => ManualParcelEntrySheet(
        onSave: (coordinates) {
          Navigator.of(context).pop();
          _showParcelDetailsSheet(coordinates);
        },
        onCancel: () {
          Navigator.of(context).pop();
          context.pop(); // Go back to stepper
        },
      ),
    );
  }

  Basemap _createBasemapFromZone(Map<String, dynamic> zoneData) {
    // Create a Basemap entity from zone geometry
    final geom = zoneData['geom'] as Map<String, dynamic>;
    final coordinates = geom['coordinates'];

    List<LatLng> extractBoundary(dynamic coords) {
      if (coords is List) {
        // Handle both Polygon and MultiPolygon
        final firstRing = coords[0];
        if (firstRing is List && firstRing.isNotEmpty) {
          if (firstRing[0] is List) {
            // MultiPolygon - get first polygon's outer ring
            return (firstRing[0] as List).map((coord) {
              final lng = coord[0] is String
                  ? double.parse(coord[0])
                  : (coord[0] as num).toDouble();
              final lat = coord[1] is String
                  ? double.parse(coord[1])
                  : (coord[1] as num).toDouble();
              return LatLng(lat, lng);
            }).toList();
          } else {
            // Polygon - get outer ring
            return (firstRing).map<LatLng>((coord) {
              final lng = coord[0] is String
                  ? double.parse(coord[0])
                  : (coord[0] as num).toDouble();
              final lat = coord[1] is String
                  ? double.parse(coord[1])
                  : (coord[1] as num).toDouble();
              return LatLng(lat, lng);
            }).toList();
          }
        }
      }
      return [];
    }

    final boundary = extractBoundary(coordinates);

    // Calculate center from boundary
    LatLng calculateCenter(List<LatLng> points) {
      if (points.isEmpty) return const LatLng(-6.8, 39.28);

      double lat = 0, lng = 0;
      for (final point in points) {
        lat += point.latitude;
        lng += point.longitude;
      }
      return LatLng(lat / points.length, lng / points.length);
    }

    return Basemap(
      localityId: widget.localityId.toString(),
      geoJson: geom,
      boundary: boundary,
      center: calculateCenter(boundary),
      zoom: 16.0,
      downloadedAt: DateTime.now(),
      localPath: '', // Not needed for CCRO
      isValid: true,
    );
  }

  Future<void> _showParcelDetailsSheet(List<LatLng> coordinates) async {
    if (_hasShownSheet) return; // Prevent duplicate sheets
    _hasShownSheet = true;

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ParcelDetailsSheet(
        coordinates: coordinates,
        zoneId: widget.zoneId,
        localityId: widget.localityId,
        applicationId: _applicationId,
        onSave: (parcel, appId) {
          Navigator.of(context).pop({'parcel': parcel, 'applicationId': appId});
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );

    if (result != null && mounted) {
      // Update application ID if created
      if (result['applicationId'] != null) {
        setState(() {
          _applicationId = result['applicationId'];
        });
      }

      // Return to stepper with parcel data
      context.pop(result);
    } else {
      // Reset if cancelled so user can draw again
      setState(() {
        _hasShownSheet = false;
      });
    }
  }

  void _onGeometryComplete(List<LatLng> coordinates) {
    // Show parcel details sheet with captured coordinates
    _showParcelDetailsSheet(coordinates);
  }

  void _onCancelDrawing() {
    // User cancelled drawing
    setState(() {
      _hasShownSheet = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final onlineStatus = ref.watch(onlineStatusProvider);
    final isOnline = onlineStatus.maybeWhen(
      data: (value) => value,
      orElse: () => true,
    );

    final zoneAsync = ref.watch(
      subdivisionZoneWithGeometryProvider((
        zoneId: widget.zoneId,
        localityId: widget.localityId,
      )),
    );

    return Scaffold(
      appBar: CustomAppBar(title: 'Ramani ya Vipande'),
      body: SafeArea(
        child: Column(
          children: [
            if (!isOnline) const OfflineBanner(),
            Expanded(
              child: zoneAsync.when(
                data: (zone) {
                  final basemap = _createBasemapFromZone(zone);

                  return CCROParcelMap(
                    subdivisionApplicationId: _applicationId ?? '',
                    localityId: widget.localityId,
                    basemap: basemap,
                    onGeometryComplete: _onGeometryComplete,
                    onCancel: _onCancelDrawing,
                    showExistingParcels: true,
                    startDrawingImmediately: _selectedInputMethod != null &&
                        (_selectedInputMethod == InputMethod.tapping ||
                            _selectedInputMethod ==
                                InputMethod.automaticRecording),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => EmptyStateWidget(
                  icon: Icons.error_outline,
                  title: 'Hitilafu ya kupata eneo',
                  subtitle: error.toString(),
                  action: ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Rudi'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
