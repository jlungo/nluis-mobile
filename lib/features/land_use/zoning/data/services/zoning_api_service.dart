import '../../../../../core/network/dio_client.dart';
import '../../domain/entities/zoning_feature.dart';

/// API Service for zoning operations with proper SRID-embedded geometry payloads
class ZoningApiService {
  final DioClient _dioClient;

  ZoningApiService({required DioClient dioClient}) : _dioClient = dioClient;

  /// TODO: Create a single zone with SRID-embedded geometry
  /// 
  /// Request format:
  /// ```json
  /// {
  ///   "land_use": 2,
  ///   "locality": 5,
  ///   "geom": {
  ///     "type": "Polygon",
  ///     "coordinates": [[[lng, lat], ...]],
  ///     "srid": 4326
  ///   },
  ///   "status": "Draft",
  ///   "is_proposed": false,
  ///   "source": "field_survey",
  ///   "version": 1
  /// }
  /// ```
  Future<Map<String, dynamic>> createZone(ZoningFeature feature) async {
    try {
      final payload = _buildZonePayload(feature);
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/api/zoning/zones/',
        data: payload,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data ?? {};
      }

      throw Exception('Failed to create zone: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  /// Bulk upload zones using GeoJSON FeatureCollection format
  /// 
  /// POST /api/v1/zoning/zones/bulk/
  /// 
  /// Request format:
  /// ```json
  /// {
  ///   "type": "FeatureCollection",
  ///   "features": [
  ///     {
  ///       "type": "Feature",
  ///       "geometry": {
  ///         "type": "Polygon",
  ///         "coordinates": [[[lng, lat], ...]]
  ///       },
  ///       "properties": {
  ///         "land_use": 3,
  ///         "locality": 55,
  ///         "source": "QField",
  ///         "version": 1
  ///       }
  ///     }
  ///   ]
  /// }
  /// ```
  Future<Map<String, dynamic>> bulkUploadZones({
    int? planId,
    required List<ZoningFeature> features,
  }) async {
    try {
      final geoJsonFeatures = features.map((feature) => 
        _buildGeoJsonFeature(feature, planId)
      ).toList();
      
      final featureCollection = {
        'type': 'FeatureCollection',
        'features': geoJsonFeatures,
      };

      final response = await _dioClient.post<Map<String, dynamic>>(
        '/api/v1/zoning/zones/bulk/',
        data: featureCollection,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data ?? {};
      }

      throw Exception('Bulk upload failed: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  /// TODO: Get existing zones for a locality (for overlay)
  Future<List<Map<String, dynamic>>> getLocalityZones(String localityId) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '/api/zoning/locality/$localityId/zones/',
      );

      if (response.statusCode == 200) {
        final results = response.data?['results'] as List?;
        return results?.cast<Map<String, dynamic>>() ?? [];
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// Build GeoJSON Feature for API format
  Map<String, dynamic> _buildGeoJsonFeature(ZoningFeature feature, int? planId) {
    final coordinates = _buildCoordinates(feature);
    
    return {
      'type': 'Feature',
      'geometry': {
        'type': _getGeometryType(feature.featureType),
        'coordinates': coordinates,
      },
      'properties': {
        if (planId != null) 'plan': planId,
        if (feature.serverId != null) 'id': int.tryParse(feature.serverId!) ?? feature.serverId,
        if (feature.landUseId != null) 'land_use': feature.landUseId,
        'locality': int.parse(feature.localityId),
        'source': feature.source,
        'version': feature.version,
      },
    };
  }

  /// Build zone payload with SRID-embedded geometry (for single upload if needed)
  Map<String, dynamic> _buildZonePayload(ZoningFeature feature) {
    final coordinates = _buildCoordinates(feature);
    
    return {
      'client_uuid': feature.clientUuid,
      if (feature.landUseId != null) 'land_use': feature.landUseId,
      'locality': int.parse(feature.localityId),
      'geom': {
        'type': _getGeometryType(feature.featureType),
        'coordinates': coordinates,
        'srid': feature.srid,
      },
      'status': feature.status,
      'is_proposed': feature.isProposed,
      'source': feature.source,
      'version': feature.version,
    };
  }

  String _getGeometryType(ZoningFeatureType type) {
    switch (type) {
      case ZoningFeatureType.point:
        return 'Point';
      case ZoningFeatureType.lineString:
        return 'LineString';
      case ZoningFeatureType.polygon:
        return 'Polygon';
    }
  }

  dynamic _buildCoordinates(ZoningFeature feature) {
    // Limit precision to 6 decimal places for lat/lon (~ 0.1 meter accuracy)
    final coords = feature.coordinates
        .map((coord) => [
              _limitPrecision(coord.longitude, 6),
              _limitPrecision(coord.latitude, 6),
            ])
        .toList();

    switch (feature.featureType) {
      case ZoningFeatureType.point:
        return coords.first;
      case ZoningFeatureType.lineString:
        return coords;
      case ZoningFeatureType.polygon:
        // Ensure polygon is closed
        if (coords.first[0] != coords.last[0] || coords.first[1] != coords.last[1]) {
          coords.add(coords.first);
        }
        return [coords];
    }
  }

  double _limitPrecision(double value, int decimalPlaces) {
    final mod = (10.0 * decimalPlaces).toDouble();
    return (value * mod).round() / mod;
  }
}
