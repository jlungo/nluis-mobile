import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/project.dart';

abstract class ProjectRepository {
  Future<Either<Failure, List<Project>>> getAssignedProjects(String moduleSlug);
  Future<Either<Failure, Project>> getProject(String id, String moduleSlug);
}
