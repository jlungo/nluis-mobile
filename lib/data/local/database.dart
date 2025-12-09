import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Table definitions
import 'tables/auth_tables.dart';
import 'tables/project_tables.dart';
import 'tables/survey_tables.dart';
import 'tables/zoning_tables.dart';
import 'tables/subdivision_tables.dart';
import 'tables/sync_tables.dart';

part 'database.g.dart';

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
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
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
