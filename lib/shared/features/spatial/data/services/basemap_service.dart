import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../../../data/local/database.dart';
import '../../domain/entities/basemap.dart';

class BasemapService {
  final DioClient _dioClient;
  final AppDatabase _database;

  BasemapService({
    required DioClient dioClient,
    required AppDatabase database,
  })  : _dioClient = dioClient,
        _database = database;

  Future<bool> isBasemapDownloaded(String localityId) async {
    try {
      final localityIdInt = int.tryParse(localityId);
      if (localityIdInt == null) return false;

      final basemap = await (_database.select(_database.baseMaps)
            ..where((tbl) => tbl.localityId.equals(localityIdInt)))
          .getSingleOrNull();

      return basemap != null;
    } catch (e) {
      return false;
    }
  }

  Future<Basemap?> loadBasemap(String localityId) async {
    try {
      debugPrint('BasemapService: Loading basemap for locality $localityId');

      final localityIdInt = int.tryParse(localityId);
      if (localityIdInt == null) {
        debugPrint('BasemapService: Invalid locality ID format: $localityId');
        return null;
      }

      final basemapRecord = await (_database.select(_database.baseMaps)
            ..where((tbl) => tbl.localityId.equals(localityIdInt)))
          .getSingleOrNull();

      if (basemapRecord == null) {
        debugPrint(
          'BasemapService: No basemap found in database for locality $localityId',
        );
        return null;
      }

      debugPrint('BasemapService: Found basemap record, parsing GeoJSON...');

      final geoJsonData =
          jsonDecode(basemapRecord.geoJson) as Map<String, dynamic>;
      final boundary = _extractBoundary(geoJsonData);

      if (boundary.isEmpty) {
        debugPrint('BasemapService: WARNING - Empty boundary extracted');
      }

      final center = basemapRecord.centerLat != null &&
              basemapRecord.centerLng != null
          ? LatLng(basemapRecord.centerLat!, basemapRecord.centerLng!)
          : _calculateCenter(boundary);

      debugPrint(
        'BasemapService: Basemap loaded successfully - ${boundary.length} boundary points, center: ${center.latitude}, ${center.longitude}',
      );

      final basemap = Basemap(
        localityId: localityId,
        geoJson: geoJsonData,
        boundary: boundary,
        center: center,
        zoom: basemapRecord.zoom ?? 16.0,
        downloadedAt: DateTime.fromMillisecondsSinceEpoch(
          basemapRecord.downloadedAt * 1000,
        ),
        localPath: '', // Not used in database storage
        isValid: true,
      );

      return basemap;
    } catch (e, stackTrace) {
      debugPrint('BasemapService: Failed to load basemap - $e');
      debugPrint('BasemapService: Stack trace - $stackTrace');
      return null;
    }
  }

  Future<bool> downloadBasemap({
    required String localityId,
    String? accessToken,
    Function(double)? onProgress,
  }) async {
    try {
      debugPrint('BasemapService: Starting download for locality $localityId');

      final localityIdInt = int.tryParse(localityId);
      if (localityIdInt == null) {
        debugPrint('BasemapService: Invalid locality ID format: $localityId');
        return false;
      }

      final apiPath = '/localities/localities/$localityId/boundary/';
      debugPrint('BasemapService: Requesting $apiPath');

      final response = await _dioClient.get(
        apiPath,
        onReceiveProgress: (received, total) {
          if (total != -1 && onProgress != null) {
            final progress = received / total;
            debugPrint(
              'BasemapService: Download progress: ${(progress * 100).toStringAsFixed(1)}%',
            );
            onProgress(progress);
          }
        },
      );

      debugPrint('BasemapService: Response status: ${response.statusCode}');

      if (response.statusCode != 200 || response.data == null) {
        debugPrint(
          'BasemapService: Download failed - Status: ${response.statusCode}, Has data: ${response.data != null}',
        );
        return false;
      }

      final geoJsonData = response.data as Map<String, dynamic>;
      debugPrint('BasemapService: GeoJSON type: ${geoJsonData['type']}');

      // Validate FeatureCollection structure
      if (geoJsonData['type'] != 'FeatureCollection') {
        debugPrint('BasemapService: Invalid GeoJSON - not a FeatureCollection');
        return false;
      }

      final features = geoJsonData['features'] as List?;
      if (features == null || features.isEmpty) {
        debugPrint('BasemapService: No features in GeoJSON');
        return false;
      }

      debugPrint('BasemapService: Found ${features.length} feature(s)');

      final boundary = _extractBoundary(geoJsonData);

      if (boundary.isEmpty) {
        debugPrint('BasemapService: Failed to extract boundary coordinates');
        return false;
      }

      debugPrint('BasemapService: Extracted ${boundary.length} boundary points');

      final center = _calculateCenter(boundary);
      debugPrint(
        'BasemapService: Center calculated: ${center.latitude}, ${center.longitude}',
      );

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      debugPrint('BasemapService: Saving to database...');
      await _database.into(_database.baseMaps).insertOnConflictUpdate(
            BaseMapsCompanion(
              localityId: Value(localityIdInt),
              geoJson: Value(jsonEncode(geoJsonData)),
              centerLat: Value(center.latitude),
              centerLng: Value(center.longitude),
              zoom: const Value(16.0),
              downloadedAt: Value(now),
              updatedAt: Value(now),
            ),
          );

      debugPrint(
        'BasemapService: Successfully saved basemap for locality $localityId',
      );
      return true;
    } catch (e, stackTrace) {
      debugPrint('BasemapService: Download failed with exception - $e');
      debugPrint('BasemapService: Stack trace - $stackTrace');
      return false;
    }
  }

  Future<bool> deleteBasemap(String localityId) async {
    try {
      final localityIdInt = int.tryParse(localityId);
      if (localityIdInt == null) return false;

      await (_database.delete(_database.baseMaps)
            ..where((tbl) => tbl.localityId.equals(localityIdInt)))
          .go();

      return true;
    } catch (e) {
      return false;
    }
  }

  List<LatLng> _extractBoundary(Map<String, dynamic> geoJson) {
    try {
      final features = geoJson['features'] as List?;
      if (features == null || features.isEmpty) return [];

      final firstFeature = features[0] as Map<String, dynamic>;
      final geometry = firstFeature['geometry'] as Map<String, dynamic>?;
      if (geometry == null) return [];

      final coordinates = geometry['coordinates'];
      if (coordinates == null) return [];

      // Handle different geometry types
      final type = geometry['type'] as String?;
      if (type == 'Polygon') {
        final rings = coordinates as List;
        if (rings.isEmpty) return [];
        final outerRing = rings[0] as List;
        return outerRing
            .map((coord) => LatLng(
                  (coord[1] as num).toDouble(),
                  (coord[0] as num).toDouble(),
                ))
            .toList();
      } else if (type == 'MultiPolygon') {
        final polygons = coordinates as List;
        if (polygons.isEmpty) return [];
        final firstPolygon = polygons[0] as List;
        if (firstPolygon.isEmpty) return [];
        final outerRing = firstPolygon[0] as List;
        return outerRing
            .map((coord) => LatLng(
                  (coord[1] as num).toDouble(),
                  (coord[0] as num).toDouble(),
                ))
            .toList();
      }

      return [];
    } catch (e) {
      debugPrint('BasemapService: Error extracting boundary - $e');
      return [];
    }
  }

  LatLng _calculateCenter(List<LatLng> boundary) {
    if (boundary.isEmpty) return const LatLng(-6.8, 39.28); // Default Tanzania

    double totalLat = 0;
    double totalLng = 0;

    for (final point in boundary) {
      totalLat += point.latitude;
      totalLng += point.longitude;
    }

    return LatLng(
      totalLat / boundary.length,
      totalLng / boundary.length,
    );
  }
}
