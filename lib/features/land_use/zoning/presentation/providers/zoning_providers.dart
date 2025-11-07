import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../data/local/draft_provider.dart';
import '../../../../../features/auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/zoning_repository_impl.dart';
import '../../data/services/basemap_storage_service.dart';
import '../../data/services/location_service.dart';
import '../../data/services/land_use_api_service.dart';
import '../../data/services/zoning_api_service.dart';
import '../../domain/entities/basemap.dart';
import '../../domain/entities/user_location.dart';
import '../../domain/entities/zoning_feature.dart';
import '../../domain/entities/land_use.dart';
import '../../domain/repositories/zoning_repository.dart';

// Service Providers
final basemapStorageServiceProvider = Provider<BasemapStorageService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  final database = ref.watch(databaseProvider);
  return BasemapStorageService(dioClient: dioClient, database: database);
});

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

// Land Use API service
final landUseApiServiceProvider = Provider<LandUseApiService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return LandUseApiService(dioClient: dioClient);
});

// Zoning API service for bulk uploads
final zoningApiServiceProvider = Provider<ZoningApiService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ZoningApiService(dioClient: dioClient);
});

// Fetch and cache land uses
final landUsesProvider = FutureProvider<List<LandUse>>((ref) async {
  final api = ref.watch(landUseApiServiceProvider);
  final landUses = await api.fetchLandUses();
  return landUses;
});

// Map of land_use_id -> LandUse entity for easy lookup
final landUseMapProvider = Provider<Map<int, LandUse>>((ref) {
  final landUsesAsync = ref.watch(landUsesProvider);
  return landUsesAsync.maybeWhen(
    data: (landUses) {
      final map = <int, LandUse>{};
      for (final lu in landUses) {
        map[lu.id] = lu;
      }
      return map;
    },
    orElse: () => const <int, LandUse>{},
  );
});

// Map of land_use_id -> Color parsed from API color/style
final landUseColorMapProvider = Provider<Map<int, Color>>((ref) {
  final landUsesAsync = ref.watch(landUsesProvider);
  return landUsesAsync.maybeWhen(
    data: (landUses) {
      final map = <int, Color>{};
      for (final lu in landUses) {
        final hex = lu.displayColor; // e.g. #RRGGBB
        map[lu.id] = _parseHexColor(hex);
      }
      return map;
    },
    orElse: () => const <int, Color>{},
  );
});

Color _parseHexColor(String hex) {
  var value = hex.replaceAll('#', '').trim();
  if (value.length == 6) {
    value = 'FF$value';
  }
  final intColor = int.tryParse(value, radix: 16) ?? 0xFF808080;
  return Color(intColor);
}

// Repository Provider
final zoningRepositoryProvider = Provider<ZoningRepository>((ref) {
  final storageService = ref.watch(basemapStorageServiceProvider);
  final locationService = ref.watch(locationServiceProvider);
  final database = ref.watch(databaseProvider);

  return ZoningRepositoryImpl(
    storageService: storageService,
    locationService: locationService,
    database: database,
  );
});

// Basemap Providers
final basemapDownloadStatusProvider = FutureProvider.family<bool, String>((
  ref,
  localityId,
) async {
  final repository = ref.watch(zoningRepositoryProvider);
  final result = await repository.isBasemapDownloaded(localityId);
  return result.fold((failure) => false, (isDownloaded) => isDownloaded);
});

final basemapProvider = FutureProvider.family<Basemap?, String>((
  ref,
  localityId,
) async {
  final repository = ref.watch(zoningRepositoryProvider);
  final result = await repository.loadBasemap(localityId);
  return result.fold((failure) => null, (basemap) => basemap);
});

// Location Providers
final locationPermissionProvider = FutureProvider<bool>((ref) async {
  final repository = ref.watch(zoningRepositoryProvider);
  final result = await repository.checkLocationPermissions();
  return result.fold((failure) => false, (hasPermission) => hasPermission);
});

final currentLocationProvider =
    FutureProvider.family<UserLocation?, List<LatLng>?>((
      ref,
      projectBoundary,
    ) async {
      final repository = ref.watch(zoningRepositoryProvider);
      final result = await repository.getCurrentLocation(
        projectBoundary: projectBoundary,
      );
      return result.fold((failure) => null, (location) => location);
    });

final locationStreamProvider =
    StreamProvider.family<UserLocation, List<LatLng>?>((ref, projectBoundary) {
      final repository = ref.watch(zoningRepositoryProvider);
      return repository.getLocationStream(projectBoundary: projectBoundary);
    });

// Feature Providers
final zoningFeaturesProvider =
    FutureProvider.family<List<ZoningFeature>, String>((ref, projectId) async {
      final repository = ref.watch(zoningRepositoryProvider);
      final result = await repository.getFeatures(projectId);
      return result.fold(
        (failure) => <ZoningFeature>[],
        (features) => features,
      );
    });

final unsyncedFeaturesProvider =
    FutureProvider.family<List<ZoningFeature>, String>((ref, projectId) async {
      final repository = ref.watch(zoningRepositoryProvider);
      final result = await repository.getUnsyncedFeatures(projectId);
      return result.fold(
        (failure) => <ZoningFeature>[],
        (features) => features,
      );
    });

// State Notifiers
class ZoningStateNotifier extends StateNotifier<ZoningState> {
  final ZoningRepository _repository;

  ZoningStateNotifier(this._repository) : super(const ZoningInitial());

  Future<void> downloadBasemap({
    required String localityId,
    String? accessToken,
  }) async {
    state = const ZoningDownloadingBasemap();

    final result = await _repository.downloadBasemap(
      localityId: localityId,
      accessToken: accessToken,
      onProgress: (progress) {
        state = ZoningDownloadingBasemap(progress: progress);
      },
    );

    result.fold(
      (failure) => state = ZoningError(failure.message),
      (success) =>
          state =
              success
                  ? const ZoningBasemapReady()
                  : const ZoningError('Failed to download basemap'),
    );
  }

  Future<void> createFeature(ZoningFeature feature) async {
    state = const ZoningSavingFeature();

    final result = await _repository.createFeature(feature);

    result.fold(
      (failure) => state = ZoningError(failure.message),
      (savedFeature) => state = ZoningFeatureSaved(savedFeature),
    );
  }

  Future<void> updateFeature(ZoningFeature feature) async {
    state = const ZoningSavingFeature();

    final result = await _repository.updateFeature(feature);

    result.fold(
      (failure) => state = ZoningError(failure.message),
      (updatedFeature) => state = ZoningFeatureSaved(updatedFeature),
    );
  }

  Future<void> deleteFeature(String featureId) async {
    state = const ZoningDeletingFeature();

    final result = await _repository.deleteFeature(featureId);

    result.fold(
      (failure) => state = ZoningError(failure.message),
      (success) =>
          state =
              success
                  ? const ZoningFeatureDeleted()
                  : const ZoningError('Failed to delete feature'),
    );
  }

  Future<void> exportFeatures(String projectId, String filePath) async {
    state = const ZoningExporting();

    final result = await _repository.exportFeatures(projectId, filePath);

    result.fold(
      (failure) => state = ZoningError(failure.message),
      (success) =>
          state =
              success
                  ? const ZoningExported('')
                  : const ZoningError('Export failed'),
    );
  }

  // TODO: Bado Sync functionality,  I will implement later

  void resetState() {
    state = const ZoningInitial();
  }
}

final zoningStateProvider =
    StateNotifierProvider<ZoningStateNotifier, ZoningState>((ref) {
      final repository = ref.watch(zoningRepositoryProvider);
      return ZoningStateNotifier(repository);
    });

// Zoning State
abstract class ZoningState {
  const ZoningState();
}

class ZoningInitial extends ZoningState {
  const ZoningInitial();
}

class ZoningDownloadingBasemap extends ZoningState {
  final double? progress;
  const ZoningDownloadingBasemap({this.progress});
}

class ZoningBasemapReady extends ZoningState {
  const ZoningBasemapReady();
}

class ZoningSavingFeature extends ZoningState {
  const ZoningSavingFeature();
}

class ZoningFeatureSaved extends ZoningState {
  final ZoningFeature feature;
  const ZoningFeatureSaved(this.feature);
}

class ZoningDeletingFeature extends ZoningState {
  const ZoningDeletingFeature();
}

class ZoningFeatureDeleted extends ZoningState {
  const ZoningFeatureDeleted();
}

class ZoningExporting extends ZoningState {
  const ZoningExporting();
}

class ZoningExported extends ZoningState {
  final String filePath;
  const ZoningExported(this.filePath);
}

class ZoningSyncing extends ZoningState {
  const ZoningSyncing();
}

class ZoningSynced extends ZoningState {
  const ZoningSynced();
}

class ZoningError extends ZoningState {
  final String message;
  const ZoningError(this.message);
}
