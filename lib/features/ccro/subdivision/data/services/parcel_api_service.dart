import 'package:dio/dio.dart';
import '../../../../../core/network/dio_client.dart';

/// API service for parcel operations
class ParcelApiService {
  final DioClient _dioClient;
  static const String _basePath = '/api/spatial/parcels';

  ParcelApiService({required DioClient dioClient}) : _dioClient = dioClient;

  /// Create a new parcel
  /// POST /api/spatial/parcels/
  Future<Response> createParcel(Map<String, dynamic> parcelData) async {
    return await _dioClient.post(
      '$_basePath/',
      data: parcelData,
    );
  }

  /// Get parcels as GeoJSON
  /// GET /api/spatial/parcels/geojson/
  /// Query parameters: locality, zone
  Future<Response> getParcelsGeoJson({
    int? localityId,
    int? zoneId,
  }) async {
    final queryParams = <String, dynamic>{};
    if (localityId != null) queryParams['locality'] = localityId;
    if (zoneId != null) queryParams['zone'] = zoneId;

    return await _dioClient.get(
      '$_basePath/geojson/',
      queryParameters: queryParams,
    );
  }

  /// Update an existing parcel
  /// PUT /api/spatial/parcels/{id}/
  Future<Response> updateParcel(
    int parcelId,
    Map<String, dynamic> parcelData,
  ) async {
    return await _dioClient.put(
      '$_basePath/$parcelId/',
      data: parcelData,
    );
  }

  /// Delete a parcel
  /// DELETE /api/spatial/parcels/{id}/
  Future<Response> deleteParcel(int parcelId) async {
    return await _dioClient.delete('$_basePath/$parcelId/');
  }

  /// Get a single parcel by ID
  /// GET /api/spatial/parcels/{id}/
  Future<Response> getParcel(int parcelId) async {
    return await _dioClient.get('$_basePath/$parcelId/');
  }

  /// Get parcels for a specific subdivision application
  /// GET /api/spatial/parcels/?subdivision_application={id}
  Future<Response> getParcelsByApplication(String applicationId) async {
    return await _dioClient.get(
      '$_basePath/',
      queryParameters: {'subdivision_application': applicationId},
    );
  }
}
