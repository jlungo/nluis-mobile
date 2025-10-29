import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class Basemap extends Equatable {
  final String localityId;
  final Map<String, dynamic> geoJson;
  final List<LatLng> boundary;
  final LatLng center;
  final double zoom;
  final DateTime downloadedAt;
  final String localPath;
  final bool isValid;

  const Basemap({
    required this.localityId,
    required this.geoJson,
    required this.boundary,
    required this.center,
    required this.zoom,
    required this.downloadedAt,
    required this.localPath,
    required this.isValid,
  });

  Basemap copyWith({
    String? localityId,
    Map<String, dynamic>? geoJson,
    List<LatLng>? boundary,
    LatLng? center,
    double? zoom,
    DateTime? downloadedAt,
    String? localPath,
    bool? isValid,
  }) {
    return Basemap(
      localityId: localityId ?? this.localityId,
      geoJson: geoJson ?? this.geoJson,
      boundary: boundary ?? this.boundary,
      center: center ?? this.center,
      zoom: zoom ?? this.zoom,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      localPath: localPath ?? this.localPath,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [
        localityId,
        geoJson,
        boundary,
        center,
        zoom,
        downloadedAt,
        localPath,
        isValid,
      ];
}
