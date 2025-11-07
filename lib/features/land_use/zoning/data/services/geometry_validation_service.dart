import 'dart:math' as math;
import 'package:latlong2/latlong.dart';
import '../../domain/entities/zoning_feature.dart';

/// Service for validating and checking geometry integrity
class GeometryValidationService {
  static const double maxReasonableAreaKm2 = 1000.0; // 1000 km²
  static const double minReasonableLengthM = 0.1; // 0.1 meters
  static const double maxReasonableLengthKm = 500.0; // 500 km

  /// Validate a geometry before saving
  ValidationResult validate(ZoningFeatureType type, List<LatLng> coordinates) {
    if (coordinates.isEmpty) {
      return ValidationResult(
        isValid: false,
        error: 'Hakuna coordinates zilizotolewa',
      );
    }

    switch (type) {
      case ZoningFeatureType.point:
        return _validatePoint(coordinates);
      case ZoningFeatureType.lineString:
        return _validateLineString(coordinates);
      case ZoningFeatureType.polygon:
        return _validatePolygon(coordinates);
    }
  }

  ValidationResult _validatePoint(List<LatLng> coordinates) {
    if (coordinates.length != 1) {
      return ValidationResult(
        isValid: false,
        error: 'Pointi lazima iwe na coordinate moja tu',
      );
    }

    final coord = coordinates.first;
    if (!_isValidCoordinate(coord)) {
      return ValidationResult(
        isValid: false,
        error: 'Coordinate si sahihi: (${coord.latitude}, ${coord.longitude})',
      );
    }

    return ValidationResult(isValid: true);
  }

  ValidationResult _validateLineString(List<LatLng> coordinates) {
    if (coordinates.length < 2) {
      return ValidationResult(
        isValid: false,
        error: 'Mstari lazima uwe na coordinate angalau mbili',
      );
    }

    // Check for invalid coordinates
    for (var coord in coordinates) {
      if (!_isValidCoordinate(coord)) {
        return ValidationResult(
          isValid: false,
          error: 'Coordinate si sahihi: (${coord.latitude}, ${coord.longitude})',
        );
      }
    }

    // Check for duplicate consecutive points
    for (int i = 0; i < coordinates.length - 1; i++) {
      if (_arePointsEqual(coordinates[i], coordinates[i + 1])) {
        return ValidationResult(
          isValid: false,
          error: 'Coordinates zinazofanana zimegundulika katika nafasi ${i + 1}',
          warning: 'Pointi mbili zinazofuatana ni sawa',
        );
      }
    }

    // Calculate and validate length
    final lengthM = _calculateLineLength(coordinates);
    if (lengthM < minReasonableLengthM) {
      return ValidationResult(
        isValid: false,
        error: 'Urefu wa mstari ni mdogo sana (${lengthM.toStringAsFixed(2)}m)',
      );
    }

    if (lengthM > maxReasonableLengthKm * 1000) {
      return ValidationResult(
        isValid: true,
        warning: 'Urefu wa mstari ni mkubwa sana (${(lengthM / 1000).toStringAsFixed(2)}km). '
            'Hakikisha hii ni sahihi.',
      );
    }

    return ValidationResult(isValid: true);
  }

  ValidationResult _validatePolygon(List<LatLng> coordinates) {
    if (coordinates.length < 3) {
      return ValidationResult(
        isValid: false,
        error: 'Polygon lazima iwe na coordinates angalau tatu',
      );
    }

    // Check for invalid coordinates
    for (var coord in coordinates) {
      if (!_isValidCoordinate(coord)) {
        return ValidationResult(
          isValid: false,
          error: 'Coordinate si sahihi: (${coord.latitude}, ${coord.longitude})',
        );
      }
    }

    // Check if polygon is closed (first and last point should be same or very close)
    final isClosed = _arePointsEqual(coordinates.first, coordinates.last);
    final workingCoords = isClosed ? coordinates : [...coordinates, coordinates.first];

    // Check for self-intersection
    if (_hasSelfIntersection(workingCoords)) {
      return ValidationResult(
        isValid: false,
        error: 'Polygon inakatizana yenyewe. Tafadhali rekebisha mipaka',
      );
    }

    // Check for duplicate consecutive points
    for (int i = 0; i < workingCoords.length - 1; i++) {
      if (_arePointsEqual(workingCoords[i], workingCoords[i + 1])) {
        return ValidationResult(
          isValid: false,
          error: 'Coordinate zinazofanana zimegundulika katika nafasi ${i + 1}',
        );
      }
    }

    // Calculate and validate area
    final areaSqm = _calculatePolygonArea(workingCoords);
    if (areaSqm <= 0) {
      return ValidationResult(
        isValid: false,
        error: 'Eneo la polygon si sahihi (${areaSqm.toStringAsFixed(2)} m²)',
      );
    }

    final areaKm2 = areaSqm / 1_000_000;
    if (areaKm2 > maxReasonableAreaKm2) {
      return ValidationResult(
        isValid: true,
        warning: 'Eneo la polygon ni kubwa sana (${areaKm2.toStringAsFixed(2)} km²). '
            'Hakikisha hii ni sahihi.',
      );
    }

    return ValidationResult(isValid: true);
  }

  /// Check if a coordinate is valid (within Earth bounds)
  bool _isValidCoordinate(LatLng coord) {
    return coord.latitude >= -90 &&
        coord.latitude <= 90 &&
        coord.longitude >= -180 &&
        coord.longitude <= 180;
  }

  /// Check if two points are equal (within tolerance)
  bool _arePointsEqual(LatLng p1, LatLng p2, {double tolerance = 0.0000001}) {
    return (p1.latitude - p2.latitude).abs() < tolerance &&
        (p1.longitude - p2.longitude).abs() < tolerance;
  }

  /// Calculate line length in meters using Haversine formula
  double _calculateLineLength(List<LatLng> coordinates) {
    double totalLength = 0.0;
    const Distance distance = Distance();

    for (int i = 0; i < coordinates.length - 1; i++) {
      totalLength += distance.as(
        LengthUnit.Meter,
        coordinates[i],
        coordinates[i + 1],
      );
    }

    return totalLength;
  }

  /// Calculate polygon area in square meters
  /// Uses spherical excess method for accuracy over large areas
  double _calculatePolygonArea(List<LatLng> coordinates) {
    if (coordinates.length < 3) return 0.0;

    // Earth radius in meters
    const double earthRadius = 6378137.0;

    // Convert to radians and calculate spherical excess
    double area = 0.0;
    final int n = coordinates.length - 1; // Exclude last point

    for (int i = 0; i < n; i++) {
      final p1 = coordinates[i];
      final p2 = coordinates[(i + 1) % n];

      final lat1 = _toRadians(p1.latitude);
      final lng1 = _toRadians(p1.longitude);
      final lat2 = _toRadians(p2.latitude);
      final lng2 = _toRadians(p2.longitude);

      area += (lng2 - lng1) * (2 + math.sin(lat1) + math.sin(lat2));
    }

    area = area.abs() * earthRadius * earthRadius / 2.0;
    return area;
  }

  /// Check if polygon has self-intersection
  /// Uses line segment intersection algorithm
  bool _hasSelfIntersection(List<LatLng> coordinates) {
    if (coordinates.length < 4) return false;

    // Check each pair of non-adjacent edges
    for (int i = 0; i < coordinates.length - 1; i++) {
      for (int j = i + 2; j < coordinates.length - 1; j++) {
        // Skip adjacent edges
        if (i == 0 && j == coordinates.length - 2) continue;

        if (_doLineSegmentsIntersect(
          coordinates[i],
          coordinates[i + 1],
          coordinates[j],
          coordinates[j + 1],
        )) {
          return true;
        }
      }
    }

    return false;
  }

  /// Check if two line segments intersect
  bool _doLineSegmentsIntersect(LatLng p1, LatLng p2, LatLng p3, LatLng p4) {
    final d1 = _direction(p3, p4, p1);
    final d2 = _direction(p3, p4, p2);
    final d3 = _direction(p1, p2, p3);
    final d4 = _direction(p1, p2, p4);

    if (((d1 > 0 && d2 < 0) || (d1 < 0 && d2 > 0)) &&
        ((d3 > 0 && d4 < 0) || (d3 < 0 && d4 > 0))) {
      return true;
    }

    // Check collinear cases
    if (d1 == 0 && _onSegment(p3, p4, p1)) return true;
    if (d2 == 0 && _onSegment(p3, p4, p2)) return true;
    if (d3 == 0 && _onSegment(p1, p2, p3)) return true;
    if (d4 == 0 && _onSegment(p1, p2, p4)) return true;

    return false;
  }

  /// Calculate direction/orientation of three points
  double _direction(LatLng p1, LatLng p2, LatLng p3) {
    return (p3.latitude - p1.latitude) * (p2.longitude - p1.longitude) -
        (p2.latitude - p1.latitude) * (p3.longitude - p1.longitude);
  }

  /// Check if point p lies on line segment (p1, p2)
  bool _onSegment(LatLng p1, LatLng p2, LatLng p) {
    return p.latitude <= math.max(p1.latitude, p2.latitude) &&
        p.latitude >= math.min(p1.latitude, p2.latitude) &&
        p.longitude <= math.max(p1.longitude, p2.longitude) &&
        p.longitude >= math.min(p1.longitude, p2.longitude);
  }

  double _toRadians(double degrees) {
    return degrees * math.pi / 180.0;
  }
}

/// Result of geometry validation
class ValidationResult {
  final bool isValid;
  final String? error;
  final String? warning;

  ValidationResult({
    required this.isValid,
    this.error,
    this.warning,
  });

  bool get hasWarning => warning != null;
  bool get hasError => error != null;
}
