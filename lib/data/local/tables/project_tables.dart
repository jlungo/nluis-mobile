import 'package:drift/drift.dart';

/// Projects assigned to the user
class Projects extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get localityId => integer().named('locality_id')();
  TextColumn get status => text()();
  IntColumn get assignedOn => integer().named('assigned_on')();
  BoolColumn get hasSurvey =>
      boolean().named('has_survey').withDefault(const Constant(false))();
  BoolColumn get hasZoning =>
      boolean().named('has_zoning').withDefault(const Constant(false))();
  BoolColumn get isDownloaded =>
      boolean().named('is_downloaded').withDefault(const Constant(false))();
  IntColumn get downloadedAt => integer().named('downloaded_at').nullable()();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}

/// Project data packs for offline use
class ProjectPacks extends Table {
  TextColumn get projectId => text().named('project_id')();
  TextColumn get status => text()();
  IntColumn get downloadedAt => integer().named('downloaded_at').nullable()();
  IntColumn get updatedAt => integer().named('updated_at')();
  IntColumn get sizeBytes => integer().named('size_bytes').nullable()();

  @override
  Set<Column> get primaryKey => {projectId};
}
