import 'package:latlong2/latlong.dart';
import '../../../../spatial/data/services/calculation_service.dart';
import '../../../../spatial/data/services/geometry_validation_service.dart';

/// Service for handling parcel geometry operations
class ParcelGeometryService {
  /// Convert List to GeoJSON Polygon with SRID
  static Map<String, dynamic> toGeoJsonPolygon(
    List<LatLng> coordinates, {
    int srid = 4326,
  }) {
    // Ensure polygon is closed
    final closedCoords = GeometryValidationService.closePolygon(coordinates);

    return {
      'type': 'Polygon',
      'coordinates': [
        closedCoords.map((p) => [p.longitude, p.latitude]).toList(),
      ],
      'srid': srid,
    };
  }

  /// Parse GeoJSON Polygon to List
  static List<LatLng> fromGeoJsonPolygon(Map<String, dynamic> geoJson) {
    try {
      final coordinates = geoJson['coordinates'];
      if (coordinates == null || coordinates is! List) {
        return [];
      }

      // Handle Polygon type
      if (geoJson['type'] == 'Polygon') {
        final rings = coordinates;
        if (rings.isEmpty) return [];

        final outerRing = rings[0] as List;
        return outerRing
            .map(
              (coord) => LatLng(
                (coord[1] as num).toDouble(),
                (coord[0] as num).toDouble(),
              ),
            )
            .toList();
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  /// Calculate area of polygon in square meters
  static double calculateArea(List<LatLng> coordinates) {
    return CalculationService.calculatePolygonArea(coordinates);
  }

  /// Calculate perimeter of polygon in meters
  static double calculatePerimeter(List<LatLng> coordinates) {
    if (coordinates.length < 2) return 0.0;

    // Ensure polygon is closed for perimeter calculation
    final closedCoords = GeometryValidationService.closePolygon(coordinates);
    return CalculationService.calculateLineLength(closedCoords);
  }

  /// Validate polygon geometry
  static bool validatePolygon(List<LatLng> coordinates) {
    // Minimum 3 vertices for a polygon
    if (!GeometryValidationService.validatePolygonVertices(
      coordinates,
      minVertices: 3,
    )) {
      return false;
    }

    // Validate coordinate ranges
    if (!GeometryValidationService.validateAllCoordinates(coordinates)) {
      return false;
    }

    // Check for self-intersections
    if (!GeometryValidationService.hasNoSelfIntersections(coordinates)) {
      return false;
    }

    return true;
  }

  /// Format area for display
  static String formatArea(double areaInSquareMeters) {
    return CalculationService.formatArea(areaInSquareMeters);
  }

  /// Format perimeter for display
  static String formatPerimeter(double perimeterInMeters) {
    return CalculationService.formatLength(perimeterInMeters);
  }

  /// Calculate centroid of polygon
  static LatLng calculateCentroid(List<LatLng> coordinates) {
    return CalculationService.calculateCentroid(coordinates);
  }

  /// Check if parcel is within a zone boundary
  static bool isParcelWithinZone(
    List<LatLng> parcelCoordinates,
    List<LatLng> zoneBoundary,
  ) {
    return GeometryValidationService.isPolygonWithin(
      parcelCoordinates,
      zoneBoundary,
    );
  }

  /// Check if two parcels overlap
  static bool doParcelsOverlap(
    List<LatLng> parcel1Coordinates,
    List<LatLng> parcel2Coordinates,
  ) {
    return GeometryValidationService.doPolygonsIntersect(
      parcel1Coordinates,
      parcel2Coordinates,
    );
  }

  /// Simplify polygon by removing collinear points
  static List<LatLng> simplifyPolygon(
    List<LatLng> coordinates, {
    double tolerance = 0.00001,
  }) {
    return GeometryValidationService.simplifyPolygon(
      coordinates,
      tolerance: tolerance,
    );
  }
}
