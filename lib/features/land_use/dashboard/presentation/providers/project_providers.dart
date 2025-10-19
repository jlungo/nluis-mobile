import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/network/network_info.dart';
import '../../../../../data/local/draft_provider.dart';
import '../../../../../data/repositories/project_repository.dart';
import '../../../../../features/auth/presentation/providers/auth_providers.dart';
import '../../../../../shared/models/project.dart';

// Project Repository Provider
final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  final database = ref.watch(databaseProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  final SharedPreferences prefs = ref.watch(sharedPreferencesProvider);

  return ProjectRepositoryImpl(
    dioClient: dioClient,
    database: database,
    networkInfo: networkInfo,
    preferences: prefs,
  );
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

class SurveyDashboardStats {
  final int total;
  final int completed;
  final int drafts;
  final int uploaded;

  const SurveyDashboardStats({
    required this.total,
    required this.completed,
    required this.drafts,
    required this.uploaded,
  });
}

final surveyDashboardStatsProvider =
    StreamProvider<SurveyDashboardStats>((ref) {
  final database = ref.watch(databaseProvider);

  return database.select(database.surveyResponses).watch().map((responses) {
    if (responses.isEmpty) {
      return const SurveyDashboardStats(
        total: 0,
        completed: 0,
        drafts: 0,
        uploaded: 0,
      );
    }

    final Map<String, _SurveyAggregate> aggregates = {};

    for (final response in responses) {
      final aggregate = aggregates.putIfAbsent(
        response.surveyId,
        () => _SurveyAggregate(),
      );

      aggregate.isDraft = aggregate.isDraft && response.isDraft;
      aggregate.hasDirtyData = aggregate.hasDirtyData || response.dirty;
    }

    var drafts = 0;
    var completed = 0;
    var uploaded = 0;

    for (final aggregate in aggregates.values) {
      if (aggregate.isDraft) {
        drafts++;
      } else {
        completed++;
        if (!aggregate.hasDirtyData) {
          uploaded++;
        }
      }
    }

    return SurveyDashboardStats(
      total: aggregates.length,
      completed: completed,
      drafts: drafts,
      uploaded: uploaded,
    );
  });
});

class _SurveyAggregate {
  bool isDraft = true;
  bool hasDirtyData = false;
}
