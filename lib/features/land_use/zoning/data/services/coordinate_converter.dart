import 'package:latlong2/latlong.dart';
import 'package:proj4dart/proj4dart.dart';

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

  /// Get human-readable name for SRID
  static String getSridName(int srid) {
    switch (srid) {
      case 4326:
        return 'WGS84 (Lat/Long)';
      case 32735:
        return 'UTM Zone 35S';
      case 32736:
        return 'UTM Zone 36S';
      case 32737:
        return 'UTM Zone 37S';
      default:
        return 'EPSG:$srid';
    }
  }

  /// Get coordinate format description for SRID
  static String getCoordinateFormat(int srid) {
    switch (srid) {
      case 4326:
        return 'Latitude/Longitude (degrees)';
      case 32736:
      case 32737:
      case 21036:
      case 21037:
        return 'Easting/Northing (meters)';
      default:
        return 'X/Y';
    }
  }

  /// Get list of supported SRIDs for Tanzania
  static List<SridInfo> getSupportedSrids() {
    return [
      SridInfo(
        srid: 4326,
        name: 'WGS84 (GPS)',
        description: 'Global standard - Latitude/Longitude',
        coordinateFormat: 'Decimal Degrees',
        isMetric: false,
      ),
      SridInfo(
        srid: 32735,
        name: 'UTM Zone 35S',
        description: 'Western Tanzania (WGS84 based)',
        coordinateFormat: 'Easting/Northing (meters)',
        isMetric: true,
      ),
      SridInfo(
        srid: 32736,
        name: 'UTM Zone 36S',
        description: 'Central Tanzania (WGS84 based)',
        coordinateFormat: 'Easting/Northing (meters)',
        isMetric: true,
      ),
      SridInfo(
        srid: 32737,
        name: 'UTM Zone 37S',
        description: 'Eastern/Coastal Tanzania (WGS84 based)',
        coordinateFormat: 'Easting/Northing (meters)',
        isMetric: true,
      ),
    ];
  }

  /// Validate coordinate values for given SRID
  static bool validateCoordinate({
    required double x,
    required double y,
    required int srid,
  }) {
    switch (srid) {
      case 4326:
        // WGS84: longitude [-180, 180], latitude [-90, 90]
        return x >= -180 && x <= 180 && y >= -90 && y <= 90;
      
      case 32735:
      case 32736:
      case 32737:
      case 21036:
      case 21037:
        // UTM Zones: approximate bounds for Tanzania
        // Easting: 166000 - 834000, Northing: 0 - 10000000 (south)
        return x >= 100000 && x <= 900000 && y >= 0 && y <= 10000000;
      
      default:
        return true; // Unknown SRID, allow any values
    }
  }
}

/// Information about a supported SRID
class SridInfo {
  final int srid;
  final String name;
  final String description;
  final String coordinateFormat;
  final bool isMetric;

  const SridInfo({
    required this.srid,
    required this.name,
    required this.description,
    required this.coordinateFormat,
    required this.isMetric,
  });
}
