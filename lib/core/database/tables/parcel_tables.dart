import 'package:drift/drift.dart';

class SubdivisionZones extends Table {
  IntColumn get id => integer()();
  TextColumn get zoneName => text().named('zone_name')();
  IntColumn get localityId => integer().named('locality_id')();
  TextColumn get localityName => text().named('locality_name')();
  TextColumn get landUseName => text().named('land_use_name').nullable()();
  BoolColumn get canBeSubdivided =>
      boolean().named('can_be_subdivided').withDefault(const Constant(true))();
  RealColumn get areaSqm => real().named('area_sqm').nullable()();
  TextColumn get geomJson => text().named('geom_json').nullable()();
  IntColumn get downloadedAt => integer().named('downloaded_at')();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}

class SubdivisionApplications extends Table {
  TextColumn get clientId => text().named('client_id')();
  IntColumn get serverId => integer().named('server_id').nullable()();
  TextColumn get applicationNumber =>
      text().named('application_number').nullable()();
  IntColumn get zoneId => integer().named('zone_id')();
  IntColumn get localityId => integer().named('locality_id')();
  TextColumn get applicantId => text().named('applicant_id')();
  IntColumn get currentStep =>
      integer().named('current_step').withDefault(const Constant(0))();
  TextColumn get status =>
      text().withDefault(const Constant('draft'))();
  TextColumn get notes => text().nullable()();
  BoolColumn get uploaded => boolean().withDefault(const Constant(false))();
  IntColumn get uploadedAt => integer().named('uploaded_at').nullable()();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {clientId};
}

class Parties extends Table {
  TextColumn get clientId => text().named('client_id')();
  IntColumn get serverId => integer().named('server_id').nullable()();
  TextColumn get partyType => text().named('party_type')();
  TextColumn get firstName => text().named('first_name').nullable()();
  TextColumn get middleName => text().named('middle_name').nullable()();
  TextColumn get lastName => text().named('last_name').nullable()();
  TextColumn get nidaNumber => text().named('nida_number').nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get gender => text().nullable()();
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
  TextColumn get clientId => text().named('client_id')();
  IntColumn get serverId => integer().named('server_id').nullable()();
  TextColumn get parcelNumber => text().named('parcel_number').nullable()();
  TextColumn get applicationId => text().named('application_id')();
  IntColumn get zoneId => integer().named('zone_id')();
  IntColumn get localityId => integer().named('locality_id')();
  IntColumn get hamletId => integer().named('hamlet_id').nullable()();
  TextColumn get geomJson => text().named('geom_json')();
  TextColumn get geometryType => text().named('geometry_type').nullable()();
  RealColumn get areaSqm => real().named('area_sqm').nullable()();
  TextColumn get north => text().nullable()();
  TextColumn get south => text().nullable()();
  TextColumn get east => text().nullable()();
  TextColumn get west => text().nullable()();
  IntColumn get occupancyType => integer().named('occupancy_type').nullable()();
  TextColumn get stage => text().withDefault(const Constant('draft'))();
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
  TextColumn get clientId => text().named('client_id')();
  IntColumn get serverId => integer().named('server_id').nullable()();
  TextColumn get parcelId => text().named('parcel_id')();
  TextColumn get partyId => text().named('party_id').nullable()();
  TextColumn get partyName => text().named('party_name').nullable()();
  TextColumn get phoneNumber => text().named('phone_number').nullable()();
  TextColumn get nidaNumber => text().named('nida_number').nullable()();
  RealColumn get proposedShare => real().named('proposed_share')();
  TextColumn get proposedRightType =>
      text().named('proposed_right_type').withDefault(const Constant('customary'))();
  TextColumn get status =>
      text().withDefault(const Constant('proposed'))();
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
  TextColumn get clientId => text().named('client_id')();
  TextColumn get applicationId => text().named('application_id')();
  IntColumn get zoneId => integer().named('zone_id')();
  IntColumn get localityId => integer().named('locality_id')();
  TextColumn get coordsJson => text().named('coords_json')();
  TextColumn get inputMethod =>
      text().named('input_method').withDefault(const Constant('tapping'))();
  RealColumn get areaSqm => real().named('area_sqm').nullable()();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {clientId};
}

class ParcelPhotos extends Table {
  TextColumn get clientId => text().named('client_id')();
  IntColumn get serverId => integer().named('server_id').nullable()();
  TextColumn get parcelId => text().named('parcel_id')();
  TextColumn get photoPath => text().named('photo_path')();
  TextColumn get photoUrl => text().named('photo_url').nullable()();
  TextColumn get photoType =>
      text().named('photo_type').withDefault(const Constant('site'))();
  TextColumn get caption => text().nullable()();
  IntColumn get capturedAt => integer().named('captured_at')();
  BoolColumn get uploaded => boolean().withDefault(const Constant(false))();
  IntColumn get uploadedAt => integer().named('uploaded_at').nullable()();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {clientId};
}
