import 'dart:math';

import '../../../../../core/network/dio_client.dart';
import '../../domain/entities/zoning_feature.dart';

/// API Service for zoning operations with proper SRID-embedded geometry payloads
class ZoningApiService {
  final DioClient _dioClient;

  ZoningApiService({required DioClient dioClient}) : _dioClient = dioClient;

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
  ///         "plan": null,
  ///         "land_use": 3,
  ///         "locality": 55,
  ///         "source": "MobileApp"
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
        '/zoning/zones/bulk/',
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
        '/zoning/locality/$localityId/zones/',
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
        'plan': planId,
        if (feature.landUseId != null) 'land_use': feature.landUseId,
        'locality': int.parse(feature.localityId),
        'source': 'MobileApp',
      },
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
    // Limit precision to 15 decimal places for maximum double precision
    // (~0.01 millimeter accuracy for lat/lon coordinates)
    final coords = feature.coordinates
        .map((coord) => [
              _limitPrecision(coord.longitude, 15),
              _limitPrecision(coord.latitude, 15),
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
    final mod = pow(10, decimalPlaces).toDouble();
    return (value * mod).round() / mod;
  }
}
