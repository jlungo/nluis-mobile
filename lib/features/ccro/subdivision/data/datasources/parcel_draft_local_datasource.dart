import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../data/local/database.dart';
import '../../domain/entities/parcel_draft.dart';

/// Local datasource for parcel draft operations
class ParcelDraftLocalDataSource {
  final AppDatabase database;

  ParcelDraftLocalDataSource({required this.database});

  /// Save a parcel draft to local database
  Future<Either<Failure, ParcelDraft>> saveDraft(ParcelDraft draft) async {
    try {
      final coordsJson = jsonEncode(
        draft.coordinates.map((c) => [c.longitude, c.latitude]).toList(),
      );

      final companion = ParcelDraftsCompanion.insert(
        clientId: draft.clientId,
        applicationId: draft.applicationId,
        zoneId: draft.zoneId,
        localityId: draft.localityId,
        coordsJson: coordsJson,
        inputMethod: Value(draft.inputMethod),
        areaSqm: Value(draft.areaSqm),
        createdAt: draft.createdAt.millisecondsSinceEpoch,
        updatedAt: draft.updatedAt.millisecondsSinceEpoch,
      );

      await database.into(database.parcelDrafts).insert(
            companion,
            mode: InsertMode.insertOrReplace,
          );

      return Right(draft);
    } catch (e) {
      return Left(CacheFailure('Failed to save parcel draft: $e'));
    }
  }

  /// Get a parcel draft by client ID
  Future<Either<Failure, ParcelDraft?>> getDraft(String clientId) async {
    try {
      final draftData = await (database.select(database.parcelDrafts)
            ..where((tbl) => tbl.clientId.equals(clientId)))
          .getSingleOrNull();

      if (draftData == null) {
        return const Right(null);
      }

      final draft = _mapToDomain(draftData);
      return Right(draft);
    } catch (e) {
      return Left(CacheFailure('Failed to get parcel draft: $e'));
    }
  }

  /// Get all drafts for a subdivision application
  Future<Either<Failure, List<ParcelDraft>>> getDraftsByApplication(
    String applicationId,
  ) async {
    try {
      final draftsData = await (database.select(database.parcelDrafts)
            ..where((tbl) => tbl.applicationId.equals(applicationId)))
          .get();

      final drafts = draftsData.map(_mapToDomain).toList();
      return Right(drafts);
    } catch (e) {
      return Left(CacheFailure('Failed to get parcel drafts: $e'));
    }
  }

  /// Update an existing parcel draft
  Future<Either<Failure, ParcelDraft>> updateDraft(ParcelDraft draft) async {
    try {
      final coordsJson = jsonEncode(
        draft.coordinates.map((c) => [c.longitude, c.latitude]).toList(),
      );

      final companion = ParcelDraftsCompanion(
        clientId: Value(draft.clientId),
        applicationId: Value(draft.applicationId),
        zoneId: Value(draft.zoneId),
        localityId: Value(draft.localityId),
        coordsJson: Value(coordsJson),
        inputMethod: Value(draft.inputMethod),
        areaSqm: Value(draft.areaSqm),
        updatedAt: Value(draft.updatedAt.millisecondsSinceEpoch),
      );

      await database.update(database.parcelDrafts).replace(companion);

      return Right(draft);
    } catch (e) {
      return Left(CacheFailure('Failed to update parcel draft: $e'));
    }
  }

  /// Delete a parcel draft
  Future<Either<Failure, void>> deleteDraft(String clientId) async {
    try {
      await (database.delete(database.parcelDrafts)
            ..where((tbl) => tbl.clientId.equals(clientId)))
          .go();

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to delete parcel draft: $e'));
    }
  }

  /// Delete all drafts for a subdivision application
  Future<Either<Failure, void>> deleteDraftsByApplication(
    String applicationId,
  ) async {
    try {
      await (database.delete(database.parcelDrafts)
            ..where((tbl) => tbl.applicationId.equals(applicationId)))
          .go();

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to delete parcel drafts: $e'));
    }
  }

  /// Map database record to domain entity
  ParcelDraft _mapToDomain(ParcelDraftData draftData) {
    final coordsList = jsonDecode(draftData.coordsJson) as List;
    final coordinates = coordsList.map((coord) {
      final lng = (coord[0] as num).toDouble();
      final lat = (coord[1] as num).toDouble();
      return LatLng(lat, lng);
    }).toList();

    return ParcelDraft(
      clientId: draftData.clientId,
      applicationId: draftData.applicationId,
      zoneId: draftData.zoneId,
      localityId: draftData.localityId,
      coordinates: coordinates,
      inputMethod: draftData.inputMethod,
      areaSqm: draftData.areaSqm,
      createdAt: DateTime.fromMillisecondsSinceEpoch(draftData.createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(draftData.updatedAt),
    );
  }
}
