import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../../core/error/failures.dart';
import '../../../../../data/local/database.dart';
import '../../../../spatial/domain/entities/basemap.dart';
import '../../../../spatial/domain/entities/user_location.dart';
import '../../domain/entities/zoning_feature.dart' as domain;
import '../../domain/repositories/zoning_repository.dart';
import '../../../../spatial/data/services/basemap_service.dart';
import '../../../../spatial/data/services/location_service.dart';

class ZoningRepositoryImpl implements ZoningRepository {
  final BasemapService _storageService;
  final LocationService _locationService;
  final AppDatabase _database;

  ZoningRepositoryImpl({
    required BasemapService storageService,
    required LocationService locationService,
    required AppDatabase database,
  })  : _storageService = storageService,
        _locationService = locationService,
        _database = database;

  // Basemap operations
  @override
  Future<Either<Failure, bool>> isBasemapDownloaded(String localityId) async {
    try {
      final basemap = await _storageService.loadBasemap(localityId);
      return Right(basemap != null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Basemap>> loadBasemap(String localityId) async {
    try {
      final basemap = await _storageService.loadBasemap(localityId);
      if (basemap == null) {
        return Left(CacheFailure('Basemap not found for locality $localityId'));
      }
      return Right(basemap);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> downloadBasemap({
    required String localityId,
    String? accessToken,
    Function(double)? onProgress,
  }) async {
    try {
      final success = await _storageService.downloadBasemap(
        localityId: localityId,
        accessToken: accessToken,
        onProgress: onProgress,
      );
      return Right(success);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteBasemap(String localityId) async {
    try {
      final success = await _storageService.deleteBasemap(localityId);
      return Right(success);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  // Location operations
  @override
  Future<Either<Failure, bool>> checkLocationPermissions() async {
    try {
      final hasPermission = await _locationService.checkPermissions();
      return Right(hasPermission);
    } catch (e) {
      return Left(DeviceFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserLocation>> getCurrentLocation({
    List<LatLng>? projectBoundary,
  }) async {
    try {
      final location = await _locationService.getCurrentLocation(
        projectBoundary: projectBoundary,
      );
      if (location == null) {
        return Left(DeviceFailure('Unable to get current location'));
      }
      return Right(location);
    } catch (e) {
      return Left(DeviceFailure(e.toString()));
    }
  }

  @override
  Stream<UserLocation> getLocationStream({List<LatLng>? projectBoundary}) {
    _locationService.startLocationTracking(projectBoundary: projectBoundary);
    return _locationService.locationStream;
  }

  // Feature operations
  @override
  Future<Either<Failure, List<domain.ZoningFeature>>> getFeatures(String projectId) async {
    try {
      final features = await (_database.select(_database.zoningFeatures)
            ..where((tbl) => tbl.projectId.equals(projectId)))
          .get();

      final zoningFeatures = features.map(_mapToZoningFeature).toList();
      return Right(zoningFeatures);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, domain.ZoningFeature>> createFeature(domain.ZoningFeature feature) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final companion = ZoningFeaturesCompanion.insert(
        clientUuid: feature.clientUuid,
        serverId: drift.Value(feature.serverId),
        projectId: feature.projectId,
        localityId: int.parse(feature.localityId),
        landUseId: drift.Value(feature.landUseId),
        geomType: feature.featureType.name,
        srid: drift.Value(feature.srid),
        coordsJson: jsonEncode(feature.coordinates
            .map((coord) => [coord.longitude, coord.latitude])
            .toList()),
        areaSqm: drift.Value(feature.area),
        lengthM: drift.Value(feature.length),
        buffer: drift.Value(feature.buffer),
        propertiesJson: drift.Value(jsonEncode({
          'zoningType': feature.zoningType.name,
          'plotId': feature.plotId,
          'plotName': feature.plotName,
          'notes': feature.notes,
        })),
        isDraft: drift.Value(feature.isDraft),
        isProposed: drift.Value(feature.isProposed),
        status: drift.Value(feature.status),
        source: drift.Value(feature.source),
        version: drift.Value(feature.version),
        uploaded: drift.Value(feature.uploaded),
        uploadedAt: drift.Value(feature.uploadedAt?.millisecondsSinceEpoch),
        createdAt: now,
        updatedAt: now,
        metadataJson: drift.Value(feature.metadata != null ? jsonEncode(feature.metadata) : null),
        dirty: drift.Value(feature.needsSync),
      );

      await _database.into(_database.zoningFeatures).insert(companion);
      return Right(feature);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, domain.ZoningFeature>> updateFeature(domain.ZoningFeature feature) async {
    try {
      final companion = ZoningFeaturesCompanion(
        clientUuid: drift.Value(feature.clientUuid),
        serverId: drift.Value(feature.serverId),
        projectId: drift.Value(feature.projectId),
        localityId: drift.Value(int.parse(feature.localityId)),
        landUseId: drift.Value(feature.landUseId),
        geomType: drift.Value(feature.featureType.name),
        srid: drift.Value(feature.srid),
        coordsJson: drift.Value(jsonEncode(feature.coordinates
            .map((coord) => [coord.longitude, coord.latitude])
            .toList())),
        areaSqm: drift.Value(feature.area),
        lengthM: drift.Value(feature.length),
        buffer: drift.Value(feature.buffer),
        propertiesJson: drift.Value(jsonEncode({
          'zoningType': feature.zoningType.name,
          'plotId': feature.plotId,
          'plotName': feature.plotName,
          'notes': feature.notes,
        })),
        isDraft: drift.Value(feature.isDraft),
        isProposed: drift.Value(feature.isProposed),
        status: drift.Value(feature.status),
        source: drift.Value(feature.source),
        version: drift.Value(feature.version),
        uploaded: drift.Value(feature.uploaded),
        uploadedAt: drift.Value(feature.uploadedAt?.millisecondsSinceEpoch),
        updatedAt: drift.Value(DateTime.now().millisecondsSinceEpoch),
        metadataJson: drift.Value(feature.metadata != null ? jsonEncode(feature.metadata) : null),
        dirty: drift.Value(feature.needsSync),
      );

      await (_database.update(_database.zoningFeatures)
            ..where((tbl) => tbl.clientUuid.equals(feature.clientUuid)))
          .write(companion);
      return Right(feature);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteFeature(String featureId) async {
    try {
      final deletedRows = await (_database.delete(_database.zoningFeatures)
            ..where((tbl) => tbl.clientUuid.equals(featureId)))
          .go();
      return Right(deletedRows > 0);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<domain.ZoningFeature>>> getUnsyncedFeatures(String projectId) async {
    try {
      final features = await (_database.select(_database.zoningFeatures)
            ..where((tbl) => tbl.projectId.equals(projectId) & tbl.dirty.equals(true)))
          .get();

      final zoningFeatures = features.map(_mapToZoningFeature).toList();
      return Right(zoningFeatures);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> exportFeatures(String projectId, String filePath) async {
    try {
      final featuresResult = await getFeatures(projectId);
      return featuresResult.fold(
        (failure) => Left(failure),
        (features) async {
          try {
            final geoJson = _convertToGeoJson(features);
            final file = File(filePath);
            await file.writeAsString(jsonEncode(geoJson));
            return const Right(true);
          } catch (e) {
            return Left(CacheFailure(e.toString()));
          }
        },
      );
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  // Locality-based operations for ZoningManagerPage
  @override
  Future<Either<Failure, List<domain.ZoningFeature>>> getAllFeatures() async {
    try {
      final features = await _database.select(_database.zoningFeatures).get();
      final zoningFeatures = features.map(_mapToZoningFeature).toList();
      return Right(zoningFeatures);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<domain.ZoningFeature>>> getFeaturesByStatus({
    bool? isDraft,
    bool? uploaded,
  }) async {
    try {
      var query = _database.select(_database.zoningFeatures);
      
      if (isDraft != null) {
        query = query..where((tbl) => tbl.isDraft.equals(isDraft));
      }
      
      if (uploaded != null) {
        query = query..where((tbl) => tbl.uploaded.equals(uploaded));
      }
      
      final features = await query.get();
      final zoningFeatures = features.map(_mapToZoningFeature).toList();
      return Right(zoningFeatures);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, List<domain.ZoningFeature>>>> getFeaturesByLocality() async {
    try {
      final features = await _database.select(_database.zoningFeatures).get();
      final zoningFeatures = features.map(_mapToZoningFeature).toList();
      
      // Group features by localityId
      final Map<String, List<domain.ZoningFeature>> groupedFeatures = {};
      for (final feature in zoningFeatures) {
        if (!groupedFeatures.containsKey(feature.localityId)) {
          groupedFeatures[feature.localityId] = [];
        }
        groupedFeatures[feature.localityId]!.add(feature);
      }
      
      return Right(groupedFeatures);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  // Helper methods
  domain.ZoningFeature _mapToZoningFeature(ZoningFeature dbFeature) {
    final coordinates = (jsonDecode(dbFeature.coordsJson) as List)
        .map((coord) => LatLng(coord[1], coord[0]))
        .toList();

    final properties = jsonDecode(dbFeature.propertiesJson ?? '{}') as Map<String, dynamic>;
    final metadata = dbFeature.metadataJson != null 
        ? jsonDecode(dbFeature.metadataJson!) as Map<String, dynamic>
        : null;

    return domain.ZoningFeature(
      clientUuid: dbFeature.clientUuid,
      serverId: dbFeature.serverId,
      projectId: dbFeature.projectId,
      localityId: dbFeature.localityId.toString(),
      landUseId: dbFeature.landUseId,
      featureType: domain.ZoningFeatureType.values.firstWhere(
        (type) => type.name == dbFeature.geomType,
        orElse: () => domain.ZoningFeatureType.point,
      ),
      srid: dbFeature.srid,
      coordinates: coordinates,
      zoningType: domain.ZoningType.values.firstWhere(
        (type) => type.name == properties['zoningType'],
        orElse: () => domain.ZoningType.other,
      ),
      plotId: properties['plotId'],
      plotName: properties['plotName'],
      notes: properties['notes'],
      area: dbFeature.areaSqm,
      length: dbFeature.lengthM,
      buffer: dbFeature.buffer,
      isProposed: dbFeature.isProposed,
      status: dbFeature.status,
      source: dbFeature.source,
      version: dbFeature.version,
      uploaded: dbFeature.uploaded,
      uploadedAt: dbFeature.uploadedAt != null 
          ? DateTime.fromMillisecondsSinceEpoch(dbFeature.uploadedAt!)
          : null,
      metadata: metadata,
      isDraft: dbFeature.isDraft,
      needsSync: dbFeature.dirty,
      createdAt: DateTime.fromMillisecondsSinceEpoch(dbFeature.createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(dbFeature.updatedAt),
    );
  }

  Map<String, dynamic> _convertToGeoJson(List<domain.ZoningFeature> features) {
    return {
      'type': 'FeatureCollection',
      'features': features.map((feature) {
        return {
          'type': 'Feature',
          'geometry': {
            'type': _getGeoJsonType(feature.featureType),
            'coordinates': _getGeoJsonCoordinates(feature),
          },
          'properties': {
            'clientUuid': feature.clientUuid,
            'serverId': feature.serverId,
            'localityId': feature.localityId,
            'landUseId': feature.landUseId,
            'zoningType': feature.zoningType.name,
            'plotId': feature.plotId,
            'plotName': feature.plotName,
            'notes': feature.notes,
            'area': feature.area,
            'length': feature.length,
            'isProposed': feature.isProposed,
            'status': feature.status,
            'source': feature.source,
            'version': feature.version,
            'isDraft': feature.isDraft,
            'createdAt': feature.createdAt.toIso8601String(),
            'updatedAt': feature.updatedAt.toIso8601String(),
          },
        };
      }).toList(),
    };
  }

  String _getGeoJsonType(domain.ZoningFeatureType type) {
    switch (type) {
      case domain.ZoningFeatureType.point:
        return 'Point';
      case domain.ZoningFeatureType.lineString:
        return 'LineString';
      case domain.ZoningFeatureType.polygon:
        return 'Polygon';
    }
  }

  dynamic _getGeoJsonCoordinates(domain.ZoningFeature feature) {
    final coords = feature.coordinates
        .map((coord) => [coord.longitude, coord.latitude])
        .toList();

    switch (feature.featureType) {
      case domain.ZoningFeatureType.point:
        return coords.first;
      case domain.ZoningFeatureType.lineString:
        return coords;
      case domain.ZoningFeatureType.polygon:
        return [coords];
    }
  }
}
