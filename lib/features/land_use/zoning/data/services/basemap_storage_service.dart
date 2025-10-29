import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../../../data/local/database.dart';
import '../../domain/entities/basemap.dart';

class BasemapStorageService {
  final DioClient _dioClient;
  final AppDatabase _database;

  BasemapStorageService({
    required DioClient dioClient,
    required AppDatabase database,
  }) : _dioClient = dioClient, _database = database;

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
      debugPrint('BasemapStorage: Loading basemap for locality $localityId');
      
      final localityIdInt = int.tryParse(localityId);
      if (localityIdInt == null) {
        debugPrint('BasemapStorage: Invalid locality ID format: $localityId');
        return null;
      }
      
      final basemapRecord = await (_database.select(_database.baseMaps)
            ..where((tbl) => tbl.localityId.equals(localityIdInt)))
          .getSingleOrNull();
      
      if (basemapRecord == null) {
        debugPrint('BasemapStorage: No basemap found in database for locality $localityId');
        return null;
      }
      
      debugPrint('BasemapStorage: Found basemap record, parsing GeoJSON...');
      
      final geoJsonData = jsonDecode(basemapRecord.geoJson) as Map<String, dynamic>;
      final boundary = _extractBoundary(geoJsonData);
      
      if (boundary.isEmpty) {
        debugPrint('BasemapStorage: WARNING - Empty boundary extracted');
      }
      
      final center = basemapRecord.centerLat != null && basemapRecord.centerLng != null
          ? LatLng(basemapRecord.centerLat!, basemapRecord.centerLng!)
          : _calculateCenter(boundary);
      
      debugPrint('BasemapStorage: Basemap loaded successfully - ${boundary.length} boundary points, center: ${center.latitude}, ${center.longitude}');
      
      final basemap = Basemap(
        localityId: localityId,
        geoJson: geoJsonData,
        boundary: boundary,
        center: center,
        zoom: basemapRecord.zoom ?? 16.0,
        downloadedAt: DateTime.fromMillisecondsSinceEpoch(basemapRecord.downloadedAt * 1000),
        localPath: '', // Not used in database storage
        isValid: true,
      );
      
      return basemap;
    } catch (e, stackTrace) {
      debugPrint('BasemapStorage: Failed to load basemap - $e');
      debugPrint('BasemapStorage: Stack trace - $stackTrace');
      return null;
    }
  }

  Future<bool> downloadBasemap({
    required String localityId,
    String? accessToken,
    Function(double)? onProgress,
  }) async {
    try {
      debugPrint('BasemapStorage: Starting download for locality $localityId');
      
      final localityIdInt = int.tryParse(localityId);
      if (localityIdInt == null) {
        debugPrint('BasemapStorage: Invalid locality ID format: $localityId');
        return false;
      }

      final apiPath = '/localities/localities/$localityId/boundary/';
      debugPrint('BasemapStorage: Requesting $apiPath');
      
      final response = await _dioClient.get(
        apiPath,
        onReceiveProgress: (received, total) {
          if (total != -1 && onProgress != null) {
            final progress = received / total;
            debugPrint('BasemapStorage: Download progress: ${(progress * 100).toStringAsFixed(1)}%');
            onProgress(progress);
          }
        },
      );

      debugPrint('BasemapStorage: Response status: ${response.statusCode}');
      
      if (response.statusCode != 200 || response.data == null) {
        debugPrint('BasemapStorage: Download failed - Status: ${response.statusCode}, Has data: ${response.data != null}');
        return false;
      }

      final geoJsonData = response.data as Map<String, dynamic>;
      debugPrint('BasemapStorage: GeoJSON type: ${geoJsonData['type']}');
      
      // Validate FeatureCollection structure
      if (geoJsonData['type'] != 'FeatureCollection') {
        debugPrint('BasemapStorage: Invalid GeoJSON - not a FeatureCollection');
        return false;
      }
      
      final features = geoJsonData['features'] as List?;
      if (features == null || features.isEmpty) {
        debugPrint('BasemapStorage: No features in GeoJSON');
        return false;
      }
      
      debugPrint('BasemapStorage: Found ${features.length} feature(s)');
      
      final boundary = _extractBoundary(geoJsonData);
      
      if (boundary.isEmpty) {
        debugPrint('BasemapStorage: Failed to extract boundary coordinates');
        return false;
      }
      
      debugPrint('BasemapStorage: Extracted ${boundary.length} boundary points');
      
      final center = _calculateCenter(boundary);
      debugPrint('BasemapStorage: Center calculated: ${center.latitude}, ${center.longitude}');
      
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      debugPrint('BasemapStorage: Saving to database...');
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

      debugPrint('BasemapStorage: Successfully saved basemap for locality $localityId');
      return true;
    } catch (e, stackTrace) {
      debugPrint('BasemapStorage: Download failed with exception - $e');
      debugPrint('BasemapStorage: Stack trace - $stackTrace');
      return false;
    }
  }

  Future<bool> saveBasemap({
    required String localityId,
    required Map<String, dynamic> geoJson,
  }) async {
    try {
      final localityIdInt = int.tryParse(localityId);
      if (localityIdInt == null) {
        debugPrint('BasemapStorage: Invalid localityId');
        return false;
      }

      final boundary = _extractBoundary(geoJson);
      final center = _calculateCenter(boundary);
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      await _database.into(_database.baseMaps).insertOnConflictUpdate(
        BaseMapsCompanion(
          localityId: Value(localityIdInt),
          geoJson: Value(jsonEncode(geoJson)),
          centerLat: Value(center.latitude),
          centerLng: Value(center.longitude),
          zoom: const Value(16.0),
          downloadedAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      return true;
    } catch (e, stackTrace) {
      debugPrint('BasemapStorage: Failed to save basemap - $e');
      debugPrint('BasemapStorage: Stack trace - $stackTrace');
      return false;
    }
  }

  Future<bool> deleteBasemap(String localityId) async {
    try {
      final localityIdInt = int.tryParse(localityId);
      if (localityIdInt == null) {
        debugPrint('BasemapStorage: Invalid localityId');
        return false;
      }

      final deletedRows = await (_database.delete(_database.baseMaps)
            ..where((tbl) => tbl.localityId.equals(localityIdInt)))
          .go();

      if (deletedRows == 0) {
        debugPrint('BasemapStorage: Basemap not found for deletion');
      }

      return deletedRows > 0;
    } catch (e) {
      return false;
    }
  }

  List<LatLng> _extractBoundary(Map<String, dynamic> geoJson) {
    try {
      final features = geoJson['features'] as List<dynamic>?;
      if (features == null || features.isEmpty) {
        debugPrint('BasemapStorage: No features found in GeoJSON');
        return [];
      }

      final coordinates = <LatLng>[];
      
      for (var i = 0; i < features.length; i++) {
        final feature = features[i];
        final geometry = feature['geometry'] as Map<String, dynamic>?;
        if (geometry == null) {
          debugPrint('BasemapStorage: Feature $i has no geometry');
          continue;
        }

        final coords = geometry['coordinates'] as List<dynamic>?;
        if (coords == null || coords.isEmpty) {
          debugPrint('BasemapStorage: Feature $i has no coordinates');
          continue;
        }

        final type = geometry['type'] as String?;
        debugPrint('BasemapStorage: Feature $i geometry type: $type');
        
        if (type == 'Polygon' && coords.isNotEmpty) {
          final ring = coords[0] as List<dynamic>;
          debugPrint('BasemapStorage: Polygon has ${ring.length} points');
          for (final coord in ring) {
            if (coord is List && coord.length >= 2) {
              final lng = coord[0] is num ? (coord[0] as num).toDouble() : double.parse(coord[0].toString());
              final lat = coord[1] is num ? (coord[1] as num).toDouble() : double.parse(coord[1].toString());
              coordinates.add(LatLng(lat, lng));
            }
          }
          break; // Use first polygon
        } else if (type == 'MultiPolygon' && coords.isNotEmpty) {
          debugPrint('BasemapStorage: MultiPolygon with ${coords.length} polygon(s)');
          // Handle MultiPolygon - use the first polygon from the first multi-polygon
          final firstMultiPolygon = coords[0] as List<dynamic>;
          if (firstMultiPolygon.isNotEmpty) {
            final ring = firstMultiPolygon[0] as List<dynamic>;
            debugPrint('BasemapStorage: First MultiPolygon ring has ${ring.length} points');
            for (final coord in ring) {
              if (coord is List && coord.length >= 2) {
                final lng = coord[0] is num ? (coord[0] as num).toDouble() : double.parse(coord[0].toString());
                final lat = coord[1] is num ? (coord[1] as num).toDouble() : double.parse(coord[1].toString());
                coordinates.add(LatLng(lat, lng));
              }
            }
            break; // Use first polygon from first multi-polygon
          }
        }
      }
      
      debugPrint('BasemapStorage: Successfully extracted ${coordinates.length} coordinates');
      return coordinates;
    } catch (e, stackTrace) {
      debugPrint('BasemapStorage: Failed to extract boundary - $e');
      debugPrint('BasemapStorage: Stack trace - $stackTrace');
      return [];
    }
  }

  LatLng _calculateCenter(List<LatLng> boundary) {
    if (boundary.isEmpty) return const LatLng(0, 0);

    double totalLat = 0;
    double totalLng = 0;
    for (final point in boundary) {
      totalLat += point.latitude;
      totalLng += point.longitude;
    }
    return LatLng(totalLat / boundary.length, totalLng / boundary.length);
  }
}
