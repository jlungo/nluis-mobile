import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../core/error/failures.dart';
import '../../../../spatial/domain/entities/basemap.dart';
import '../../../../spatial/domain/entities/user_location.dart';
import '../entities/zoning_feature.dart';

abstract class ZoningRepository {
  // Basemap operations
  Future<Either<Failure, bool>> isBasemapDownloaded(String localityId);
  Future<Either<Failure, Basemap>> loadBasemap(String localityId);
  Future<Either<Failure, bool>> downloadBasemap({
    required String localityId,
    String? accessToken,
    Function(double)? onProgress,
  });
  Future<Either<Failure, bool>> deleteBasemap(String localityId);

  // Location operations
  Future<Either<Failure, bool>> checkLocationPermissions();
  Future<Either<Failure, UserLocation>> getCurrentLocation({
    List<LatLng>? projectBoundary,
  });
  Stream<UserLocation> getLocationStream({List<LatLng>? projectBoundary});

  // Feature operations
  Future<Either<Failure, List<ZoningFeature>>> getFeatures(String projectId);
  Future<Either<Failure, ZoningFeature>> createFeature(ZoningFeature feature);
  Future<Either<Failure, ZoningFeature>> updateFeature(ZoningFeature feature);
  Future<Either<Failure, bool>> deleteFeature(String featureId);
  
  // Export operations
  Future<Either<Failure, bool>> exportFeatures(String projectId, String filePath);
  Future<Either<Failure, List<ZoningFeature>>> getUnsyncedFeatures(String projectId);
  
  // Locality-based operations for ZoningManagerPage
  Future<Either<Failure, List<ZoningFeature>>> getAllFeatures();
  Future<Either<Failure, List<ZoningFeature>>> getFeaturesByStatus({
    bool? isDraft,
    bool? uploaded,
  });
  Future<Either<Failure, Map<String, List<ZoningFeature>>>> getFeaturesByLocality();
  
  // Note: Upload operations are now handled by UploadQueueService with ZoningApiService
}
