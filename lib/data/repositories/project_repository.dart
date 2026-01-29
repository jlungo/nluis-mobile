import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../core/network/dio_client.dart';
import '../../data/local/database.dart' as local_db;
import '../../shared/models/project.dart';

abstract class ProjectRepository {
  Future<Either<Failure, List<Project>>> getAssignedProjects(String moduleSlug);
  Future<Either<Failure, Project>> getProject(String id, String moduleSlug);
}

class ApiResponse<T> {
  final int statusCode;
  final T data;

  ApiResponse({required this.statusCode, required this.data});
}

class ProjectRepositoryImpl implements ProjectRepository {
  static const _cachedProjectsKey = 'cached_projects_v1';

  final DioClient dioClient;
  final local_db.AppDatabase database;
  final NetworkInfo networkInfo;
  final SharedPreferences preferences;

  const ProjectRepositoryImpl({
    required this.dioClient,
    required this.database,
    required this.networkInfo,
    required this.preferences,
  });

  @override
  Future<Either<Failure, List<Project>>> getAssignedProjects(
    String moduleSlug,
  ) async {
    final isOnline = await networkInfo.isConnected;
    if (isOnline) {
      try {
        final response = await dioClient.get(
          '/projects/',
          queryParameters: {'is_app_user': true, 'module_slug': moduleSlug},
        );

        if (response.statusCode == 200) {
          final projects = _parseProjects(response.data);
          await _cacheProjects(projects);
          await _storeProjectsInDatabase(projects);
          return Right(projects);
        }
        if (response.statusCode == 401) {
          return const Left(
            AuthFailure('Haujathibitishwa. Tafadhali ingia tena.'),
          );
        }
        return const Left(
          ServerFailure('Imeshindikana kupakia miradi kutoka seva.'),
        );
      } on DioException catch (e) {
        if (e.response?.statusCode == 401) {
          return const Left(
            AuthFailure('Haujathibitishwa. Tafadhali ingia tena.'),
          );
        }
        final cachedProjects = await _loadProjectsFromCache();
        if (cachedProjects.isNotEmpty) {
          return Right(cachedProjects);
        }
        final localProjects = await _loadProjectsFromDatabase();
        if (localProjects.isNotEmpty) {
          return Right(localProjects);
        }
        return Left(ServerFailure(e.message ?? 'Hitilafu ya mtandao'));
      } catch (e) {
        final cachedProjects = await _loadProjectsFromCache();
        if (cachedProjects.isNotEmpty) {
          return Right(cachedProjects);
        }
        final localProjects = await _loadProjectsFromDatabase();
        if (localProjects.isNotEmpty) {
          return Right(localProjects);
        }
        return Left(ServerFailure('Hitilafu: $e'));
      }
    }

    final cachedProjects = await _loadProjectsFromCache();
    if (cachedProjects.isNotEmpty) {
      return Right(cachedProjects);
    }

    final localProjects = await _loadProjectsFromDatabase();
    if (localProjects.isNotEmpty) {
      return Right(localProjects);
    }

    return const Left(
      ServerFailure(
        'Hakuna data ya miradi imehifadhiwa. Tafadhali washa mtandao ili kusasisha.',
      ),
    );
  }

  @override
  Future<Either<Failure, Project>> getProject(
    String id,
    String moduleSlug,
  ) async {
    try {
      // Note: id here is a locality id from our flattened structure
      // We need to fetch all projects and find the matching locality
      final projectsResult = await getAssignedProjects(moduleSlug);

      return projectsResult.fold((failure) => Left(failure), (projects) {
        try {
          final project = projects.firstWhere((p) => p.id == id);
          return Right(project);
        } catch (e) {
          return const Left(ServerFailure('Mradi haukupatikana'));
        }
      });
    } catch (e) {
      return Left(ServerFailure('Hitilafu: $e'));
    }
  }

  List<ProjectModel> _parseProjects(dynamic responseData) {
    final List<dynamic> data =
        responseData is Map<String, dynamic> &&
                responseData.containsKey('results')
            ? responseData['results'] as List<dynamic>
            : responseData as List<dynamic>;

    final List<ProjectModel> projects = [];

    for (final parentProject in data) {
      final localities = parentProject['localities'] as List<dynamic>? ?? [];
      for (final locality in localities) {
        final project = ProjectModel.fromLocalityJson(
          locality as Map<String, dynamic>,
          parentProject as Map<String, dynamic>,
        );
        projects.add(project);
      }
    }

    return projects;
  }

  Future<void> _cacheProjects(List<ProjectModel> projects) async {
    final payload = projects.map((project) => project.toJson()).toList();
    await preferences.setString(_cachedProjectsKey, jsonEncode(payload));
  }

  Future<void> _storeProjectsInDatabase(List<ProjectModel> projects) async {
    final existing = await database.select(database.projects).get();
    final existingMap = {for (final project in existing) project.id: project};
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    for (final project in projects) {
      final existingProject = existingMap[project.id];
      final assignedTimestamp =
          _dateStringToTimestamp(project.authorizationDate) ??
          existingProject?.assignedOn ??
          now;

      await database
          .into(database.projects)
          .insertOnConflictUpdate(
            local_db.ProjectsCompanion(
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
              isDownloaded: drift.Value(existingProject?.isDownloaded ?? false),
              downloadedAt:
                  existingProject?.downloadedAt != null
                      ? drift.Value(existingProject!.downloadedAt)
                      : const drift.Value.absent(),
              updatedAt: drift.Value(now),
            ),
          );
    }
  }

  Future<List<Project>> _loadProjectsFromCache() async {
    final cached = preferences.getString(_cachedProjectsKey);
    if (cached == null || cached.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(cached) as List<dynamic>;
      return decoded
          .map((item) => ProjectModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Project>> _loadProjectsFromDatabase() async {
    final records = await database.select(database.projects).get();
    if (records.isEmpty) {
      return [];
    }

    return records
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
  }

  int _statusStringToCode(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 3;
      case 'in process':
        return 2;
      case 'on hold':
        return 4;
      case 'pending':
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
