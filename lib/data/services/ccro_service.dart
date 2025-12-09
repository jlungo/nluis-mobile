import 'dart:io';
import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';

/// CCRO service for handling land subdivision operations
/// Handles API calls for zones, parties, applications, parcels, allocations, and photos
class CcroService {
  final DioClient _dioClient;

  CcroService({required DioClient dioClient}) : _dioClient = dioClient;

  // ============== ZONES ==============

  /// Get subdivision zones for a locality (NO geometry)
  /// 
  /// Response structure:
  /// ```json
  /// [
  ///   {
  ///     "id": 4,
  ///     "zone_name": "Agricultural",
  ///     "locality_id": 6628,
  ///     "locality_name": "Msasani",
  ///     "can_be_subdivided": true,
  ///     "area_sqm": 4050094.13  // Number
  ///   }
  /// ]
  /// ```
  Future<List<Map<String, dynamic>>> getSubdivisionZones({
    required int localityId,
  }) async {
    final response = await _dioClient.get(
      '/zoning/subdivision-zones/',
      queryParameters: {'locality': localityId},
    );
    return List<Map<String, dynamic>>.from(response.data as List);
  }

  /// Get single zone WITH geometry
  /// 
  /// Response structure:
  /// ```json
  /// {
  ///   "id": 4,
  ///   "zone_name": "Agricultural",
  ///   "locality_id": 6628,
  ///   "locality_name": "Msasani",
  ///   "land_use_name": "Agricultural",
  ///   "can_be_subdivided": true,
  ///   "area_sqm": "4050094.13",  // String (note difference from list)
  ///   "geom": {
  ///     "type": "MultiPolygon",
  ///     "coordinates": [
  ///       [
  ///         [
  ///           [31.970622013141764, -3.6205964953392424],
  ///           [31.971063267593962, -3.628629547909796],
  ///           ...
  ///         ]
  ///       ]
  ///     ]
  ///   }
  /// }
  /// ```
  Future<Map<String, dynamic>> getSubdivisionZone({
    required int zoneId,
    required int localityId,
  }) async {
    final response = await _dioClient.get(
      '/zoning/subdivision-zones/$zoneId/',
      queryParameters: {'locality': localityId},
    );
    return response.data as Map<String, dynamic>;
  }

  // ============== PARTIES ==============

  /// Create party (applicant or owner)
  Future<Map<String, dynamic>> createParty({
    required Map<String, dynamic> partyData,
  }) async {
    final response = await _dioClient.post('/ccro/parties/', data: partyData);
    return response.data as Map<String, dynamic>;
  }

  /// Get party by server ID
  Future<Map<String, dynamic>> getParty(int partyId) async {
    final response = await _dioClient.get('/ccro/parties/$partyId/');
    return response.data as Map<String, dynamic>;
  }

  // ============== SUBDIVISION APPLICATIONS ==============

  /// Create subdivision application
  Future<Map<String, dynamic>> createSubdivisionApplication({
    required int zoneId,
    required int applicantId,
    String? notes,
  }) async {
    final response = await _dioClient.post(
      '/spatial/subdivision-applications/',
      data: {
        'zone_snapshot': zoneId,
        'parent_parcel': null,
        'applicant': applicantId,
        'submission_source': 'mobile',
        if (notes != null) 'notes': notes,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  /// Get subdivision application
  Future<Map<String, dynamic>> getSubdivisionApplication(
    int applicationId,
  ) async {
    final response = await _dioClient.get(
      '/spatial/subdivision-applications/$applicationId/',
    );
    return response.data as Map<String, dynamic>;
  }

  // ============== PARCELS ==============

  /// Create parcel
  Future<Map<String, dynamic>> createParcel({
    required int subdivisionApplicationId,
    required int zoneId,
    required int localityId,
    int? hamletId,
    required Map<String, dynamic> geometry, // GeoJSON with srid
    required String north,
    required String south,
    required String east,
    required String west,
    int? occupancyType,
  }) async {
    final response = await _dioClient.post(
      '/spatial/parcels/',
      data: {
        'subdivision_application': subdivisionApplicationId,
        'land_use_zone': zoneId,
        'locality': localityId,
        if (hamletId != null) 'hamlet': hamletId,
        'geom': geometry,
        'north': north,
        'south': south,
        'east': east,
        'west': west,
        if (occupancyType != null) 'occupancy_type': occupancyType,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  /// Get parcels (with filters)
  Future<List<Map<String, dynamic>>> getParcels({
    int? localityId,
    int? zoneId,
    int? applicationId,
    String? stage,
    bool? myParcels,
    bool? hasConflicts,
    bool? readyForCcro,
  }) async {
    final queryParams = <String, dynamic>{};
    if (localityId != null) queryParams['locality'] = localityId;
    if (zoneId != null) queryParams['zone'] = zoneId;
    if (applicationId != null) queryParams['application'] = applicationId;
    if (stage != null) queryParams['stage'] = stage;
    if (myParcels == true) queryParams['my_parcels'] = 'true';
    if (hasConflicts == true) queryParams['has_conflicts'] = 'true';
    if (readyForCcro == true) queryParams['ready_for_ccro'] = 'true';

    final response = await _dioClient.get(
      '/spatial/parcels/',
      queryParameters: queryParams,
    );
    return List<Map<String, dynamic>>.from(response.data as List);
  }

  /// Get parcels as GeoJSON (with geometry)
  Future<List<Map<String, dynamic>>> getParcelsGeoJson({
    int? localityId,
    int? zoneId,
  }) async {
    final queryParams = <String, dynamic>{};
    if (localityId != null) queryParams['locality'] = localityId;
    if (zoneId != null) queryParams['zone'] = zoneId;

    final response = await _dioClient.get(
      '/spatial/parcels/geojson/',
      queryParameters: queryParams,
    );
    return List<Map<String, dynamic>>.from(response.data as List);
  }

  // ============== ALLOCATIONS ==============

  /// Create allocation (owner share)
  Future<Map<String, dynamic>> createAllocation({
    required int parcelId,
    required int partyId,
    required double proposedShare,
    String proposedRightType = 'customary',
    String? notes,
  }) async {
    final response = await _dioClient.post(
      '/ccro/allocations/',
      data: {
        'parcel': parcelId,
        'party': partyId,
        'proposed_share': proposedShare,
        'proposed_right_type': proposedRightType,
        if (notes != null) 'notes': notes,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  /// Get allocations for a parcel
  Future<List<Map<String, dynamic>>> getAllocations({
    required int parcelId,
  }) async {
    final response = await _dioClient.get(
      '/ccro/allocations/',
      queryParameters: {'parcel': parcelId},
    );
    return List<Map<String, dynamic>>.from(response.data as List);
  }

  // ============== PARCEL PHOTOS ==============

  /// Upload parcel photos (bulk)
  Future<List<Map<String, dynamic>>> bulkUploadParcelPhotos({
    required int parcelId,
    required List<File> photos,
    String photoType = 'site',
    String? caption,
  }) async {
    final formData = FormData();

    formData.fields.add(MapEntry('parcel', parcelId.toString()));
    formData.fields.add(MapEntry('photo_type', photoType));
    if (caption != null) {
      formData.fields.add(MapEntry('caption', caption));
    }

    for (final photo in photos) {
      formData.files.add(
        MapEntry(
          'photos',
          await MultipartFile.fromFile(
            photo.path,
            filename: photo.path.split('/').last,
          ),
        ),
      );
    }

    final response = await _dioClient.post(
      '/spatial/parcel-photos/bulk_upload/',
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );

    return List<Map<String, dynamic>>.from(response.data as List);
  }
}
