import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart' as drift;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../models/project_model.dart';

abstract class ProjectLocalDataSource {
  Future<Either<Failure, void>> cacheProjects(List<ProjectModel> projects);
  Future<Either<Failure, List<ProjectModel>>> getCachedProjects();
  Future<Either<Failure, void>> storeProjectsInDatabase(
    List<ProjectModel> projects,
  );
  Future<Either<Failure, List<ProjectModel>>> getProjectsFromDatabase();
}

class ProjectLocalDataSourceImpl implements ProjectLocalDataSource {
  static const _cachedProjectsKey = 'cached_projects_v1';

  final SharedPreferences sharedPreferences;
  final AppDatabase database;

  const ProjectLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.database,
  });

  @override
  Future<Either<Failure, void>> cacheProjects(
    List<ProjectModel> projects,
  ) async {
    try {
      final payload = projects.map((project) => project.toJson()).toList();
      await sharedPreferences.setString(
        _cachedProjectsKey,
        jsonEncode(payload),
      );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Imeshindwa kuhifadhi miradi: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ProjectModel>>> getCachedProjects() async {
    try {
      final cached = sharedPreferences.getString(_cachedProjectsKey);
      if (cached == null || cached.isEmpty) {
        return const Right([]);
      }

      final List<dynamic> decoded = jsonDecode(cached) as List<dynamic>;
      final projects =
          decoded
              .map(
                (item) => ProjectModel.fromJson(item as Map<String, dynamic>),
              )
              .toList();
      return Right(projects);
    } catch (e) {
      return Left(CacheFailure('Imeshindwa kusoma miradi iliyohifadhiwa: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> storeProjectsInDatabase(
    List<ProjectModel> projects,
  ) async {
    try {
      final db = database;
      final existing = await db.select(db.projects).get();
      final existingMap = {for (final project in existing) project.id: project};
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      for (final project in projects) {
        final existingProject = existingMap[project.id];
        final assignedTimestamp =
            _dateStringToTimestamp(project.authorizationDate) ??
            existingProject?.assignedOn ??
            now;

        await db
            .into(db.projects)
            .insertOnConflictUpdate(
              ProjectsCompanion(
                id: drift.Value(project.id),
                name: drift.Value(project.name),
                localityId: drift.Value(
                  int.tryParse(project.localityId) ??
                      (existingProject?.localityId ?? 0),
                ),
                status: drift.Value(project.status),
                assignedOn: drift.Value(assignedTimestamp),
                hasSurvey: drift.Value(project.hasSurvey),
                hasZoning: drift.Value(project.hasZoning),
                isDownloaded: drift.Value(
                  existingProject?.isDownloaded ?? false,
                ),
                downloadedAt:
                    existingProject?.downloadedAt != null
                        ? drift.Value(existingProject!.downloadedAt)
                        : const drift.Value.absent(),
                updatedAt: drift.Value(now),
              ),
            );
      }
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure('Imeshindwa kuhifadhi miradi kwenye database: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<ProjectModel>>> getProjectsFromDatabase() async {
    try {
      final records = await database.select(database.projects).get();
      if (records.isEmpty) {
        return const Right([]);
      }

      final projects =
          records
              .map(
                (record) => ProjectModel(
                  id: record.id,
                  name: record.name,
                  localityId: record.localityId.toString(),
                  localityName: record.name,
                  parentProjectName: '',
                  organization: '',
                  authorizationDate:
                      record.assignedOn > 0
                          ? DateTime.fromMillisecondsSinceEpoch(
                            record.assignedOn * 1000,
                          ).toIso8601String()
                          : '',
                  projectStatus: _statusStringToCode(record.status),
                  createdAt: '',
                  progress: 0,
                  remarks: null,
                  hasSurvey: record.hasSurvey,
                  hasZoning: record.hasZoning,
                ),
              )
              .toList();
      return Right(projects);
    } catch (e) {
      return Left(CacheFailure('Imeshindwa kusoma miradi kutoka database: $e'));
    }
  }

  int _statusStringToCode(String status) {
    switch (status.toLowerCase()) {
      case 'imekamilika':
        return 3;
      case 'inaendelea':
        return 2;
      case 'imesimamishwa':
        return 4;
      case 'inasubiri':
        return 1;
      default:
        return 0;
    }
  }

  int? _dateStringToTimestamp(String value) {
    if (value.isEmpty) return null;
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return null;
    return parsed.millisecondsSinceEpoch ~/ 1000;
  }
}
