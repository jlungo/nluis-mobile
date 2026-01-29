import 'package:drift/drift.dart';

class BaseMaps extends Table {
  IntColumn get localityId => integer().named('locality_id')();
  TextColumn get geoJson => text().named('geo_json')();
  RealColumn get centerLat => real().named('center_lat').nullable()();
  RealColumn get centerLng => real().named('center_lng').nullable()();
  RealColumn get zoom => real().nullable()();
  IntColumn get downloadedAt => integer().named('downloaded_at')();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {localityId};
}

class MvtTilesets extends Table {
  IntColumn get localityId => integer().named('locality_id')();
  TextColumn get mbtilesPath => text().named('mbtiles_path')();
  IntColumn get minZoom => integer().named('min_zoom')();
  IntColumn get maxZoom => integer().named('max_zoom')();
  TextColumn get boundsJson => text().named('bounds_json')();
  BoolColumn get isProposed =>
      boolean().named('is_proposed').withDefault(const Constant(false))();
  IntColumn get tileCount =>
      integer().named('tile_count').withDefault(const Constant(0))();
  IntColumn get downloadedAt => integer().named('downloaded_at')();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {localityId};
}
