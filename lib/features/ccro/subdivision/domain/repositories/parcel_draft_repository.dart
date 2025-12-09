import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/parcel_draft.dart';

/// Repository interface for parcel draft operations
abstract class ParcelDraftRepository {
  /// Create a new parcel draft
  Future<Either<Failure, ParcelDraft>> createDraft(ParcelDraft draft);

  /// Get a parcel draft by client ID
  Future<Either<Failure, ParcelDraft?>> getDraft(String clientId);

  /// Get all drafts for a subdivision application
  Future<Either<Failure, List<ParcelDraft>>> getDraftsByApplication(
    String applicationId,
  );

  /// Update an existing parcel draft
  Future<Either<Failure, ParcelDraft>> updateDraft(ParcelDraft draft);

  /// Delete a parcel draft
  Future<Either<Failure, void>> deleteDraft(String clientId);

  /// Delete all drafts for a subdivision application
  Future<Either<Failure, void>> deleteDraftsByApplication(
    String applicationId,
  );
}
