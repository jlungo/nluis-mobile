import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/parcel.dart';
import '../../domain/repositories/parcel_repository.dart';
import '../datasources/parcel_local_datasource.dart';
import '../datasources/parcel_remote_datasource.dart';
import '../models/parcel_model.dart';

/// Repository implementation with offline-first approach
class ParcelRepositoryImpl implements ParcelRepository {
  final ParcelRemoteDataSource remoteDataSource;
  final ParcelLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ParcelRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Parcel>> createParcel(Parcel parcel) async {
    try {
      final parcelModel = ParcelModel.fromEntity(parcel);

      // Always cache locally first
      final cacheResult = await localDataSource.cacheParcel(parcelModel);
      if (cacheResult.isLeft()) {
        return Left((cacheResult as Left).value);
      }

      // Try to upload if online
      if (await networkInfo.isConnected) {
        final remoteResult = await remoteDataSource.createParcel(parcelModel);

        return remoteResult.fold(
          (failure) {
            // Failed to upload, but cached locally - return cached version
            return Right(parcelModel);
          },
          (uploadedParcel) async {
            // Mark as uploaded in local cache
            if (uploadedParcel.serverId != null) {
              await localDataSource.markParcelAsUploaded(
                parcelModel.clientId,
                uploadedParcel.serverId!,
              );
            }
            return Right(uploadedParcel);
          },
        );
      }

      // Offline - return cached version
      return Right(parcelModel);
    } catch (e) {
      return Left(CacheFailure('Error creating parcel: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Parcel>>> getParcelsForSubdivision(
    String subdivisionApplicationId,
  ) async {
    try {
      // Try to fetch from server if online
      if (await networkInfo.isConnected) {
        final remoteResult = await remoteDataSource.getParcelsByApplication(
          subdivisionApplicationId,
        );

        return remoteResult.fold(
          (failure) async {
            // Fallback to local cache
            return await localDataSource.getCachedParcels(
              subdivisionApplicationId,
            );
          },
          (remoteParcels) async {
            // Cache remote parcels locally
            for (final parcel in remoteParcels) {
              await localDataSource.cacheParcel(parcel);
            }
            return Right(remoteParcels);
          },
        );
      }

      // Offline - return cached parcels
      return await localDataSource.getCachedParcels(subdivisionApplicationId);
    } catch (e) {
      return Left(CacheFailure('Error fetching parcels: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Parcel>>> getParcelsGeoJson({
    int? localityId,
    int? zoneId,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final remoteResult = await remoteDataSource.getParcelsGeoJson(
          localityId: localityId,
          zoneId: zoneId,
        );

        return remoteResult.fold(
          (failure) => Left(failure),
          (remoteParcels) async {
            // Cache remote parcels locally
            for (final parcel in remoteParcels) {
              await localDataSource.cacheParcel(parcel);
            }
            return Right(remoteParcels);
          },
        );
      }

      // Offline - cannot fetch GeoJSON without network
      return Left(NetworkFailure('No internet connection'));
    } catch (e) {
      return Left(ServerFailure('Error fetching parcels GeoJSON: $e'));
    }
  }

  @override
  Future<Either<Failure, Parcel>> updateParcel(Parcel parcel) async {
    try {
      final parcelModel = ParcelModel.fromEntity(parcel);

      // Update local cache first
      final cacheResult = await localDataSource.updateCachedParcel(parcelModel);
      if (cacheResult.isLeft()) {
        return Left((cacheResult as Left).value);
      }

      // Try to update on server if online
      if (await networkInfo.isConnected) {
        final remoteResult = await remoteDataSource.updateParcel(parcelModel);

        return remoteResult.fold(
          (failure) {
            // Failed to update on server, but updated locally
            return Right(parcelModel);
          },
          (updatedParcel) async {
            // Update local cache with server response
            await localDataSource.updateCachedParcel(updatedParcel);
            return Right(updatedParcel);
          },
        );
      }

      // Offline - return locally updated version
      return Right(parcelModel);
    } catch (e) {
      return Left(CacheFailure('Error updating parcel: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteParcel(String clientId) async {
    try {
      // Get parcel to check if it has server ID
      final parcelResult = await localDataSource.getCachedParcel(clientId);

      return parcelResult.fold(
        (failure) => Left(failure),
        (parcel) async {
          if (parcel == null) {
            return Left(CacheFailure('Parcel not found'));
          }

          // If has server ID and online, delete from server
          if (parcel.serverId != null && await networkInfo.isConnected) {
            final remoteResult = await remoteDataSource.deleteParcel(
              parcel.serverId!,
            );

            // Delete from local cache regardless of server result
            await localDataSource.deleteCachedParcel(clientId);

            return remoteResult;
          }

          // Delete from local cache only
          return await localDataSource.deleteCachedParcel(clientId);
        },
      );
    } catch (e) {
      return Left(CacheFailure('Error deleting parcel: $e'));
    }
  }

  @override
  Future<Either<Failure, Parcel?>> getParcel(String clientId) async {
    try {
      // Always get from local cache for speed
      return await localDataSource.getCachedParcel(clientId);
    } catch (e) {
      return Left(CacheFailure('Error fetching parcel: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> syncParcels() async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure('No internet connection'));
      }

      // Get all unsynced parcels
      final unsyncedResult = await localDataSource.getUnsyncedParcels();

      return unsyncedResult.fold(
        (failure) => Left(failure),
        (unsyncedParcels) async {
          int syncedCount = 0;

          for (final parcel in unsyncedParcels) {
            final parcelModel = ParcelModel.fromEntity(parcel);
            final remoteResult = await remoteDataSource.createParcel(parcelModel);

            remoteResult.fold(
              (failure) {
                // Failed to sync this parcel, continue with others
              },
              (uploadedParcel) async {
                // Mark as uploaded
                if (uploadedParcel.serverId != null) {
                  await localDataSource.markParcelAsUploaded(
                    parcelModel.clientId,
                    uploadedParcel.serverId!,
                  );
                  syncedCount++;
                }
              },
            );
          }

          return Right(syncedCount);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Error syncing parcels: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Parcel>>> getUnsyncedParcels() async {
    try {
      return await localDataSource.getUnsyncedParcels();
    } catch (e) {
      return Left(CacheFailure('Error fetching unsynced parcels: $e'));
    }
  }
}
