import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

/// Entity representing a parcel geometry draft (Step 3)
/// Stores only geometry and input method, not full parcel metadata
class ParcelDraft extends Equatable {
  final String clientId;
  final String applicationId;
  final int zoneId;
  final int localityId;
  final List<LatLng> coordinates;
  final String inputMethod; // 'tapping', 'manual', 'automaticRecording'
  final double? areaSqm;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ParcelDraft({
    required this.clientId,
    required this.applicationId,
    required this.zoneId,
    required this.localityId,
    required this.coordinates,
    required this.inputMethod,
    this.areaSqm,
    required this.createdAt,
    required this.updatedAt,
  });

  ParcelDraft copyWith({
    String? clientId,
    String? applicationId,
    int? zoneId,
    int? localityId,
    List<LatLng>? coordinates,
    String? inputMethod,
    double? areaSqm,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ParcelDraft(
      clientId: clientId ?? this.clientId,
      applicationId: applicationId ?? this.applicationId,
      zoneId: zoneId ?? this.zoneId,
      localityId: localityId ?? this.localityId,
      coordinates: coordinates ?? this.coordinates,
      inputMethod: inputMethod ?? this.inputMethod,
      areaSqm: areaSqm ?? this.areaSqm,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        clientId,
        applicationId,
        zoneId,
        localityId,
        coordinates,
        inputMethod,
        areaSqm,
        createdAt,
        updatedAt,
      ];
}
