import 'package:drift/drift.dart';

/// Subdivision zones available for parceling
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

/// Subdivision applications
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

/// Parties (individuals or organizations)
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

/// Parcels created from subdivision
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

/// Allocations of parcels to parties
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

/// Parcel drafts for geometry-only storage
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

/// Parcel photos for documentation
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
