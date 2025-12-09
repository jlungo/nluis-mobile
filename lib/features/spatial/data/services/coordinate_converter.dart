import 'package:latlong2/latlong.dart';
import 'package:proj4dart/proj4dart.dart';

/// SRID information for display
class SridInfo {
  final int srid;
  final String name;
  final String description;
  final bool isMetric;
  final String coordinateFormat;

  const SridInfo({
    required this.srid,
    required this.name,
    required this.description,
    required this.isMetric,
    required this.coordinateFormat,
  });
}

/// Utility for converting coordinates between different EPSG/SRID systems
class CoordinateConverter {
  // Define common projections for Tanzania
  static final _projections = <int, Projection>{};

  /// Initialize projection definitions
  static void initialize() {
    if (_projections.isNotEmpty) return; // Already initialized

    // WGS84 (EPSG:4326) - GPS standard, Latitude/Longitude
    _projections[4326] = Projection.WGS84;

    // UTM Zone 36S (EPSG:32736) - Meters, Southern Hemisphere
    // Used for most of Tanzania (eastern regions)
    _projections[32736] = Projection.add(
      'EPSG:32736',
      '+proj=utm +zone=36 +south +datum=WGS84 +units=m +no_defs',
    );

    // UTM Zone 35S (EPSG:32735) - Meters, Southern Hemisphere
    // Used for western Tanzania
    _projections[32735] = Projection.add(
      'EPSG:32735',
      '+proj=utm +zone=35 +south +datum=WGS84 +units=m +no_defs',
    );

    // UTM Zone 37S (EPSG:32737) - Meters, Southern Hemisphere
    // Used for far eastern Tanzania
    _projections[32737] = Projection.add(
      'EPSG:32737',
      '+proj=utm +zone=37 +south +datum=WGS84 +units=m +no_defs',
    );
  }

  /// Convert coordinates from any SRID to WGS84 (EPSG:4326) for map display
  ///
  /// Returns LatLng in WGS84 format for displaying on map
  static LatLng toWGS84({
    required double x,
    required double y,
    required int fromSrid,
  }) {
    initialize();

    // If already WGS84, just return
    if (fromSrid == 4326) {
      return LatLng(y, x); // Assuming x=longitude, y=latitude
    }

    // Get source projection
    final sourceProj = _projections[fromSrid];
    if (sourceProj == null) {
      throw UnsupportedError('SRID $fromSrid is not supported');
    }

    // Convert from source to WGS84
    final wgs84 = _projections[4326]!;
    final point = Point(x: x, y: y);
    final converted = sourceProj.transform(wgs84, point);

    return LatLng(converted.y, converted.x);
  }

  /// Convert coordinates from WGS84 (EPSG:4326) to target SRID
  ///
  /// Returns [x, y] in target coordinate system
  static List<double> fromWGS84({
    required LatLng point,
    required int toSrid,
  }) {
    initialize();

    // If target is WGS84, just return
    if (toSrid == 4326) {
      return [point.longitude, point.latitude];
    }

    // Get target projection
    final targetProj = _projections[toSrid];
    if (targetProj == null) {
      throw UnsupportedError('SRID $toSrid is not supported');
    }

    // Convert from WGS84 to target
    final wgs84 = _projections[4326]!;
    final wgsPoint = Point(x: point.longitude, y: point.latitude);
    final converted = wgs84.transform(targetProj, wgsPoint);

    return [converted.x, converted.y];
  }

  /// Convert between any two SRIDs
  ///
  /// Returns [x, y] in target coordinate system
  static List<double> convert({
    required double x,
    required double y,
    required int fromSrid,
    required int toSrid,
  }) {
    initialize();

    // If same SRID, just return
    if (fromSrid == toSrid) {
      return [x, y];
    }

    // Get projections
    final sourceProj = _projections[fromSrid];
    final targetProj = _projections[toSrid];

    if (sourceProj == null) {
      throw UnsupportedError('Source SRID $fromSrid is not supported');
    }
    if (targetProj == null) {
      throw UnsupportedError('Target SRID $toSrid is not supported');
    }

    // Convert
    final point = Point(x: x, y: y);
    final converted = sourceProj.transform(targetProj, point);

    return [converted.x, converted.y];
  }

  /// Batch convert multiple coordinates from any SRID to WGS84
  static List<LatLng> batchToWGS84({
    required List<List<double>> coordinates,
    required int fromSrid,
  }) {
    return coordinates
        .map((coord) => toWGS84(x: coord[0], y: coord[1], fromSrid: fromSrid))
        .toList();
  }

  /// Batch convert multiple coordinates from WGS84 to target SRID
  static List<List<double>> batchFromWGS84({
    required List<LatLng> coordinates,
    required int toSrid,
  }) {
    return coordinates
        .map((coord) => fromWGS84(point: coord, toSrid: toSrid))
        .toList();
  }

  /// Get list of supported SRIDs with information
  static List<SridInfo> getSupportedSrids() {
    initialize();
    return [
      const SridInfo(
        srid: 4326,
        name: 'WGS84 (EPSG:4326)',
        description: 'GPS Standard - Latitude/Longitude in degrees',
        isMetric: false,
        coordinateFormat: 'Decimal Degrees (DD.DDDDDD)',
      ),
      const SridInfo(
        srid: 32736,
        name: 'UTM Zone 36S (EPSG:32736)',
        description: 'Meters - Eastern Tanzania',
        isMetric: true,
        coordinateFormat: 'Meters (Easting, Northing)',
      ),
      const SridInfo(
        srid: 32735,
        name: 'UTM Zone 35S (EPSG:32735)',
        description: 'Meters - Western Tanzania',
        isMetric: true,
        coordinateFormat: 'Meters (Easting, Northing)',
      ),
      const SridInfo(
        srid: 32737,
        name: 'UTM Zone 37S (EPSG:32737)',
        description: 'Meters - Far Eastern Tanzania',
        isMetric: true,
        coordinateFormat: 'Meters (Easting, Northing)',
      ),
    ];
  }

  /// Validate coordinate value based on SRID
  static String? validateCoordinate(double value, int srid, bool isLatitude) {
    if (srid == 4326) {
      // WGS84 validation
      if (isLatitude) {
        if (value < -90 || value > 90) {
          return 'Latitude must be between -90 and 90';
        }
      } else {
        if (value < -180 || value > 180) {
          return 'Longitude must be between -180 and 180';
        }
      }
    } else {
      // UTM validation (very rough bounds for Tanzania)
      if (value.abs() > 10000000) {
        return 'Coordinate value seems invalid for UTM';
      }
    }
    return null;
  }
}
