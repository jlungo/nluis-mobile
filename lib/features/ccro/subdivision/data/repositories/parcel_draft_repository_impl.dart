import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/parcel_draft.dart';
import '../../domain/repositories/parcel_draft_repository.dart';
import '../datasources/parcel_draft_local_datasource.dart';

/// Repository implementation for parcel draft operations
class ParcelDraftRepositoryImpl implements ParcelDraftRepository {
  final ParcelDraftLocalDataSource localDataSource;

  ParcelDraftRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, ParcelDraft>> createDraft(ParcelDraft draft) async {
    try {
      return await localDataSource.saveDraft(draft);
    } catch (e) {
      return Left(CacheFailure('Failed to create parcel draft: $e'));
    }
  }

  @override
  Future<Either<Failure, ParcelDraft?>> getDraft(String clientId) async {
    try {
      return await localDataSource.getDraft(clientId);
    } catch (e) {
      return Left(CacheFailure('Failed to get parcel draft: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ParcelDraft>>> getDraftsByApplication(
    String applicationId,
  ) async {
    try {
      return await localDataSource.getDraftsByApplication(applicationId);
    } catch (e) {
      return Left(CacheFailure('Failed to get parcel drafts: $e'));
    }
  }

  @override
  Future<Either<Failure, ParcelDraft>> updateDraft(ParcelDraft draft) async {
    try {
      return await localDataSource.updateDraft(draft);
    } catch (e) {
      return Left(CacheFailure('Failed to update parcel draft: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDraft(String clientId) async {
    try {
      return await localDataSource.deleteDraft(clientId);
    } catch (e) {
      return Left(CacheFailure('Failed to delete parcel draft: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDraftsByApplication(
    String applicationId,
  ) async {
    try {
      return await localDataSource.deleteDraftsByApplication(applicationId);
    } catch (e) {
      return Left(CacheFailure('Failed to delete parcel drafts: $e'));
    }
  }
}
