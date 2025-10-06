import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../data/repositories/project_repository.dart';
import '../../../../../features/auth/presentation/providers/auth_providers.dart';
import '../../../../../shared/models/project.dart';

// Project Repository Provider
final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ProjectRepositoryImpl(dioClient.dio);
});

// Assigned Projects Provider
final assignedProjectsProvider = FutureProvider<List<Project>>((ref) async {
  final repository = ref.watch(projectRepositoryProvider);
  final result = await repository.getAssignedProjects();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (projects) => projects,
  );
});

// Single Project Provider
final projectProvider = FutureProvider.family<Project, String>((ref, id) async {
  final repository = ref.watch(projectRepositoryProvider);
  final result = await repository.getProject(id);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (project) => project,
  );
});
