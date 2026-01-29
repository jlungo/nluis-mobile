import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/auth_tables.dart';
import 'tables/project_tables.dart';
import 'tables/survey_tables.dart';
import 'tables/parcel_tables.dart';
import 'tables/basemap_tables.dart';
import 'tables/upload_tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Users,
    AuthTokens,
    AppSettings,
    Projects,
    ProjectPacks,
    QuestionnaireTypes,
    Questionnaires,
    Forms,
    FormFields,
    SurveyResponses,
    SubdivisionZones,
    SubdivisionApplications,
    Parties,
    Parcels,
    ParcelDrafts,
    Allocations,
    ParcelPhotos,
    BaseMaps,
    MvtTilesets,
    ZoningFeatures,
    ZoningFeatureHistory,
    FeatureUploadQueue,
    ManualZoneDrafts,
    LandUses,
    SyncLogs,
  ],
)
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
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'nluis_collect.db'));
    return NativeDatabase.createInBackground(file);
  });
}
