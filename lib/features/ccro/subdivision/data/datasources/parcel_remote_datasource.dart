import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../models/parcel_model.dart';
import '../services/parcel_api_service.dart';

/// Remote data source for parcel operations
abstract class ParcelRemoteDataSource {
  /// Create a new parcel on the server
  Future<Either<Failure, ParcelModel>> createParcel(ParcelModel parcel);

  /// Get parcels as GeoJSON for a locality or zone
  Future<Either<Failure, List<ParcelModel>>> getParcelsGeoJson({
    int? localityId,
    int? zoneId,
  });

  /// Update an existing parcel on the server
  Future<Either<Failure, ParcelModel>> updateParcel(ParcelModel parcel);

  /// Delete a parcel from the server
  Future<Either<Failure, void>> deleteParcel(int parcelId);

  /// Get a single parcel by server ID
  Future<Either<Failure, ParcelModel>> getParcel(int parcelId);

  /// Get parcels for a specific subdivision application
  Future<Either<Failure, List<ParcelModel>>> getParcelsByApplication(
    String applicationId,
  );
}

class ParcelRemoteDataSourceImpl implements ParcelRemoteDataSource {
  final ParcelApiService _apiService;

  ParcelRemoteDataSourceImpl({required ParcelApiService apiService})
      : _apiService = apiService;

  @override
  Future<Either<Failure, ParcelModel>> createParcel(ParcelModel parcel) async {
    try {
      final response = await _apiService.createParcel(parcel.toJson());

      if (response.statusCode == 201 || response.statusCode == 200) {
        final parcelModel = ParcelModel.fromJson(response.data);
        return Right(parcelModel);
      } else {
        return Left(ServerFailure('Failed to create parcel: ${response.statusMessage}'));
      }
    } catch (e) {
      return Left(ServerFailure('Error creating parcel: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ParcelModel>>> getParcelsGeoJson({
    int? localityId,
    int? zoneId,
  }) async {
    try {
      final response = await _apiService.getParcelsGeoJson(
        localityId: localityId,
        zoneId: zoneId,
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Handle GeoJSON FeatureCollection
        if (data is Map && data['type'] == 'FeatureCollection') {
          final features = data['features'] as List?;
          if (features == null) return const Right([]);

          final parcels = features
              .map((feature) {
                try {
                  // Extract properties and geometry
                  final properties = feature['properties'] as Map<String, dynamic>?;
                  final geometry = feature['geometry'] as Map<String, dynamic>?;

                  if (properties == null || geometry == null) return null;

                  // Combine properties and geometry
                  final parcelData = Map<String, dynamic>.from(properties);
                  parcelData['geom'] = geometry;

                  return ParcelModel.fromJson(parcelData);
                } catch (e) {
                  return null;
                }
              })
              .whereType<ParcelModel>()
              .toList();

          return Right(parcels);
        }

        return const Right([]);
      } else {
        return Left(ServerFailure('Failed to fetch parcels: ${response.statusMessage}'));
      }
    } catch (e) {
      return Left(ServerFailure('Error fetching parcels: $e'));
    }
  }

  @override
  Future<Either<Failure, ParcelModel>> updateParcel(ParcelModel parcel) async {
    try {
      if (parcel.serverId == null) {
        return Left(ServerFailure('Cannot update parcel without server ID'));
      }

      final response = await _apiService.updateParcel(
        parcel.serverId!,
        parcel.toJson(),
      );

      if (response.statusCode == 200) {
        final parcelModel = ParcelModel.fromJson(response.data);
        return Right(parcelModel);
      } else {
        return Left(ServerFailure('Failed to update parcel: ${response.statusMessage}'));
      }
    } catch (e) {
      return Left(ServerFailure('Error updating parcel: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteParcel(int parcelId) async {
    try {
      final response = await _apiService.deleteParcel(parcelId);

      if (response.statusCode == 204 || response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to delete parcel: ${response.statusMessage}'));
      }
    } catch (e) {
      return Left(ServerFailure('Error deleting parcel: $e'));
    }
  }

  @override
  Future<Either<Failure, ParcelModel>> getParcel(int parcelId) async {
    try {
      final response = await _apiService.getParcel(parcelId);

      if (response.statusCode == 200) {
        final parcelModel = ParcelModel.fromJson(response.data);
        return Right(parcelModel);
      } else {
        return Left(ServerFailure('Failed to fetch parcel: ${response.statusMessage}'));
      }
    } catch (e) {
      return Left(ServerFailure('Error fetching parcel: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ParcelModel>>> getParcelsByApplication(
    String applicationId,
  ) async {
    try {
      final response = await _apiService.getParcelsByApplication(applicationId);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is List) {
          final parcels = data
              .map((json) {
                try {
                  return ParcelModel.fromJson(json as Map<String, dynamic>);
                } catch (e) {
                  return null;
                }
              })
              .whereType<ParcelModel>()
              .toList();

          return Right(parcels);
        }

        return const Right([]);
      } else {
        return Left(ServerFailure('Failed to fetch parcels: ${response.statusMessage}'));
      }
    } catch (e) {
      return Left(ServerFailure('Error fetching parcels: $e'));
    }
  }
}
