import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../core/error/failures.dart';
import '../../core/env/env.dart';
import '../../shared/models/project.dart';

abstract class ProjectRepository {
  Future<Either<Failure, List<Project>>> getAssignedProjects();
  Future<Either<Failure, Project>> getProject(String id);
}

class ApiResponse<T> {
  final int statusCode;
  final T data;

  ApiResponse({required this.statusCode, required this.data});
}

class ProjectRepositoryImpl implements ProjectRepository {
  final Dio dio;

  const ProjectRepositoryImpl(this.dio);

  @override
  Future<Either<Failure, List<Project>>> getAssignedProjects() async {
    try {
      final response = await dio.get(
        '${Env.baseUrl}/projects/?is_app_user=true',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'] ?? response.data;

        // Flatten localities into individual projects
        final List<Project> projects = [];
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

        return Right(projects);
      } else {
        return Left(ServerFailure('Failed to fetch projects'));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return const Left(AuthFailure('Unauthorized'));
      }
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Project>> getProject(String id) async {
    try {
      // Note: id here is a locality id from our flattened structure
      // We need to fetch all projects and find the matching locality
      final projectsResult = await getAssignedProjects();

      return projectsResult.fold(
        (failure) => Left(failure),
        (projects) {
          try {
            final project = projects.firstWhere(
              (p) => p.id == id,
            );
            return Right(project);
          } catch (e) {
            return const Left(ServerFailure('Project not found'));
          }
        },
      );
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}
