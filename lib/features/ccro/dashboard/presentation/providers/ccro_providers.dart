import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/network/network_info.dart';
import '../../../../../data/local/draft_provider.dart';
import '../../../../../data/repositories/ccro_repository.dart';
import '../../../../../data/services/ccro_service.dart';
import '../../../../../shared/models/project.dart';
import '../../../../auth/presentation/providers/auth_providers.dart';
import '../../../../land_use/dashboard/presentation/providers/project_providers.dart';

final ccroServiceProvider = Provider<CcroService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return CcroService(dioClient: dioClient);
});

final ccroRepositoryProvider = Provider<CcroRepository>((ref) {
  final service = ref.watch(ccroServiceProvider);
  final database = ref.watch(databaseProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return CcroRepositoryImpl(
    ccroService: service,
    database: database,
    networkInfo: networkInfo,
  );
});

final ccroProjectsProvider = FutureProvider<List<Project>>((ref) async {
  final repository = ref.watch(projectRepositoryProvider);
  final result = await repository.getAssignedProjects();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (projects) => projects,
  );
});

final ccroProjectProvider = FutureProvider.family<Project, String>((
  ref,
  projectId,
) async {
  final repository = ref.watch(projectRepositoryProvider);
  final result = await repository.getProject(projectId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (project) => project,
  );
});

final subdivisionZonesProvider = FutureProvider.family<
  List<Map<String, dynamic>>,
  int
>((ref, localityId) async {
  final repository = ref.watch(ccroRepositoryProvider);

  // Try to fetch from API and save to DB automatically
  final result = await repository.getSubdivisionZones(localityId: localityId);

  return result.fold((failure) {
    // If online fetch fails, try local cache
    return repository
        .getLocalZonesByLocality(localityId)
        .then(
          (localResult) => localResult.fold(
            (localFailure) => throw Exception(failure.message),
            (zones) =>
                zones
                    .map(
                      (z) => {
                        'id': z.id,
                        'zone_name': z.zoneName,
                        'locality': z.localityId,
                        'locality_name': z.localityName,
                        'land_use_name': z.landUseName,
                        'can_be_subdivided': z.canBeSubdivided,
                        'area_sqm': z.areaSqm,
                      },
                    )
                    .toList(),
          ),
        );
  }, (zones) => zones);
});

final subdivisionZoneWithGeometryProvider =
    FutureProvider.family<Map<String, dynamic>, ({int zoneId, int localityId})>(
      (ref, params) async {
        final repository = ref.watch(ccroRepositoryProvider);
        final result = await repository.getSubdivisionZone(
          zoneId: params.zoneId,
          localityId: params.localityId,
        );

        return result.fold(
          (failure) => throw Exception(failure.message),
          (zone) => zone,
        );
      },
    );

final parcelsGeoJsonProvider = FutureProvider.family<
  List<Map<String, dynamic>>,
  ({int localityId, int zoneId})
>((ref, params) async {
  final repository = ref.watch(ccroRepositoryProvider);
  final result = await repository.getParcelsGeoJson(
    localityId: params.localityId,
    zoneId: params.zoneId,
  );

  return result.fold(
    (failure) => throw Exception(failure.message),
    (parcels) => parcels,
  );
});
