import 'package:equatable/equatable.dart';

/// Tanzania UTM Zones with SRID constants
class UtmZone extends Equatable {
  final int srid;
  final String name;
  final String description;
  final List<String> regions;
  final double minLongitude;
  final double maxLongitude;

  const UtmZone({
    required this.srid,
    required this.name,
    required this.description,
    required this.regions,
    required this.minLongitude,
    required this.maxLongitude,
  });

  /// Check if a longitude falls within this UTM zone
  bool containsLongitude(double longitude) {
    return longitude >= minLongitude && longitude < maxLongitude;
  }

  @override
  List<Object?> get props => [srid, name, description, regions, minLongitude, maxLongitude];
}

/// Tanzania UTM Zones configuration
class TanzaniaUtmZones {
  static const UtmZone utm35S = UtmZone(
    srid: 32735,
    name: 'UTM 35S',
    description: 'Western Tanzania',
    regions: ['Kigoma', 'Tabora', 'Rukwa', 'Katavi'],
    minLongitude: 27.0,
    maxLongitude: 33.0,
  );

  static const UtmZone utm36S = UtmZone(
    srid: 32736,
    name: 'UTM 36S',
    description: 'Central Tanzania',
    regions: ['Dodoma', 'Arusha', 'Mwanza', 'Singida', 'Manyara'],
    minLongitude: 33.0,
    maxLongitude: 39.0,
  );

  static const UtmZone utm37S = UtmZone(
    srid: 32737,
    name: 'UTM 37S',
    description: 'Eastern Tanzania',
    regions: ['Dar es Salaam', 'Mtwara', 'Lindi', 'Morogoro', 'Tanga', 'Zanzibar'],
    minLongitude: 39.0,
    maxLongitude: 45.0,
  );

  /// WGS84 - Default global coordinate system
  static const UtmZone wgs84 = UtmZone(
    srid: 4326,
    name: 'WGS84',
    description: 'Global Coordinate System',
    regions: ['Global'],
    minLongitude: -180.0,
    maxLongitude: 180.0,
  );

  static const List<UtmZone> allZones = [
    utm35S,
    utm36S,
    utm37S,
    wgs84,
  ];

  /// Auto-detect UTM zone based on longitude
  static UtmZone detectZone(double longitude) {
    if (longitude >= 27.0 && longitude < 33.0) {
      return utm35S;
    } else if (longitude >= 33.0 && longitude < 39.0) {
      return utm36S;
    } else if (longitude >= 39.0 && longitude < 45.0) {
      return utm37S;
    }
    // Default to WGS84 for coordinates outside Tanzania
    return wgs84;
  }

  /// Get zone by SRID
  static UtmZone? getZoneBySrid(int srid) {
    try {
      return allZones.firstWhere((zone) => zone.srid == srid);
    } catch (e) {
      return null;
    }
  }
}
