import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

enum ZoningFeatureType {
  point,
  lineString,
  polygon,
}

enum ZoningType {
  residential,
  commercial,
  industrial,
  agricultural,
  recreational,
  institutional,
  mixed,
  other,
}

class ZoningFeature extends Equatable {
  final String clientUuid;
  final String? serverId;
  final String projectId;
  final String localityId;
  final int? landUseId;
  final ZoningFeatureType featureType;
  final int srid;
  final List<LatLng> coordinates;
  final ZoningType zoningType;
  final String? plotId;
  final String? plotName;
  final String? notes;
  final String? ownershipDetails;
  final double? area; // For polygons (in square meters)
  final double? length; // For lines (in meters)
  final bool isProposed; // false = existing, true = proposed
  final String status; // Draft, Ready, Uploaded
  final String source; // field_survey, manual_input, etc.
  final int version;
  final bool uploaded;
  final DateTime? uploadedAt;
  final Map<String, dynamic>? metadata; // GPS accuracy, device info, etc.
  final bool isDraft;
  final bool needsSync;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ZoningFeature({
    required this.clientUuid,
    this.serverId,
    required this.projectId,
    required this.localityId,
    this.landUseId,
    required this.featureType,
    this.srid = 4326,
    required this.coordinates,
    required this.zoningType,
    this.plotId,
    this.plotName,
    this.notes,
    this.ownershipDetails,
    this.area,
    this.length,
    this.isProposed = false,
    this.status = 'Draft',
    this.source = 'field_survey',
    this.version = 1,
    this.uploaded = false,
    this.uploadedAt,
    this.metadata,
    required this.isDraft,
    required this.needsSync,
    required this.createdAt,
    required this.updatedAt,
  });

  ZoningFeature copyWith({
    String? clientUuid,
    String? serverId,
    String? projectId,
    String? localityId,
    int? landUseId,
    ZoningFeatureType? featureType,
    int? srid,
    List<LatLng>? coordinates,
    ZoningType? zoningType,
    String? plotId,
    String? plotName,
    String? notes,
    String? ownershipDetails,
    double? area,
    double? length,
    bool? isProposed,
    String? status,
    String? source,
    int? version,
    bool? uploaded,
    DateTime? uploadedAt,
    Map<String, dynamic>? metadata,
    bool? isDraft,
    bool? needsSync,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ZoningFeature(
      clientUuid: clientUuid ?? this.clientUuid,
      serverId: serverId ?? this.serverId,
      projectId: projectId ?? this.projectId,
      localityId: localityId ?? this.localityId,
      landUseId: landUseId ?? this.landUseId,
      featureType: featureType ?? this.featureType,
      srid: srid ?? this.srid,
      coordinates: coordinates ?? this.coordinates,
      zoningType: zoningType ?? this.zoningType,
      plotId: plotId ?? this.plotId,
      plotName: plotName ?? this.plotName,
      notes: notes ?? this.notes,
      ownershipDetails: ownershipDetails ?? this.ownershipDetails,
      area: area ?? this.area,
      length: length ?? this.length,
      isProposed: isProposed ?? this.isProposed,
      status: status ?? this.status,
      source: source ?? this.source,
      version: version ?? this.version,
      uploaded: uploaded ?? this.uploaded,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      metadata: metadata ?? this.metadata,
      isDraft: isDraft ?? this.isDraft,
      needsSync: needsSync ?? this.needsSync,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toGeoJson() {
    String geometryType;
    List<dynamic> geoJsonCoords;

    switch (featureType) {
      case ZoningFeatureType.point:
        geometryType = 'Point';
        geoJsonCoords = [coordinates.first.longitude, coordinates.first.latitude];
        break;
      case ZoningFeatureType.lineString:
        geometryType = 'LineString';
        geoJsonCoords = coordinates
            .map((coord) => [coord.longitude, coord.latitude])
            .toList();
        break;
      case ZoningFeatureType.polygon:
        geometryType = 'Polygon';
        geoJsonCoords = [
          coordinates
              .map((coord) => [coord.longitude, coord.latitude])
              .toList()
        ];
        break;
    }

    return {
      'type': 'Feature',
      'id': clientUuid,
      'geometry': {
        'type': geometryType,
        'coordinates': geoJsonCoords,
        'srid': srid,
      },
      'properties': {
        'clientUuid': clientUuid,
        'serverId': serverId,
        'projectId': projectId,
        'localityId': localityId,
        'landUseId': landUseId,
        'zoningType': zoningType.name,
        'plotId': plotId,
        'plotName': plotName,
        'notes': notes,
        'ownershipDetails': ownershipDetails,
        'area': area,
        'length': length,
        'isProposed': isProposed,
        'status': status,
        'source': source,
        'version': version,
        'uploaded': uploaded,
        'uploadedAt': uploadedAt?.toIso8601String(),
        'isDraft': isDraft,
        'needsSync': needsSync,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        ...?metadata,
      },
    };
  }

  @override
  List<Object?> get props => [
        clientUuid,
        serverId,
        projectId,
        localityId,
        landUseId,
        featureType,
        srid,
        coordinates,
        zoningType,
        plotId,
        plotName,
        notes,
        ownershipDetails,
        area,
        length,
        isProposed,
        status,
        source,
        version,
        uploaded,
        uploadedAt,
        metadata,
        isDraft,
        needsSync,
        createdAt,
        updatedAt,
      ];
}
