import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:turf/turf.dart' as turf;
import '../../domain/entities/user_location.dart';

class LocationService {
  static const LocationSettings _locationSettings = LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 1, // Update every 1 meter
  );

  StreamSubscription<Position>? _positionSubscription;
  final StreamController<UserLocation> _locationController =
      StreamController<UserLocation>.broadcast();

  Stream<UserLocation> get locationStream => _locationController.stream;

  Future<bool> checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<UserLocation?> getCurrentLocation({
    List<LatLng>? projectBoundary,
  }) async {
    try {
      final hasPermission = await checkPermissions();
      if (!hasPermission) return null;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
        ),
      );

      final userLatLng = LatLng(position.latitude, position.longitude);
      final isInsideBoundary = projectBoundary != null
          ? _isPointInPolygon(userLatLng, projectBoundary)
          : true;

      return UserLocation(
        position: userLatLng,
        accuracy: position.accuracy,
        timestamp: position.timestamp,
        isInsideBoundary: isInsideBoundary,
        altitude: position.altitude,
        heading: position.heading,
        speed: position.speed,
      );
    } catch (e) {
      return null;
    }
  }

  void startLocationTracking({List<LatLng>? projectBoundary}) async {
    final hasPermission = await checkPermissions();
    if (!hasPermission) return;

    _positionSubscription?.cancel();
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: _locationSettings,
    ).listen((position) {
      final userLatLng = LatLng(position.latitude, position.longitude);
      final isInsideBoundary = projectBoundary != null
          ? _isPointInPolygon(userLatLng, projectBoundary)
          : true;

      final userLocation = UserLocation(
        position: userLatLng,
        accuracy: position.accuracy,
        timestamp: position.timestamp,
        isInsideBoundary: isInsideBoundary,
        altitude: position.altitude,
        heading: position.heading,
        speed: position.speed,
      );

      _locationController.add(userLocation);
    });
  }

  void stopLocationTracking() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  bool _isPointInPolygon(LatLng point, List<LatLng> polygon) {
    try {
      final turfPoint = turf.Point(
        coordinates: turf.Position.of([point.longitude, point.latitude]),
      );

      final turfPolygon = turf.Polygon(
        coordinates: [
          polygon
              .map((p) => turf.Position.of([p.longitude, p.latitude]))
              .toList()
        ],
      );

      return turf.booleanPointInPolygon(turfPoint.coordinates, turfPolygon);
    } catch (e) {
      return false;
    }
  }

  double calculateDistance(LatLng point1, LatLng point2) {
    return Geolocator.distanceBetween(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
    );
  }

  void dispose() {
    _positionSubscription?.cancel();
    _locationController.close();
  }
}
