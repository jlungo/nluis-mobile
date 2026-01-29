import 'package:drift/drift.dart';

class ZoningFeatures extends Table {
  TextColumn get clientUuid => text().named('client_uuid')();
  TextColumn get serverId => text().named('server_id').nullable()();
  TextColumn get projectId => text().named('project_id')();
  IntColumn get localityId => integer().named('locality_id')();
  IntColumn get landUseId => integer().named('land_use_id').nullable()();
  TextColumn get geomType => text().named('geom_type')();
  IntColumn get srid => integer().withDefault(const Constant(4326))();
  TextColumn get coordsJson => text().named('coords_json')();
  RealColumn get areaSqm => real().named('area_sqm').nullable()();
  RealColumn get lengthM => real().named('length_m').nullable()();
  RealColumn get buffer => real().withDefault(const Constant(0.0))();
  TextColumn get propertiesJson => text().named('properties_json').nullable()();
  BoolColumn get isDraft =>
      boolean().named('is_draft').withDefault(const Constant(true))();
  BoolColumn get isProposed =>
      boolean().named('is_proposed').withDefault(const Constant(false))();
  TextColumn get status => text().withDefault(const Constant('Draft'))();
  TextColumn get source => text().withDefault(const Constant('field_survey'))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  BoolColumn get uploaded => boolean().withDefault(const Constant(false))();
  IntColumn get uploadedAt => integer().named('uploaded_at').nullable()();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();
  TextColumn get metadataJson => text().named('metadata_json').nullable()();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {clientUuid};
}

class ZoningFeatureHistory extends Table {
  TextColumn get id => text()();
  TextColumn get featureId => text().named('feature_id')();
  TextColumn get action => text()();
  TextColumn get userId => text().named('user_id').nullable()();
  TextColumn get oldDataJson => text().named('old_data_json').nullable()();
  TextColumn get newDataJson => text().named('new_data_json')();
  TextColumn get changesJson => text().named('changes_json').nullable()();
  IntColumn get timestamp => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class FeatureUploadQueue extends Table {
  TextColumn get id => text()();
  TextColumn get featureId => text().named('feature_id')();
  TextColumn get projectId => text().named('project_id')();
  IntColumn get retryCount =>
      integer().named('retry_count').withDefault(const Constant(0))();
  IntColumn get maxRetries =>
      integer().named('max_retries').withDefault(const Constant(5))();
  IntColumn get nextRetryAt => integer().named('next_retry_at').nullable()();
  TextColumn get lastError => text().named('last_error').nullable()();
  TextColumn get status =>
      text().withDefault(const Constant('pending'))();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}

class ManualZoneDrafts extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text().named('project_id')();
  TextColumn get zoneName => text().named('zone_name')();
  TextColumn get description => text().nullable()();
  IntColumn get srid => integer()();
  TextColumn get featureType => text().named('feature_type')();
  TextColumn get pointsJson => text().named('points_json')();
  IntColumn get pointCount =>
      integer().named('point_count').withDefault(const Constant(0))();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}

class LandUses extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get color => text()();
  TextColumn get styleJson => text().named('style_json').nullable()();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncLogs extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text().named('entity_type')();
  TextColumn get entityId => text().named('entity_id')();
  TextColumn get action => text()();
  TextColumn get status => text()();
  TextColumn get errorMessage => text().named('error_message').nullable()();
  IntColumn get attemptedAt => integer().named('attempted_at')();
  IntColumn get succeededAt => integer().named('succeeded_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
