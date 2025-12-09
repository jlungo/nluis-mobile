import 'package:equatable/equatable.dart';

class SubdivisionZone extends Equatable {
  final int id;
  final String zoneName;
  final int localityId;
  final String localityName;
  final String? landUseName;
  final bool canBeSubdivided;
  final double? areaSqm;
  final Map<String, dynamic>? geometry; // GeoJSON geometry
  final DateTime downloadedAt;
  final DateTime updatedAt;

  const SubdivisionZone({
    required this.id,
    required this.zoneName,
    required this.localityId,
    required this.localityName,
    this.landUseName,
    this.canBeSubdivided = true,
    this.areaSqm,
    this.geometry,
    required this.downloadedAt,
    required this.updatedAt,
  });

  SubdivisionZone copyWith({
    int? id,
    String? zoneName,
    int? localityId,
    String? localityName,
    String? landUseName,
    bool? canBeSubdivided,
    double? areaSqm,
    Map<String, dynamic>? geometry,
    DateTime? downloadedAt,
    DateTime? updatedAt,
  }) {
    return SubdivisionZone(
      id: id ?? this.id,
      zoneName: zoneName ?? this.zoneName,
      localityId: localityId ?? this.localityId,
      localityName: localityName ?? this.localityName,
      landUseName: landUseName ?? this.landUseName,
      canBeSubdivided: canBeSubdivided ?? this.canBeSubdivided,
      areaSqm: areaSqm ?? this.areaSqm,
      geometry: geometry ?? this.geometry,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get areaFormatted {
    if (areaSqm == null) return 'N/A';
    if (areaSqm! >= 1000000) {
      return '${(areaSqm! / 1000000).toStringAsFixed(2)} km²';
    }
    return '${areaSqm!.toStringAsFixed(2)} m²';
  }

  @override
  List<Object?> get props => [
        id,
        zoneName,
        localityId,
        localityName,
        landUseName,
        canBeSubdivided,
        areaSqm,
        geometry,
        downloadedAt,
        updatedAt,
      ];
}
