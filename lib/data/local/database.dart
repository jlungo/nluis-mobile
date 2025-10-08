import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

// Tables
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get email => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get mobileModulesJson => text().named('mobile_modules_json')();
  IntColumn get updatedAt => integer()();
}

class Projects extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get localityId => integer().named('locality_id')();
  TextColumn get status => text()();
  IntColumn get assignedOn => integer().named('assigned_on')();
  BoolColumn get hasSurvey => boolean().named('has_survey').withDefault(const Constant(false))();
  BoolColumn get hasZoning => boolean().named('has_zoning').withDefault(const Constant(false))();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}

class ProjectPacks extends Table {
  TextColumn get projectId => text().named('project_id')();
  TextColumn get status => text()();
  IntColumn get downloadedAt => integer().named('downloaded_at').nullable()();
  IntColumn get updatedAt => integer().named('updated_at')();
  IntColumn get sizeBytes => integer().named('size_bytes').nullable()();

  @override
  Set<Column> get primaryKey => {projectId};
}

class QuestionnaireTypes extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get slug => text()();
  IntColumn get localityId => integer().named('locality_id')();

  @override
  Set<Column> get primaryKey => {id};
}

class Questionnaires extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get slug => text()();
  IntColumn get typeId => integer().named('type_id')();
  TextColumn get version => text()();
  IntColumn get updatedAt => integer().named('updated_at')();
  IntColumn get localityId => integer().named('locality_id')();

  @override
  Set<Column> get primaryKey => {id};
}

class Forms extends Table {
  TextColumn get slug => text()();
  IntColumn get questionnaireId => integer().named('questionnaire_id').nullable()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get moduleSlug => text().named('module_slug')();
  TextColumn get workflowSlug => text().named('workflow_slug')();
  IntColumn get position => integer()();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {slug};
}

class FormFields extends Table {
  IntColumn get id => integer()();
  TextColumn get formSlug => text().named('form_slug')();
  TextColumn get label => text()();
  TextColumn get type => text()();
  TextColumn get name => text()();
  BoolColumn get required => boolean().withDefault(const Constant(false))();
  IntColumn get position => integer()();
  TextColumn get optionsJson => text().named('options_json').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SurveyResponses extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text().named('project_id')();
  IntColumn get questionnaireId => integer().named('questionnaire_id')();
  TextColumn get formSlug => text().named('form_slug').nullable()();
  TextColumn get answersJson => text().named('answers_json')();
  BoolColumn get isDraft => boolean().named('is_draft').withDefault(const Constant(true))();
  IntColumn get updatedAt => integer().named('updated_at')();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();
  TextColumn get schemaSnapshotJson => text().named('schema_snapshot_json').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class BaseMaps extends Table {
  TextColumn get projectId => text().named('project_id')();
  TextColumn get geoJson => text().named('geo_json')();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {projectId};
}

class ZoningFeatures extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text().named('project_id')();
  TextColumn get geomType => text().named('geom_type')();
  TextColumn get coordsJson => text().named('coords_json')();
  TextColumn get propertiesJson => text().named('properties_json').nullable()();
  BoolColumn get isDraft => boolean().named('is_draft').withDefault(const Constant(true))();
  IntColumn get updatedAt => integer().named('updated_at')();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncLogs extends Table {
  TextColumn get id => text()();
  TextColumn get refType => text().named('ref_type')();
  TextColumn get refId => text().named('ref_id')();
  TextColumn get op => text()();
  TextColumn get status => text()();
  TextColumn get lastError => text().named('last_error').nullable()();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  Users,
  Projects,
  ProjectPacks,
  QuestionnaireTypes,
  Questionnaires,
  Forms,
  FormFields,
  SurveyResponses,
  BaseMaps,
  ZoningFeatures,
  SyncLogs,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle migrations here when schema changes
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'nluis_app.db'));
    return NativeDatabase.createInBackground(file);
  });
}
