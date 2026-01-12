import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';
import 'package:vector_tile/vector_tile.dart';
import '../../domain/entities/zoning_feature.dart';

class MvtParserService {
  /// Goal ni extracts features from the 'zones' layer and converts them to
  /// ZoningFeature objects ready for database storage
  Future<List<ZoningFeature>> parseMvtTile(
    List<int> tileBytes, {
    required String projectId,
    required String localityId,
  }) async {
    try {
      final tile = VectorTile.fromBytes(bytes: Uint8List.fromList(tileBytes));
      
      final zonesLayer = tile.layers.firstWhere(
        (layer) => layer.name == 'zones',
        orElse: () => throw Exception('Zones layer not found in MVT tile'),
      );
      
      debugPrint('===MVT Parser: Found ${zonesLayer.features.length} features in zones layer');
      
      final features = <ZoningFeature>[];
      for (final vtFeature in zonesLayer.features) {
        try {
          final feature = _convertToZoningFeature(vtFeature, projectId, localityId);
          features.add(feature);
        } catch (e) {
          debugPrint('Imefeli hiii parser: Error converting feature - $e');
        }
      }
      
      return features;
    } catch (e) {
      debugPrint('== MVT Parser: Error parsing MVT tile - $e');
      return [];
    }
  }
  
  ZoningFeature _convertToZoningFeature(
    VectorTileFeature vtFeature,
    String projectId,
    String localityId,
  ) {
    final coordinates = _extractCoordinates(vtFeature);
    
    if (coordinates.isEmpty) {
      throw Exception('No coordinates found in feature');
    }
    
    final props = vtFeature.properties as Map<String, dynamic>? ?? {};
    final serverId = props['id']?.toString();
    final landUseId = props['land_use'] as int?;
    final isProposed = (props['is_proposed'] as int?) == 1;
    final status = props['status'] as String? ?? 'approved';
    
    final featureType = _getFeatureType(vtFeature.geometryType ?? GeometryType.Point);
    
    // Create ZoningFeature entity
    return ZoningFeature(
      clientUuid: const Uuid().v4(),
      serverId: serverId,
      projectId: '',
      localityId: localityId,
      landUseId: landUseId,
      featureType: featureType,
      srid: 4326,
      coordinates: coordinates,
      zoningType: _mapLandUseToZoningType(landUseId),
      isProposed: isProposed,
      status: status,
      source: 'Server',
      uploaded: true,
      isDraft: false,
      needsSync: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
  
  List<LatLng> _extractCoordinates(VectorTileFeature feature) {
    final coords = <LatLng>[];
    
    try {
      final geometry = feature.geometry;
      
      if (geometry == null) return coords;
      
      if (geometry is GeometryPoint) {
        // Point: [x, y]
        if (geometry.coordinates.length >= 2) {
          coords.add(LatLng(geometry.coordinates[1], geometry.coordinates[0]));
        }
      } else if (geometry is GeometryLineString) {
        // LineString: [[x, y], [x, y], ...]
        for (final coord in geometry.coordinates) {
          if (coord.length >= 2) {
            coords.add(LatLng(coord[1], coord[0]));
          }
        }
      } else if (geometry is GeometryPolygon) {
        // Polygon: [[[x, y], [x, y], ...]] (outer ring)
        if (geometry.coordinates.isNotEmpty) {
          final outerRing = geometry.coordinates[0];
          for (final coord in outerRing) {
            if (coord.length >= 2) {
              coords.add(LatLng(coord[1], coord[0]));
            }
          }
        }
      }
    } catch (e) {
      debugPrint('MVT Parser: Error extracting coordinates - $e');
    }
    
    return coords;
  }
  
  ZoningFeatureType _getFeatureType(GeometryType geomType) {
    switch (geomType) {
      case GeometryType.Point:
      case GeometryType.MultiPoint:
        return ZoningFeatureType.point;
      case GeometryType.LineString:
      case GeometryType.MultiLineString:
        return ZoningFeatureType.lineString;
      case GeometryType.Polygon:
      case GeometryType.MultiPolygon:
        return ZoningFeatureType.polygon;
    }
  }
  
  ZoningType _mapLandUseToZoningType(int? landUseId) {
    if (landUseId == null) return ZoningType.other;
    
    // TODO: Load hii mapping from database land_uses table
    switch (landUseId) {
      case 1:
        return ZoningType.residential;
      case 2:
        return ZoningType.commercial;
      case 3:
        return ZoningType.industrial;
      case 4:
        return ZoningType.agricultural;
      case 5:
        return ZoningType.recreational;
      case 6:
        return ZoningType.institutional;
      case 7:
        return ZoningType.mixed;
      default:
        return ZoningType.other;
    }
  }
}
