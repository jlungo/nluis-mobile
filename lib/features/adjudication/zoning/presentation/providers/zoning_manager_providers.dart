import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'zoning_providers.dart';
import '../../domain/entities/zoning_feature.dart';
import '../../domain/entities/locality_project.dart';
import '../../../../../data/local/draft_provider.dart';

/// Provider for draft features (not saved)
final draftFeaturesProvider = FutureProvider.autoDispose<List<ZoningFeature>>((ref) async {
  final repository = ref.watch(zoningRepositoryProvider);
  final result = await repository.getFeaturesByStatus(isDraft: true, uploaded: false);
  return result.fold((failure) => [], (features) => features);
});

/// Provider for saved features (not draft, not uploaded)
final savedFeaturesProvider = FutureProvider.autoDispose<List<ZoningFeature>>((ref) async {
  final repository = ref.watch(zoningRepositoryProvider);
  final result = await repository.getFeaturesByStatus(isDraft: false, uploaded: false);
  return result.fold((failure) => [], (features) => features);
});

/// Provider for uploaded features
final uploadedFeaturesProvider = FutureProvider.autoDispose<List<ZoningFeature>>((ref) async {
  final repository = ref.watch(zoningRepositoryProvider);
  final result = await repository.getFeaturesByStatus(uploaded: true);
  return result.fold((failure) => [], (features) => features);
});

/// Provider for locality projects with feature counts
final localityProjectsProvider = FutureProvider.autoDispose<List<LocalityProject>>((ref) async {
  final repository = ref.watch(zoningRepositoryProvider);
  final database = ref.watch(databaseProvider);
  
  // Get features grouped by locality
  final result = await repository.getFeaturesByLocality();
  return result.fold(
    (failure) => [],
    (featuresByLocality) async {
      final localityProjects = <LocalityProject>[];
      
      for (final entry in featuresByLocality.entries) {
        final localityId = entry.key;
        final features = entry.value;
        
        // Get projects for this locality
        final projectIds = features.map((f) => f.projectId).toSet();
        final projects = await (database.select(database.projects)
              ..where((tbl) => tbl.id.isIn(projectIds)))
            .get();
        
        // Use first project's name as locality identifier (projects are organized by locality)
        final localityName = projects.isNotEmpty 
            ? '${projects.first.name} Area'
            : 'Locality $localityId';
        
        // Count features by status
        final draftFeatures = features.where((f) => f.isDraft && !f.uploaded).toList();
        final savedFeatures = features.where((f) => !f.isDraft && !f.uploaded).toList();
        final uploadedFeatures = features.where((f) => f.uploaded).toList();
        
        // Get most recent timestamps
        DateTime? lastUpdatedAt;
        if (draftFeatures.isNotEmpty || savedFeatures.isNotEmpty) {
          final nonUploadedFeatures = [...draftFeatures, ...savedFeatures];
          lastUpdatedAt = nonUploadedFeatures
              .map((f) => f.updatedAt)
              .reduce((a, b) => a.isAfter(b) ? a : b);
        }
        
        DateTime? uploadedAt;
        if (uploadedFeatures.isNotEmpty && uploadedFeatures.first.uploadedAt != null) {
          uploadedAt = uploadedFeatures
              .map((f) => f.uploadedAt!)
              .reduce((a, b) => a.isAfter(b) ? a : b);
        }
        
        if (draftFeatures.length + savedFeatures.length + uploadedFeatures.length > 0) {
          localityProjects.add(LocalityProject(
            localityId: localityId,
            localityName: localityName,
            draftCount: draftFeatures.length,
            savedCount: savedFeatures.length,
            uploadedCount: uploadedFeatures.length,
            projectIds: projectIds.toList(),
            lastUpdatedAt: lastUpdatedAt,
            uploadedAt: uploadedAt,
          ));
        }
      }
      
      return localityProjects;
    },
  );
});

/// Provider for features by locality and status
final localityFeaturesByStatusProvider = FutureProvider.autoDispose
    .family<List<ZoningFeature>, (String localityId, String status)>((ref, params) async {
  final (localityId, status) = params;
  final repository = ref.watch(zoningRepositoryProvider);
  
  // Get features by status
  late Future<List<ZoningFeature>> featuresResult;
  
  switch (status) {
    case 'draft':
      final result = await repository.getFeaturesByStatus(isDraft: true, uploaded: false);
      featuresResult = Future.value(result.fold((failure) => [], (features) => features));
      break;
    case 'saved':
      final result = await repository.getFeaturesByStatus(isDraft: false, uploaded: false);
      featuresResult = Future.value(result.fold((failure) => [], (features) => features));
      break;
    case 'uploaded':
      final result = await repository.getFeaturesByStatus(uploaded: true);
      featuresResult = Future.value(result.fold((failure) => [], (features) => features));
      break;
    default:
      featuresResult = Future.value([]);
  }
  
  final allFeatures = await featuresResult;
  return allFeatures.where((f) => f.localityId == localityId).toList();
});
