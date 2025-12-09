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
