import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class UserLocation extends Equatable {
  final LatLng position;
  final double accuracy;
  final DateTime timestamp;
  final bool isInsideBoundary;
  final double? altitude;
  final double? heading;
  final double? speed;

  const UserLocation({
    required this.position,
    required this.accuracy,
    required this.timestamp,
    required this.isInsideBoundary,
    this.altitude,
    this.heading,
    this.speed,
  });

  UserLocation copyWith({
    LatLng? position,
    double? accuracy,
    DateTime? timestamp,
    bool? isInsideBoundary,
    double? altitude,
    double? heading,
    double? speed,
  }) {
    return UserLocation(
      position: position ?? this.position,
      accuracy: accuracy ?? this.accuracy,
      timestamp: timestamp ?? this.timestamp,
      isInsideBoundary: isInsideBoundary ?? this.isInsideBoundary,
      altitude: altitude ?? this.altitude,
      heading: heading ?? this.heading,
      speed: speed ?? this.speed,
    );
  }

  @override
  List<Object?> get props => [
        position,
        accuracy,
        timestamp,
        isInsideBoundary,
        altitude,
        heading,
        speed,
      ];
}
