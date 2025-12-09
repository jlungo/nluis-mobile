import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/network/network_info.dart';
import '../../../../../data/local/draft_provider.dart';
import '../../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/parcel_draft_local_datasource.dart';
import '../../data/datasources/parcel_local_datasource.dart';
import '../../data/datasources/parcel_remote_datasource.dart';
import '../../data/repositories/parcel_draft_repository_impl.dart';
import '../../data/repositories/parcel_repository_impl.dart';
import '../../data/services/parcel_api_service.dart';
import '../../domain/entities/parcel.dart';
import '../../domain/entities/parcel_draft.dart';
import '../../domain/repositories/parcel_draft_repository.dart';
import '../../domain/repositories/parcel_repository.dart';

// API Service Provider
final parcelApiServiceProvider = Provider<ParcelApiService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ParcelApiService(dioClient: dioClient);
});

// Data Source Providers
final parcelRemoteDataSourceProvider = Provider<ParcelRemoteDataSource>((ref) {
  final apiService = ref.watch(parcelApiServiceProvider);
  return ParcelRemoteDataSourceImpl(apiService: apiService);
});

final parcelLocalDataSourceProvider = Provider<ParcelLocalDataSource>((ref) {
  final database = ref.watch(databaseProvider);
  return ParcelLocalDataSourceImpl(database: database);
});

// Repository Provider
final parcelRepositoryProvider = Provider<ParcelRepository>((ref) {
  final remoteDataSource = ref.watch(parcelRemoteDataSourceProvider);
  final localDataSource = ref.watch(parcelLocalDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);

  return ParcelRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    networkInfo: networkInfo,
  );
});

// Parcels for Subdivision Application Provider
final parcelsForSubdivisionProvider = FutureProvider.family<List<Parcel>, String>((
  ref,
  subdivisionApplicationId,
) async {
  final repository = ref.watch(parcelRepositoryProvider);
  final result = await repository.getParcelsForSubdivision(subdivisionApplicationId);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (parcels) => parcels,
  );
});

// Single Parcel Provider
final parcelProvider = FutureProvider.family<Parcel?, String>((
  ref,
  clientId,
) async {
  final repository = ref.watch(parcelRepositoryProvider);
  final result = await repository.getParcel(clientId);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (parcel) => parcel,
  );
});

// Unsynced Parcels Provider
final unsyncedParcelsProvider = FutureProvider<List<Parcel>>((ref) async {
  final repository = ref.watch(parcelRepositoryProvider);
  final result = await repository.getUnsyncedParcels();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (parcels) => parcels,
  );
});

// Unsynced Parcels Count Provider
final unsyncedParcelsCountProvider = FutureProvider<int>((ref) async {
  final parcels = await ref.watch(unsyncedParcelsProvider.future);
  return parcels.length;
});

// Parcels GeoJSON Provider (for map display)
final parcelsGeoJsonProvider = FutureProvider.family<List<Parcel>, Map<String, int?>>((
  ref,
  params,
) async {
  final repository = ref.watch(parcelRepositoryProvider);
  final localityId = params['localityId'];
  final zoneId = params['zoneId'];

  final result = await repository.getParcelsGeoJson(
    localityId: localityId,
    zoneId: zoneId,
  );

  return result.fold(
    (failure) => throw Exception(failure.message),
    (parcels) => parcels,
  );
});

// ============================================================================
// PARCEL DRAFT PROVIDERS (Step 3 - Geometry Only)
// ============================================================================

// Parcel Draft Data Source Provider
final parcelDraftLocalDataSourceProvider = Provider<ParcelDraftLocalDataSource>((ref) {
  final database = ref.watch(databaseProvider);
  return ParcelDraftLocalDataSource(database: database);
});

// Parcel Draft Repository Provider
final parcelDraftRepositoryProvider = Provider<ParcelDraftRepository>((ref) {
  final localDataSource = ref.watch(parcelDraftLocalDataSourceProvider);
  return ParcelDraftRepositoryImpl(localDataSource: localDataSource);
});

// Parcel Drafts for Subdivision Application Provider
final parcelDraftsForApplicationProvider = FutureProvider.family<List<ParcelDraft>, String>((
  ref,
  applicationId,
) async {
  final repository = ref.watch(parcelDraftRepositoryProvider);
  final result = await repository.getDraftsByApplication(applicationId);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (drafts) => drafts,
  );
});

// Single Parcel Draft Provider
final parcelDraftProvider = FutureProvider.family<ParcelDraft?, String>((
  ref,
  clientId,
) async {
  final repository = ref.watch(parcelDraftRepositoryProvider);
  final result = await repository.getDraft(clientId);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (draft) => draft,
  );
});
