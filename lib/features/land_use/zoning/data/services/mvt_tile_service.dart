import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../../../data/local/database.dart';
import '../../domain/repositories/zoning_repository.dart';
import 'mvt_parser_service.dart';

class MvtTileService {
  final DioClient _dioClient;
  final AppDatabase _database;
  final MvtParserService _parser;
  final ZoningRepository _repository;
  
  static const String _tilesEndpoint = '/zoning/zones/tiles';
  
  MvtTileService({
    required DioClient dioClient,
    required AppDatabase database,
    required MvtParserService parser,
    required ZoningRepository repository,
  })  : _dioClient = dioClient,
        _database = database,
        _parser = parser,
        _repository = repository;

  Future<bool> isTilesetDownloaded(String localityId) async {
    try {
      final localityIdInt = int.tryParse(localityId);
      if (localityIdInt == null) return false;

      final tileset = await (_database.select(_database.mvtTilesets)
            ..where((tbl) => tbl.localityId.equals(localityIdInt)))
          .getSingleOrNull();

      return tileset != null;
    } catch (e) {
      debugPrint('MVT Service: Error checking tileset - $e');
      return false;
    }
  }


  String getTileUrlTemplate({
    required String localityId,
    bool isProposed = false,
  }) {
    return '$_tilesEndpoint/{z}/{x}/{y}.mvt?locality=$localityId&is_proposed=${isProposed ? 1 : 0}';
  }

  /// Download and store MVT tileset for a locality
  Future<bool> downloadTileset({
    required String projectId,
    required String localityId,
    required LatLngBounds bounds,
    required int minZoom,
    required int maxZoom,
    bool isProposed = false,
    Function(double)? onProgress,
  }) async {
    try {
      debugPrint('MVT Service: Starting tileset download for locality $localityId, project $projectId');
      debugPrint('MVT Service: Bounds: $bounds, Zoom: $minZoom-$maxZoom');

      final localityIdInt = int.tryParse(localityId);
      if (localityIdInt == null) {
        debugPrint('MVT Service: Invalid locality ID format');
        return false;
      }

      int totalTiles = 0;
      for (int z = minZoom; z <= maxZoom; z++) {
        final tileRange = _calculateTileRange(bounds, z);
        totalTiles += tileRange.tileCount;
      }

      debugPrint('MVT Service: Total tiles to download: $totalTiles');

      int processedTiles = 0;
      int totalFeatures = 0;
      
      for (int z = minZoom; z <= maxZoom; z++) {
        final tileRange = _calculateTileRange(bounds, z);
        debugPrint('MVT Service: Downloading zoom $z - ${tileRange.tileCount} tiles');

        for (int x = tileRange.minX; x <= tileRange.maxX; x++) {
          for (int y = tileRange.minY; y <= tileRange.maxY; y++) {
            try {
              // Download tile
              final tileData = await _downloadTile(
                z, x, y,
                localityId: localityId,
                isProposed: isProposed,
              );

              if (tileData != null && tileData.isNotEmpty) {
                // Parse MVT to features
                final features = await _parser.parseMvtTile(
                  tileData,
                  projectId: projectId,
                  localityId: localityId,
                );

                // Store features in database
                for (final feature in features) {
                  await _repository.createFeature(feature);
                  totalFeatures++;
                }

                processedTiles++;
                
                // Report progress
                if (onProgress != null) {
                  final progress = processedTiles / totalTiles;
                  onProgress(progress);
                  debugPrint('MVT Service: Progress: ${(progress * 100).toStringAsFixed(1)}% ($processedTiles/$totalTiles tiles)');
                }
              }
            } catch (e) {
              debugPrint('MVT Service: Error downloading tile $z/$x/$y - $e');
              // Continue with next tile
            }
          }
        }
      }

      debugPrint('MVT Service: Processed $processedTiles/$totalTiles tiles, extracted $totalFeatures features');

      // Save tileset metadata to database
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await _database.into(_database.mvtTilesets).insertOnConflictUpdate(
        MvtTilesetsCompanion(
          localityId: Value(localityIdInt),
          mbtilesPath: Value(''),
          minZoom: Value(minZoom),
          maxZoom: Value(maxZoom),
          boundsJson: Value(jsonEncode({
            'west': bounds.west,
            'south': bounds.south,
            'east': bounds.east,
            'north': bounds.north,
          })),
          isProposed: Value(isProposed),
          tileCount: Value(totalFeatures),
          downloadedAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      debugPrint('MVT Service: Tileset download complete');
      return true;
    } catch (e, stackTrace) {
      debugPrint('MVT Service: Failed to download tileset - $e');
      debugPrint('MVT Service: Stack trace - $stackTrace');
      return false;
    }
  }

  Future<List<int>?> _downloadTile(
    int z,
    int x,
    int y, {
    required String localityId,
    required bool isProposed,
  }) async {
    try {
      final url = '$_tilesEndpoint/$z/$x/$y.mvt?locality=$localityId&is_proposed=${isProposed ? 1 : 0}';
      
      final response = await _dioClient.get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return List<int>.from(response.data as List);
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Calculate tile range for given bounds and zoom
  _TileRange _calculateTileRange(LatLngBounds bounds, int zoom) {
    final minTile = _latLngToTile(bounds.southWest, zoom);
    final maxTile = _latLngToTile(bounds.northEast, zoom);

    return _TileRange(
      minX: minTile.x,
      maxX: maxTile.x,
      minY: maxTile.y,
      maxY: minTile.y,
      zoom: zoom,
    );
  }

  _TileCoordinate _latLngToTile(LatLng latLng, int zoom) {
    final n = pow(2, zoom).toInt();
    final latRad = latLng.latitude * pi / 180;
    
    final x = ((latLng.longitude + 180) / 360 * n).floor();
    final y = ((1 - log(tan(latRad) + 1 / cos(latRad)) / pi) / 2 * n).floor();
    
    return _TileCoordinate(x: x, y: y);
  }

  /// Delete downloaded tileset for a locality
  /// Deletes both the tileset metadata and all server features
  Future<bool> deleteTileset(String localityId) async {
    try {
      debugPrint('MVT Service: Deleting tileset for locality $localityId');

      final localityIdInt = int.tryParse(localityId);
      if (localityIdInt == null) return false;

      final serverFeatures = await _repository.getFeaturesByStatus(uploaded: true);
      await serverFeatures.fold(
        (failure) async => debugPrint('Error getting server features: ${failure.message}'),
        (features) async {
          final localityFeatures = features.where((f) => f.localityId == localityId);
          for (final feature in localityFeatures) {
            await _repository.deleteFeature(feature.clientUuid);
          }
        },
      );

      await (_database.delete(_database.mvtTilesets)
            ..where((tbl) => tbl.localityId.equals(localityIdInt)))
          .go();

      debugPrint('==MVT Service: Tileset deleted successfully');
      return true;
    } catch (e) {
      debugPrint('MVT Service: Error deleting tileset - $e');
      return false;
    }
  }

  Future<MvtTilesetInfo?> getTilesetInfo(String localityId) async {
    try {
      final localityIdInt = int.tryParse(localityId);
      if (localityIdInt == null) return null;

      final tileset = await (_database.select(_database.mvtTilesets)
            ..where((tbl) => tbl.localityId.equals(localityIdInt)))
          .getSingleOrNull();

      if (tileset == null) return null;

      final boundsData = jsonDecode(tileset.boundsJson) as Map<String, dynamic>;
      final southwest = LatLng(boundsData['south'], boundsData['west']);
      final northeast = LatLng(boundsData['north'], boundsData['east']);
      final bounds = LatLngBounds(southwest, northeast);

      return MvtTilesetInfo(
        localityId: localityId,
        mbtilesPath: tileset.mbtilesPath,
        minZoom: tileset.minZoom,
        maxZoom: tileset.maxZoom,
        bounds: bounds,
        isProposed: tileset.isProposed,
        tileCount: tileset.tileCount,
        downloadedAt: DateTime.fromMillisecondsSinceEpoch(tileset.downloadedAt * 1000),
      );
    } catch (e) {
      debugPrint('MVT Service: Error getting tileset info - $e');
      return null;
    }
  }

  /// Resume incomplete tileset download
  Future<bool> resumeTilesetDownload({
    required String projectId,
    required String localityId,
    Function(double)? onProgress,
  }) async {
    try {
      final info = await getTilesetInfo(localityId);
      if (info == null) return false;

      // Re-download with same parameters
      return await downloadTileset(
        projectId: projectId,
        localityId: localityId,
        bounds: info.bounds,
        minZoom: info.minZoom,
        maxZoom: info.maxZoom,
        isProposed: info.isProposed,
        onProgress: onProgress,
      );
    } catch (e) {
      debugPrint('MVT Service: Error resuming download - $e');
      return false;
    }
  }
}
// ==HELPERS
class _TileCoordinate {
  final int x;
  final int y;

  _TileCoordinate({required this.x, required this.y});
}

class _TileRange {
  final int minX;
  final int maxX;
  final int minY;
  final int maxY;
  final int zoom;

  _TileRange({
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
    required this.zoom,
  });

  int get tileCount => (maxX - minX + 1) * (maxY - minY + 1);
}

class MvtTilesetInfo {
  final String localityId;
  final String mbtilesPath;
  final int minZoom;
  final int maxZoom;
  final LatLngBounds bounds;
  final bool isProposed;
  final int tileCount;
  final DateTime downloadedAt;

  MvtTilesetInfo({
    required this.localityId,
    required this.mbtilesPath,
    required this.minZoom,
    required this.maxZoom,
    required this.bounds,
    required this.isProposed,
    required this.tileCount,
    required this.downloadedAt,
  });
}
