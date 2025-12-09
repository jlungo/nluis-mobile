import 'package:latlong2/latlong.dart';
import 'package:turf/helpers.dart';
import 'package:turf/turf.dart' as turf;

/// Service for validating and analyzing geometric features
class GeometryValidationService {
  /// Validate if a point is inside a polygon boundary
  static bool isPointInPolygon(LatLng point, List<LatLng> polygon) {
    try {
      if (polygon.length < 3) return false;

      final turfPoint = Point(
        coordinates: Position.of([point.longitude, point.latitude]),
      );

      final turfPolygon = Polygon(
        coordinates: [
          polygon
              .map((p) => Position.of([p.longitude, p.latitude]))
              .toList()
        ],
      );

      return turf.booleanPointInPolygon(turfPoint.coordinates, turfPolygon);
    } catch (e) {
      return false;
    }
  }

  /// Validate if a polygon has minimum required vertices
  static bool validatePolygonVertices(List<LatLng> coordinates, {int minVertices = 3}) {
    return coordinates.length >= minVertices;
  }

  /// Validate if a line has minimum required points
  static bool validateLinePoints(List<LatLng> coordinates, {int minPoints = 2}) {
    return coordinates.length >= minPoints;
  }

  /// Check if polygon is closed (first and last points are the same)
  static bool isPolygonClosed(List<LatLng> coordinates) {
    if (coordinates.length < 2) return false;
    
    final first = coordinates.first;
    final last = coordinates.last;
    
    return first.latitude == last.latitude && first.longitude == last.longitude;
  }

  /// Close a polygon by adding the first point at the end if not already closed
  static List<LatLng> closePolygon(List<LatLng> coordinates) {
    if (isPolygonClosed(coordinates)) {
      return coordinates;
    }
    
    return [...coordinates, coordinates.first];
  }

  /// Check if two polygons intersect
  /// Simple implementation checking if any vertices of one polygon are inside the other
  static bool doPolygonsIntersect(List<LatLng> polygon1, List<LatLng> polygon2) {
    try {
      // Check if any point of polygon1 is inside polygon2
      for (final point in polygon1) {
        if (isPointInPolygon(point, polygon2)) {
          return true;
        }
      }
      
      // Check if any point of polygon2 is inside polygon1
      for (final point in polygon2) {
        if (isPointInPolygon(point, polygon1)) {
          return true;
        }
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Check if a polygon is within another polygon (containment)
  static bool isPolygonWithin(List<LatLng> inner, List<LatLng> outer) {
    try {
      // Check if all vertices of inner polygon are within outer polygon
      for (final point in inner) {
        if (!isPointInPolygon(point, outer)) {
          return false;
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Validate coordinate ranges (latitude: -90 to 90, longitude: -180 to 180)
  static bool validateCoordinateRanges(LatLng coordinate) {
    return coordinate.latitude >= -90 &&
        coordinate.latitude <= 90 &&
        coordinate.longitude >= -180 &&
        coordinate.longitude <= 180;
  }

  /// Validate all coordinates in a list
  static bool validateAllCoordinates(List<LatLng> coordinates) {
    return coordinates.every(validateCoordinateRanges);
  }

  /// Check if polygon has self-intersections (simple polygon check)
  static bool hasNoSelfIntersections(List<LatLng> coordinates) {
    if (coordinates.length < 4) return true; // Too few points to intersect

    // Check each edge against all other non-adjacent edges
    for (int i = 0; i < coordinates.length - 1; i++) {
      final p1 = coordinates[i];
      final p2 = coordinates[i + 1];

      for (int j = i + 2; j < coordinates.length - 1; j++) {
        // Skip adjacent edges
        if (j == i || j == i + 1) continue;

        final p3 = coordinates[j];
        final p4 = coordinates[j + 1];

        if (_doLineSegmentsIntersect(p1, p2, p3, p4)) {
          return false;
        }
      }
    }

    return true;
  }

  /// Check if two line segments intersect
  static bool _doLineSegmentsIntersect(
    LatLng p1,
    LatLng p2,
    LatLng p3,
    LatLng p4,
  ) {
    final d1 = _direction(p3, p4, p1);
    final d2 = _direction(p3, p4, p2);
    final d3 = _direction(p1, p2, p3);
    final d4 = _direction(p1, p2, p4);

    if (((d1 > 0 && d2 < 0) || (d1 < 0 && d2 > 0)) &&
        ((d3 > 0 && d4 < 0) || (d3 < 0 && d4 > 0))) {
      return true;
    }

    return false;
  }

  /// Calculate direction for line segment intersection check
  static double _direction(LatLng p1, LatLng p2, LatLng p3) {
    return (p3.longitude - p1.longitude) * (p2.latitude - p1.latitude) -
        (p2.longitude - p1.longitude) * (p3.latitude - p1.latitude);
  }

  /// Simplify polygon by removing collinear points
  static List<LatLng> simplifyPolygon(List<LatLng> coordinates, {double tolerance = 0.00001}) {
    if (coordinates.length <= 3) return coordinates;

    final simplified = <LatLng>[coordinates.first];

    for (int i = 1; i < coordinates.length - 1; i++) {
      final prev = simplified.last;
      final current = coordinates[i];
      final next = coordinates[i + 1];

      // Check if current point is collinear with prev and next
      if (!_areCollinear(prev, current, next, tolerance)) {
        simplified.add(current);
      }
    }

    simplified.add(coordinates.last);
    return simplified;
  }

  /// Check if three points are collinear
  static bool _areCollinear(LatLng p1, LatLng p2, LatLng p3, double tolerance) {
    final crossProduct = (p2.latitude - p1.latitude) * (p3.longitude - p1.longitude) -
        (p2.longitude - p1.longitude) * (p3.latitude - p1.latitude);
    return crossProduct.abs() < tolerance;
  }
}
