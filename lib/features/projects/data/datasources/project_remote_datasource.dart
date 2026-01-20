import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../models/project_model.dart';

abstract class ProjectRemoteDataSource {
  Future<Either<Failure, List<ProjectModel>>> getAssignedProjects(
    String moduleSlug,
  );
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final DioClient dioClient;

  const ProjectRemoteDataSourceImpl(this.dioClient);

  @override
  Future<Either<Failure, List<ProjectModel>>> getAssignedProjects(
    String moduleSlug,
  ) async {
    try {
      final response = await dioClient.get(
        '/projects/',
        queryParameters: {'is_app_user': true, 'module_slug': moduleSlug},
      );

      if (response.statusCode == 200) {
        final projects = _parseProjects(response.data);
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
      return Left(ServerFailure(e.message ?? 'Hitilafu ya mtandao'));
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
}
