import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/project.dart';
import '../../domain/repositories/project_repository.dart';
import '../datasources/project_local_datasource.dart';
import '../datasources/project_remote_datasource.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource remoteDataSource;
  final ProjectLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const ProjectRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Project>>> getAssignedProjects(
    String moduleSlug,
  ) async {
    final isOnline = await networkInfo.isConnected;
    if (isOnline) {
      final result = await remoteDataSource.getAssignedProjects(moduleSlug);
      
      return result.fold(
        (failure) async {
          final cachedResult = await localDataSource.getCachedProjects();
          return cachedResult.fold(
            (cacheFailure) async {
              final dbResult = await localDataSource.getProjectsFromDatabase();
              return dbResult.fold(
                (dbFailure) => Left(failure),
                (projects) => projects.isNotEmpty
                    ? Right(projects)
                    : Left(failure),
              );
            },
            (cachedProjects) => cachedProjects.isNotEmpty
                ? Right(cachedProjects)
                : Left(failure),
          );
        },
        (projects) async {
          await localDataSource.cacheProjects(projects);
          await localDataSource.storeProjectsInDatabase(projects);
          return Right(projects);
        },
      );
    }

    final cachedResult = await localDataSource.getCachedProjects();
    return cachedResult.fold(
      (failure) async {
        final dbResult = await localDataSource.getProjectsFromDatabase();
        return dbResult.fold(
          (dbFailure) => const Left(
            ServerFailure(
              'Hakuna data ya miradi imehifadhiwa. Tafadhali washa mtandao ili kusasisha.',
            ),
          ),
          (projects) => projects.isNotEmpty
              ? Right(projects)
              : const Left(
                  ServerFailure(
                    'Hakuna data ya miradi imehifadhiwa. Tafadhali washa mtandao ili kusasisha.',
                  ),
                ),
        );
      },
      (cachedProjects) => cachedProjects.isNotEmpty
          ? Right(cachedProjects)
          : const Left(
              ServerFailure(
                'Hakuna data ya miradi imehifadhiwa. Tafadhali washa mtandao ili kusasisha.',
              ),
            ),
    );
  }

  @override
  Future<Either<Failure, Project>> getProject(
    String id,
    String moduleSlug,
  ) async {
    try {
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
}
