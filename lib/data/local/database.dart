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
  TextColumn get description =>
      text().named('description').withDefault(const Constant(''))();
  TextColumn get moduleSlug =>
      text().named('module_slug').withDefault(const Constant(''))();
  TextColumn get moduleName =>
      text().named('module_name').withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

class Forms extends Table {
  TextColumn get slug => text()();
  IntColumn get questionnaireId =>
      integer().named('questionnaire_id').nullable()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get moduleSlug => text().named('module_slug')();
  TextColumn get workflowSlug => text().named('workflow_slug')();
  IntColumn get position => integer()();
  IntColumn get updatedAt => integer().named('updated_at')();
  TextColumn get sectionSlug =>
      text().named('section_slug').withDefault(const Constant(''))();
  TextColumn get sectionName =>
      text().named('section_name').withDefault(const Constant(''))();
  IntColumn get sectionPosition =>
      integer().named('section_position').withDefault(const Constant(0))();
  TextColumn get sectionDescription =>
      text().named('section_description').nullable()();

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
  TextColumn get surveyId =>
      text().named('survey_id')(); // Group forms into one survey
  TextColumn get projectId => text().named('project_id')();
  IntColumn get questionnaireId => integer().named('questionnaire_id')();
  TextColumn get questionnaireSlug =>
      text().named('questionnaire_slug').nullable()();
  TextColumn get formSlug => text().named('form_slug').nullable()();
  TextColumn get answersJson => text().named('answers_json')();
  BoolColumn get isDraft =>
      boolean().named('is_draft').withDefault(const Constant(true))();
  IntColumn get updatedAt => integer().named('updated_at')();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();
  TextColumn get schemaSnapshotJson =>
      text().named('schema_snapshot_json').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

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
  RealColumn get buffer =>
      real().withDefault(const Constant(0.0))(); // Buffer in meters
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

class ZoningFeatureHistory extends Table {
  TextColumn get id => text()();
  TextColumn get featureId => text().named('feature_id')();
  TextColumn get action =>
      text()(); // 'create', 'update', 'delete', 'coordinate_edit'
  TextColumn get userId => text().named('user_id').nullable()();
  TextColumn get oldDataJson => text().named('old_data_json').nullable()();
  TextColumn get newDataJson => text().named('new_data_json')();
  TextColumn get changesJson =>
      text().named('changes_json').nullable()(); // Specific field changes
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
      text().withDefault(
        const Constant('pending'),
      )(); // pending, uploading, failed, completed
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
  IntColumn get srid => integer()(); // EPSG code (4326, 32736, etc)
  TextColumn get featureType =>
      text().named('feature_type')(); // point, line, polygon
  TextColumn get pointsJson =>
      text().named('points_json')(); // [[x,y], [x,y], ...]
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

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {key};
}

// Land Subdivision Tables
class SubdivisionZones extends Table {
  IntColumn get id => integer()(); // Server ID
  TextColumn get zoneName => text().named('zone_name')();
  IntColumn get localityId => integer().named('locality_id')();
  TextColumn get localityName => text().named('locality_name')();
  TextColumn get landUseName => text().named('land_use_name').nullable()();
  BoolColumn get canBeSubdivided =>
      boolean().named('can_be_subdivided').withDefault(const Constant(true))();
  RealColumn get areaSqm => real().named('area_sqm').nullable()();
  TextColumn get geomJson =>
      text().named('geom_json').nullable()(); // GeoJSON geometry
  IntColumn get downloadedAt => integer().named('downloaded_at')();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}

class SubdivisionApplications extends Table {
  TextColumn get clientId => text().named('client_id')(); // Local UUID
  IntColumn get serverId =>
      integer().named('server_id').nullable()(); // Server ID after upload
  TextColumn get applicationNumber =>
      text().named('application_number').nullable()();
  IntColumn get zoneId => integer().named('zone_id')();
  IntColumn get localityId => integer().named('locality_id')();
  TextColumn get applicantId =>
      text().named('applicant_id')(); // Party client ID
  IntColumn get currentStep =>
      integer()
          .named('current_step')
          .withDefault(const Constant(0))(); // 0-5 for stepper position
  TextColumn get status =>
      text().withDefault(
        const Constant('draft'),
      )(); // draft, submitted, approved, rejected
  TextColumn get notes => text().nullable()();
  BoolColumn get uploaded => boolean().withDefault(const Constant(false))();
  IntColumn get uploadedAt => integer().named('uploaded_at').nullable()();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {clientId};
}

class Parties extends Table {
  TextColumn get clientId => text().named('client_id')(); // Local UUID
  IntColumn get serverId =>
      integer().named('server_id').nullable()(); // Server ID after upload
  TextColumn get partyType =>
      text().named('party_type')(); // individual, organization
  TextColumn get firstName => text().named('first_name').nullable()();
  TextColumn get middleName => text().named('middle_name').nullable()();
  TextColumn get lastName => text().named('last_name').nullable()();
  TextColumn get nidaNumber =>
      text().named('nida_number').nullable()(); // 20 digits
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get gender => text().nullable()(); // M, F
  TextColumn get dateOfBirth => text().named('date_of_birth').nullable()();
  BoolColumn get isCitizen =>
      boolean().named('is_citizen').withDefault(const Constant(true))();
  TextColumn get maritalStatus => text().named('marital_status').nullable()();
  TextColumn get occupation => text().nullable()();
  BoolColumn get uploaded => boolean().withDefault(const Constant(false))();
  IntColumn get uploadedAt => integer().named('uploaded_at').nullable()();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {clientId};
}

class Parcels extends Table {
  TextColumn get clientId => text().named('client_id')(); // Local UUID
  IntColumn get serverId =>
      integer().named('server_id').nullable()(); // Server ID after upload
  TextColumn get parcelNumber => text().named('parcel_number').nullable()();
  TextColumn get applicationId =>
      text().named('application_id')(); // Subdivision application client ID
  IntColumn get zoneId => integer().named('zone_id')();
  IntColumn get localityId => integer().named('locality_id')();
  IntColumn get hamletId => integer().named('hamlet_id').nullable()();
  TextColumn get geomJson =>
      text().named('geom_json')(); // GeoJSON geometry with SRID
  TextColumn get geometryType =>
      text().named('geometry_type').nullable()(); // Point, Polygon, etc.
  RealColumn get areaSqm => real().named('area_sqm').nullable()();
  TextColumn get north => text().nullable()(); // Boundary description
  TextColumn get south => text().nullable()();
  TextColumn get east => text().nullable()();
  TextColumn get west => text().nullable()();
  IntColumn get occupancyType => integer().named('occupancy_type').nullable()();
  TextColumn get stage =>
      text().withDefault(
        const Constant('draft'),
      )(); // draft, registered, printed
  BoolColumn get hasConflicts =>
      boolean().named('has_conflicts').withDefault(const Constant(false))();
  BoolColumn get uploaded => boolean().withDefault(const Constant(false))();
  IntColumn get uploadedAt => integer().named('uploaded_at').nullable()();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {clientId};
}

class Allocations extends Table {
  TextColumn get clientId => text().named('client_id')(); // Local UUID
  IntColumn get serverId =>
      integer().named('server_id').nullable()(); // Server ID after upload
  TextColumn get parcelId => text().named('parcel_id')(); // Parcel client ID
  TextColumn get partyId => text().named('party_id').nullable()(); // Party client ID (optional if direct entry)
  TextColumn get partyName => text().named('party_name').nullable()(); // Direct entry name
  TextColumn get phoneNumber => text().named('phone_number').nullable()(); // Direct entry phone
  TextColumn get nidaNumber => text().named('nida_number').nullable()(); // Direct entry NIDA
  RealColumn get proposedShare =>
      real().named('proposed_share')(); // Percentage (0-100)
  TextColumn get proposedRightType =>
      text()
          .named('proposed_right_type')
          .withDefault(const Constant('customary'))();
  TextColumn get status =>
      text().withDefault(
        const Constant('proposed'),
      )(); // proposed, approved, registered
  TextColumn get notes => text().nullable()();
  BoolColumn get uploaded => boolean().withDefault(const Constant(false))();
  IntColumn get uploadedAt => integer().named('uploaded_at').nullable()();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {clientId};
}

@DataClassName('ParcelDraftData')
class ParcelDrafts extends Table {
  TextColumn get clientId => text().named('client_id')(); // Local UUID
  TextColumn get applicationId =>
      text().named('application_id')(); // Subdivision application client ID
  IntColumn get zoneId => integer().named('zone_id')();
  IntColumn get localityId => integer().named('locality_id')();
  TextColumn get coordsJson =>
      text().named('coords_json')(); // [[lng, lat], ...] format
  TextColumn get inputMethod =>
      text()
          .named('input_method')
          .withDefault(const Constant('tapping'))(); // tapping, manual, auto
  RealColumn get areaSqm => real().named('area_sqm').nullable()();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {clientId};
}

class ParcelPhotos extends Table {
  TextColumn get clientId => text().named('client_id')(); // Local UUID
  IntColumn get serverId =>
      integer().named('server_id').nullable()(); // Server ID after upload
  TextColumn get parcelId => text().named('parcel_id')(); // Parcel client ID
  TextColumn get photoPath => text().named('photo_path')(); // Local file path
  TextColumn get photoUrl =>
      text().named('photo_url').nullable()(); // Server URL after upload
  TextColumn get photoType =>
      text()
          .named('photo_type')
          .withDefault(const Constant('site'))(); // site, boundary, other
  TextColumn get caption => text().nullable()();
  IntColumn get capturedAt => integer().named('captured_at')();
  BoolColumn get uploaded => boolean().withDefault(const Constant(false))();
  IntColumn get uploadedAt => integer().named('uploaded_at').nullable()();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {clientId};
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

@DriftDatabase(
  tables: [
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
    ZoningFeatureHistory,
    FeatureUploadQueue,
    ManualZoneDrafts,
    LandUses,
    AppSettings,
    SubdivisionZones,
    SubdivisionApplications,
    Parties,
    Parcels,
    ParcelDrafts,
    Allocations,
    ParcelPhotos,
    MvtTilesets,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 15;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Add questionnaireSlug column to survey_responses table
          await m.addColumn(surveyResponses, surveyResponses.questionnaireSlug);
        }
        if (from < 3) {
          // Add surveyId column to group forms into surveys
          await m.addColumn(surveyResponses, surveyResponses.surveyId);
        }
        if (from < 4) {
          // Add download tracking columns to projects
          await m.addColumn(projects, projects.isDownloaded);
          await m.addColumn(projects, projects.downloadedAt);
        }
        if (from < 5) {
          await m.addColumn(questionnaires, questionnaires.description);
          await m.addColumn(questionnaires, questionnaires.moduleSlug);
          await m.addColumn(questionnaires, questionnaires.moduleName);
          await m.addColumn(forms, forms.sectionSlug);
          await m.addColumn(forms, forms.sectionName);
          await m.addColumn(forms, forms.sectionPosition);
          await m.addColumn(forms, forms.sectionDescription);
        }
        if (from < 6) {
          // Recreate BaseMaps table with new schema
          await m.drop(baseMaps);
          await m.createTable(baseMaps);
        }
        if (from < 7) {
          // Recreate ZoningFeatures table with enhanced schema for upload tracking and SRID
          await m.drop(zoningFeatures);
          await m.createTable(zoningFeatures);
        }
        if (from < 8) {
          // Add feature edit history tracking and upload queue tables
          await m.createTable(zoningFeatureHistory);
          await m.createTable(featureUploadQueue);
        }
        if (from < 9) {
          // Add manual zone drafts table for manual coordinate entry
          await m.createTable(manualZoneDrafts);
        }
        if (from < 10) {
          // Add land uses table for local storage
          await m.createTable(landUses);
          // Add app settings table for buffer defaults
          await m.createTable(appSettings);
          // Add buffer column to zoning features
          await m.addColumn(zoningFeatures, zoningFeatures.buffer);
        }
        if (from < 11) {
          // Add MVT tilesets table for vector tile caching
          await m.createTable(mvtTilesets);
        }
        if (from < 12) {
          // Add land subdivision tables
          await m.createTable(subdivisionZones);
          await m.createTable(subdivisionApplications);
          await m.createTable(parties);
          await m.createTable(parcels);
          await m.createTable(allocations);
          await m.createTable(parcelPhotos);
        }
        if (from < 13) {
          // Add currentStep field for draft save/restore
          // Check if column exists before adding
          final result =
              await customSelect(
                "PRAGMA table_info(subdivision_applications)",
              ).get();

          final hasCurrentStep = result.any(
            (row) => row.data['name'] == 'current_step',
          );

          if (!hasCurrentStep) {
            await m.addColumn(
              subdivisionApplications,
              subdivisionApplications.currentStep,
            );
          }
        }
        if (from < 14) {
          // Add ParcelDrafts table for Step 3 geometry-only drafts
          await m.createTable(parcelDrafts);
        }
        if (from < 15) {
          // Add direct entry fields to allocations table
          await m.addColumn(allocations, allocations.partyName);
          await m.addColumn(allocations, allocations.phoneNumber);
          await m.addColumn(allocations, allocations.nidaNumber);
        }
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
