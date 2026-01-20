import 'dart:math' as math;
import 'package:latlong2/latlong.dart';

class CalculationService {
  /// Calculate the area of a polygon using the Shoelace formula
  /// Returns area in square meters
  static double calculatePolygonArea(List<LatLng> coordinates) {
    if (coordinates.length < 3) return 0.0;

    // Ensure polygon is closed
    final points = List<LatLng>.from(coordinates);
    if (points.first != points.last) {
      points.add(points.first);
    }

    double area = 0.0;
    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];

      // Convert to meters using approximate conversion
      final x1 = p1.longitude * _metersPerDegreeAtLatitude(p1.latitude);
      final y1 = p1.latitude * _metersPerDegree;
      final x2 = p2.longitude * _metersPerDegreeAtLatitude(p2.latitude);
      final y2 = p2.latitude * _metersPerDegree;

      area += (x1 * y2) - (x2 * y1);
    }

    return (area / 2.0).abs();
  }

  /// Calculate the length of a line using Haversine formula
  /// Returns length in meters
  static double calculateLineLength(List<LatLng> coordinates) {
    if (coordinates.length < 2) return 0.0;

    double totalLength = 0.0;
    for (int i = 0; i < coordinates.length - 1; i++) {
      totalLength += _haversineDistance(coordinates[i], coordinates[i + 1]);
    }

    return totalLength;
  }

  /// Calculate distance between two points using Haversine formula
  /// Returns distance in meters
  static double _haversineDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000; // Earth's radius in meters

    final lat1Rad = point1.latitude * (math.pi / 180);
    final lat2Rad = point2.latitude * (math.pi / 180);
    final deltaLatRad = (point2.latitude - point1.latitude) * (math.pi / 180);
    final deltaLngRad = (point2.longitude - point1.longitude) * (math.pi / 180);

    final a = math.sin(deltaLatRad / 2) * math.sin(deltaLatRad / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(deltaLngRad / 2) *
            math.sin(deltaLngRad / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  /// Approximate meters per degree of latitude (constant)
  static const double _metersPerDegree = 111111;

  /// Approximate meters per degree of longitude at given latitude
  static double _metersPerDegreeAtLatitude(double latitude) {
    return _metersPerDegree * math.cos(latitude * (math.pi / 180));
  }

  /// Calculate the centroid of a polygon
  static LatLng calculateCentroid(List<LatLng> coordinates) {
    if (coordinates.isEmpty) return const LatLng(0, 0);
    if (coordinates.length == 1) return coordinates.first;

    double totalLat = 0;
    double totalLng = 0;

    for (final point in coordinates) {
      totalLat += point.latitude;
      totalLng += point.longitude;
    }

    return LatLng(
      totalLat / coordinates.length,
      totalLng / coordinates.length,
    );
  }

  /// Format area for display (kilometers and meters only)
  static String formatArea(double areaInSquareMeters) {
    if (areaInSquareMeters >= 1000000) {
      return '${(areaInSquareMeters / 1000000).toStringAsFixed(2)} km²';
    } else {
      return '${areaInSquareMeters.toStringAsFixed(2)} m²';
    }
  }

  /// Format length for display (kilometers and meters only)
  static String formatLength(double lengthInMeters) {
    if (lengthInMeters >= 1000) {
      return '${(lengthInMeters / 1000).toStringAsFixed(2)} km';
    } else {
      return '${lengthInMeters.toStringAsFixed(2)} m';
    }
  }

  /// Check if GPS accuracy meets minimum requirement (5 meters or less)
  static bool isAccuracyAcceptable(double accuracyInMeters) {
    return accuracyInMeters <= 5.0;
  }

  /// Format accuracy for display
  static String formatAccuracy(double accuracyInMeters) {
    return '±${accuracyInMeters.toStringAsFixed(1)} m';
  }
}
