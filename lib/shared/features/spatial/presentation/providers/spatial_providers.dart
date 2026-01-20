import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../data/local/draft_provider.dart';
import '../../data/services/basemap_service.dart';
import '../../data/services/location_service.dart';
import '../../domain/entities/basemap.dart';
import '../../domain/entities/user_location.dart';

// Service Providers
final basemapServiceProvider = Provider<BasemapService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  final database = ref.watch(databaseProvider);
  return BasemapService(dioClient: dioClient, database: database);
});

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

// Basemap Providers
final basemapDownloadStatusProvider = FutureProvider.family<bool, String>((
  ref,
  localityId,
) async {
  final service = ref.watch(basemapServiceProvider);
  return await service.isBasemapDownloaded(localityId);
});

final basemapProvider = FutureProvider.family<Basemap?, String>((
  ref,
  localityId,
) async {
  final service = ref.watch(basemapServiceProvider);
  return await service.loadBasemap(localityId);
});

// Location Provider
final locationStreamProvider = StreamProvider.autoDispose<UserLocation>((ref) {
  final locationService = ref.watch(locationServiceProvider);
  locationService.startLocationTracking();

  ref.onDispose(() {
    locationService.stopLocationTracking();
  });

  return locationService.locationStream;
});

// Location with boundary check
final locationWithBoundaryProvider = StreamProvider.autoDispose
    .family<UserLocation, List<LatLng>>((ref, boundary) {
      final locationService = ref.watch(locationServiceProvider);

      // Start tracking with boundary
      locationService.startLocationTracking(projectBoundary: boundary);

      ref.onDispose(() {
        locationService.stopLocationTracking();
      });

      return locationService.locationStream;
    });
