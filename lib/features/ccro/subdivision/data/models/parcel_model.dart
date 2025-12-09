import 'package:latlong2/latlong.dart';
import '../../domain/entities/parcel.dart';
import '../services/parcel_geometry_service.dart';

/// Data model for Parcel with JSON serialization
class ParcelModel extends Parcel {
  const ParcelModel({
    required super.clientId,
    super.serverId,
    super.parcelNumber,
    required super.applicationId,
    required super.zoneId,
    required super.localityId,
    super.hamletId,
    required super.geometry,
    super.geometryType,
    super.areaSqm,
    super.north,
    super.south,
    super.east,
    super.west,
    super.occupancyType,
    super.stage,
    super.hasConflicts,
    super.uploaded,
    super.uploadedAt,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Create ParcelModel from JSON (API response)
  factory ParcelModel.fromJson(Map<String, dynamic> json) {
    // Parse geometry
    Map<String, dynamic> geometry = {};
    if (json['geom'] != null) {
      if (json['geom'] is Map) {
        geometry = json['geom'] as Map<String, dynamic>;
      } else if (json['geom'] is String) {
        // Handle string geometry (shouldn't happen but defensive)
        geometry = {'type': 'Polygon', 'coordinates': []};
      }
    }

    // Parse stage
    ParcelStage stage = ParcelStage.draft;
    if (json['stage'] != null) {
      final stageStr = json['stage'].toString().toLowerCase();
      if (stageStr == 'registered') {
        stage = ParcelStage.registered;
      } else if (stageStr == 'printed') {
        stage = ParcelStage.printed;
      }
    }

    return ParcelModel(
      clientId: json['client_id'] as String,
      serverId: json['id'] as int?,
      parcelNumber: json['parcel_number'] as String?,
      applicationId: json['subdivision_application'] as String,
      zoneId: json['land_use_zone'] as int,
      localityId: json['locality'] as int,
      hamletId: json['hamlet'] as int?,
      geometry: geometry,
      geometryType: geometry['type'] as String?,
      areaSqm: (json['area_sqm'] as num?)?.toDouble(),
      north: json['north'] as String?,
      south: json['south'] as String?,
      east: json['east'] as String?,
      west: json['west'] as String?,
      occupancyType: json['occupancy_type'] as int?,
      stage: stage,
      hasConflicts: json['has_conflicts'] as bool? ?? false,
      uploaded: json['id'] != null, // If has server ID, it's uploaded
      uploadedAt: json['uploaded_at'] != null
          ? DateTime.parse(json['uploaded_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  /// Convert ParcelModel to JSON (for API request)
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'client_id': clientId,
      'subdivision_application': applicationId,
      'land_use_zone': zoneId,
      'locality': localityId,
      'geom': geometry,
    };

    // Optional fields
    if (serverId != null) json['id'] = serverId;
    if (parcelNumber != null) json['parcel_number'] = parcelNumber;
    if (hamletId != null) json['hamlet'] = hamletId;
    if (north != null) json['north'] = north;
    if (south != null) json['south'] = south;
    if (east != null) json['east'] = east;
    if (west != null) json['west'] = west;
    if (occupancyType != null) json['occupancy_type'] = occupancyType;
    if (areaSqm != null) json['area_sqm'] = areaSqm;

    // Stage as string
    json['stage'] = stage.name;

    return json;
  }

  /// Create ParcelModel from Parcel entity
  factory ParcelModel.fromEntity(Parcel parcel) {
    return ParcelModel(
      clientId: parcel.clientId,
      serverId: parcel.serverId,
      parcelNumber: parcel.parcelNumber,
      applicationId: parcel.applicationId,
      zoneId: parcel.zoneId,
      localityId: parcel.localityId,
      hamletId: parcel.hamletId,
      geometry: parcel.geometry,
      geometryType: parcel.geometryType,
      areaSqm: parcel.areaSqm,
      north: parcel.north,
      south: parcel.south,
      east: parcel.east,
      west: parcel.west,
      occupancyType: parcel.occupancyType,
      stage: parcel.stage,
      hasConflicts: parcel.hasConflicts,
      uploaded: parcel.uploaded,
      uploadedAt: parcel.uploadedAt,
      createdAt: parcel.createdAt,
      updatedAt: parcel.updatedAt,
    );
  }

  /// Create ParcelModel from coordinates
  factory ParcelModel.fromCoordinates({
    required String clientId,
    required String applicationId,
    required int zoneId,
    required int localityId,
    required List<LatLng> coordinates,
    int? hamletId,
    String? north,
    String? south,
    String? east,
    String? west,
    int? occupancyType,
    ParcelStage stage = ParcelStage.draft,
    int srid = 4326,
  }) {
    // Convert coordinates to GeoJSON
    final geometry = ParcelGeometryService.toGeoJsonPolygon(
      coordinates,
      srid: srid,
    );

    // Calculate area
    final areaSqm = ParcelGeometryService.calculateArea(coordinates);

    final now = DateTime.now();

    return ParcelModel(
      clientId: clientId,
      applicationId: applicationId,
      zoneId: zoneId,
      localityId: localityId,
      hamletId: hamletId,
      geometry: geometry,
      geometryType: 'Polygon',
      areaSqm: areaSqm,
      north: north,
      south: south,
      east: east,
      west: west,
      occupancyType: occupancyType,
      stage: stage,
      hasConflicts: false,
      uploaded: false,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Get coordinates from geometry
  List<LatLng> getCoordinates() {
    return ParcelGeometryService.fromGeoJsonPolygon(geometry);
  }
}
