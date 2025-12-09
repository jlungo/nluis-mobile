import 'package:equatable/equatable.dart';

enum ParcelStage {
  draft,
  registered,
  printed,
}

class Parcel extends Equatable {
  final String clientId; // Local UUID
  final int? serverId; // Server ID after upload
  final String? parcelNumber;
  final String applicationId; // Subdivision application client ID
  final int zoneId;
  final int localityId;
  final int? hamletId;
  final Map<String, dynamic> geometry; // GeoJSON with SRID
  final String? geometryType; // Point, Polygon, etc.
  final double? areaSqm;
  
  // Boundary descriptions
  final String? north;
  final String? south;
  final String? east;
  final String? west;
  
  final int? occupancyType;
  final ParcelStage stage;
  final bool hasConflicts;
  final bool uploaded;
  final DateTime? uploadedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Parcel({
    required this.clientId,
    this.serverId,
    this.parcelNumber,
    required this.applicationId,
    required this.zoneId,
    required this.localityId,
    this.hamletId,
    required this.geometry,
    this.geometryType,
    this.areaSqm,
    this.north,
    this.south,
    this.east,
    this.west,
    this.occupancyType,
    this.stage = ParcelStage.draft,
    this.hasConflicts = false,
    this.uploaded = false,
    this.uploadedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isDraft => stage == ParcelStage.draft;
  bool get isRegistered => stage == ParcelStage.registered;
  bool get isPrinted => stage == ParcelStage.printed;

  String get areaFormatted {
    if (areaSqm == null) return 'N/A';
    if (areaSqm! >= 1000000) {
      return '${(areaSqm! / 1000000).toStringAsFixed(2)} km²';
    }
    return '${areaSqm!.toStringAsFixed(2)} m²';
  }

  String get stageLabel {
    switch (stage) {
      case ParcelStage.draft:
        return 'Rasimu';
      case ParcelStage.registered:
        return 'Imesajiliwa';
      case ParcelStage.printed:
        return 'Imechapishwa';
    }
  }

  Parcel copyWith({
    String? clientId,
    int? serverId,
    String? parcelNumber,
    String? applicationId,
    int? zoneId,
    int? localityId,
    int? hamletId,
    Map<String, dynamic>? geometry,
    String? geometryType,
    double? areaSqm,
    String? north,
    String? south,
    String? east,
    String? west,
    int? occupancyType,
    ParcelStage? stage,
    bool? hasConflicts,
    bool? uploaded,
    DateTime? uploadedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Parcel(
      clientId: clientId ?? this.clientId,
      serverId: serverId ?? this.serverId,
      parcelNumber: parcelNumber ?? this.parcelNumber,
      applicationId: applicationId ?? this.applicationId,
      zoneId: zoneId ?? this.zoneId,
      localityId: localityId ?? this.localityId,
      hamletId: hamletId ?? this.hamletId,
      geometry: geometry ?? this.geometry,
      geometryType: geometryType ?? this.geometryType,
      areaSqm: areaSqm ?? this.areaSqm,
      north: north ?? this.north,
      south: south ?? this.south,
      east: east ?? this.east,
      west: west ?? this.west,
      occupancyType: occupancyType ?? this.occupancyType,
      stage: stage ?? this.stage,
      hasConflicts: hasConflicts ?? this.hasConflicts,
      uploaded: uploaded ?? this.uploaded,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        clientId,
        serverId,
        parcelNumber,
        applicationId,
        zoneId,
        localityId,
        hamletId,
        geometry,
        geometryType,
        areaSqm,
        north,
        south,
        east,
        west,
        occupancyType,
        stage,
        hasConflicts,
        uploaded,
        uploadedAt,
        createdAt,
        updatedAt,
      ];
}
