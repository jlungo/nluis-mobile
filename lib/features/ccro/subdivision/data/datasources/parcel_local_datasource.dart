import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../data/local/database.dart';
import '../../domain/entities/parcel.dart' as domain;
import '../models/parcel_model.dart';

/// Local data source for parcel caching and offline support
abstract class ParcelLocalDataSource {
  /// Cache a parcel locally
  Future<Either<Failure, void>> cacheParcel(ParcelModel parcel);

  /// Get cached parcels for a subdivision application
  Future<Either<Failure, List<ParcelModel>>> getCachedParcels(
    String subdivisionApplicationId,
  );

  /// Get a single cached parcel by client ID
  Future<Either<Failure, ParcelModel?>> getCachedParcel(String clientId);

  /// Update a cached parcel
  Future<Either<Failure, void>> updateCachedParcel(ParcelModel parcel);

  /// Delete a cached parcel
  Future<Either<Failure, void>> deleteCachedParcel(String clientId);

  /// Get all unsynced parcels (not uploaded)
  Future<Either<Failure, List<ParcelModel>>> getUnsyncedParcels();

  /// Mark parcel as uploaded
  Future<Either<Failure, void>> markParcelAsUploaded(
    String clientId,
    int serverId,
  );
}

class ParcelLocalDataSourceImpl implements ParcelLocalDataSource {
  final AppDatabase _database;

  ParcelLocalDataSourceImpl({required AppDatabase database})
      : _database = database;

  @override
  Future<Either<Failure, void>> cacheParcel(ParcelModel parcel) async {
    try {
      await _database.into(_database.parcels).insert(
            ParcelsCompanion(
              clientId: Value(parcel.clientId),
              serverId: Value(parcel.serverId),
              parcelNumber: Value(parcel.parcelNumber),
              applicationId: Value(parcel.applicationId),
              zoneId: Value(parcel.zoneId),
              localityId: Value(parcel.localityId),
              hamletId: Value(parcel.hamletId),
              geomJson: Value(jsonEncode(parcel.geometry)),
              geometryType: Value(parcel.geometryType),
              areaSqm: Value(parcel.areaSqm),
              north: Value(parcel.north),
              south: Value(parcel.south),
              east: Value(parcel.east),
              west: Value(parcel.west),
              occupancyType: Value(parcel.occupancyType),
              stage: Value(parcel.stage.name),
              hasConflicts: Value(parcel.hasConflicts),
              uploaded: Value(parcel.uploaded),
              uploadedAt: Value(parcel.uploadedAt?.millisecondsSinceEpoch),
              createdAt: Value(parcel.createdAt.millisecondsSinceEpoch),
              updatedAt: Value(parcel.updatedAt.millisecondsSinceEpoch),
            ),
            mode: InsertMode.insertOrReplace,
          );

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Error caching parcel: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ParcelModel>>> getCachedParcels(
    String subdivisionApplicationId,
  ) async {
    try {
      final parcels = await (_database.select(_database.parcels)
            ..where(
              (tbl) => tbl.applicationId.equals(subdivisionApplicationId),
            ))
          .get();

      final parcelModels = parcels.map(_mapToParcelModel).toList();
      return Right(parcelModels);
    } catch (e) {
      return Left(CacheFailure('Error fetching cached parcels: $e'));
    }
  }

  @override
  Future<Either<Failure, ParcelModel?>> getCachedParcel(String clientId) async {
    try {
      final parcel = await (_database.select(_database.parcels)
            ..where((tbl) => tbl.clientId.equals(clientId)))
          .getSingleOrNull();

      if (parcel == null) {
        return const Right(null);
      }

      return Right(_mapToParcelModel(parcel));
    } catch (e) {
      return Left(CacheFailure('Error fetching cached parcel: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateCachedParcel(ParcelModel parcel) async {
    try {
      await (_database.update(_database.parcels)
            ..where((tbl) => tbl.clientId.equals(parcel.clientId)))
          .write(
        ParcelsCompanion(
          serverId: Value(parcel.serverId),
          parcelNumber: Value(parcel.parcelNumber),
          applicationId: Value(parcel.applicationId),
          zoneId: Value(parcel.zoneId),
          localityId: Value(parcel.localityId),
          hamletId: Value(parcel.hamletId),
          geomJson: Value(jsonEncode(parcel.geometry)),
          geometryType: Value(parcel.geometryType),
          areaSqm: Value(parcel.areaSqm),
          north: Value(parcel.north),
          south: Value(parcel.south),
          east: Value(parcel.east),
          west: Value(parcel.west),
          occupancyType: Value(parcel.occupancyType),
          stage: Value(parcel.stage.name),
          hasConflicts: Value(parcel.hasConflicts),
          uploaded: Value(parcel.uploaded),
          uploadedAt: Value(parcel.uploadedAt?.millisecondsSinceEpoch),
          updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
        ),
      );

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Error updating cached parcel: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCachedParcel(String clientId) async {
    try {
      await (_database.delete(_database.parcels)
            ..where((tbl) => tbl.clientId.equals(clientId)))
          .go();

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Error deleting cached parcel: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ParcelModel>>> getUnsyncedParcels() async {
    try {
      final parcels = await (_database.select(_database.parcels)
            ..where((tbl) => tbl.uploaded.equals(false)))
          .get();

      final parcelModels = parcels.map(_mapToParcelModel).toList();
      return Right(parcelModels);
    } catch (e) {
      return Left(CacheFailure('Error fetching unsynced parcels: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> markParcelAsUploaded(
    String clientId,
    int serverId,
  ) async {
    try {
      await (_database.update(_database.parcels)
            ..where((tbl) => tbl.clientId.equals(clientId)))
          .write(
        ParcelsCompanion(
          serverId: Value(serverId),
          uploaded: const Value(true),
          uploadedAt: Value(DateTime.now().millisecondsSinceEpoch),
          updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
        ),
      );

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Error marking parcel as uploaded: $e'));
    }
  }

  /// Helper method to map database parcel to ParcelModel
  ParcelModel _mapToParcelModel(Parcel dbParcel) {
    // Parse geometry JSON
    Map<String, dynamic> geometry = {};
    try {
      if (dbParcel.geomJson != null) {
        geometry = jsonDecode(dbParcel.geomJson!) as Map<String, dynamic>;
      }
    } catch (e) {
      // Handle parse error
    }

    // Parse stage
    domain.ParcelStage stage = domain.ParcelStage.draft;
    if (dbParcel.stage.isNotEmpty) {
      final stageStr = dbParcel.stage.toLowerCase();
      if (stageStr == 'registered') {
        stage = domain.ParcelStage.registered;
      } else if (stageStr == 'printed') {
        stage = domain.ParcelStage.printed;
      }
    }

    return ParcelModel(
      clientId: dbParcel.clientId,
      serverId: dbParcel.serverId,
      parcelNumber: dbParcel.parcelNumber,
      applicationId: dbParcel.applicationId,
      zoneId: dbParcel.zoneId,
      localityId: dbParcel.localityId,
      hamletId: dbParcel.hamletId,
      geometry: geometry,
      geometryType: dbParcel.geometryType,
      areaSqm: dbParcel.areaSqm,
      north: dbParcel.north,
      south: dbParcel.south,
      east: dbParcel.east,
      west: dbParcel.west,
      occupancyType: dbParcel.occupancyType,
      stage: stage,
      hasConflicts: dbParcel.hasConflicts,
      uploaded: dbParcel.uploaded,
      uploadedAt: dbParcel.uploadedAt != null
          ? DateTime.fromMillisecondsSinceEpoch(dbParcel.uploadedAt!)
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(dbParcel.createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(dbParcel.updatedAt),
    );
  }
}
