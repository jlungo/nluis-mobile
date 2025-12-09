import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/parcel.dart';

/// Repository interface for parcel operations
abstract class ParcelRepository {
  /// Create a new parcel
  Future<Either<Failure, Parcel>> createParcel(Parcel parcel);

  /// Get parcels for a subdivision application
  Future<Either<Failure, List<Parcel>>> getParcelsForSubdivision(
    String subdivisionApplicationId,
  );

  /// Get parcels as GeoJSON for a locality or zone
  Future<Either<Failure, List<Parcel>>> getParcelsGeoJson({
    int? localityId,
    int? zoneId,
  });

  /// Update an existing parcel
  Future<Either<Failure, Parcel>> updateParcel(Parcel parcel);

  /// Delete a parcel
  Future<Either<Failure, void>> deleteParcel(String clientId);

  /// Get a single parcel by client ID
  Future<Either<Failure, Parcel?>> getParcel(String clientId);

  /// Sync unsynced parcels with server
  Future<Either<Failure, int>> syncParcels();

  /// Get all unsynced parcels
  Future<Either<Failure, List<Parcel>>> getUnsyncedParcels();
}
