import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../local/database.dart';
import '../services/ccro_service.dart';

/// CCRO repository for managing land subdivision data
/// Handles zones, parties, applications, parcels, allocations, and photos
abstract class CcroRepository {
  // Zones
  Future<Either<Failure, List<Map<String, dynamic>>>> getSubdivisionZones({
    required int localityId,
  });
  Future<Either<Failure, Map<String, dynamic>>> getSubdivisionZone({
    required int zoneId,
    required int localityId,
  });
  Future<Either<Failure, List<SubdivisionZone>>> getLocalZonesByLocality(
    int localityId,
  );
  Future<Either<Failure, void>> saveZone(Map<String, dynamic> zoneData);

  // Parties
  Future<Either<Failure, Map<String, dynamic>>> createParty({
    required Map<String, dynamic> partyData,
  });
  Future<Either<Failure, Map<String, dynamic>>> getParty(int partyId);
  Future<Either<Failure, List<Party>>> getLocalParties();
  Future<Either<Failure, void>> saveLocalParty(Map<String, dynamic> partyData);

  // Subdivision Applications
  Future<Either<Failure, Map<String, dynamic>>> createSubdivisionApplication({
    required int zoneId,
    required int applicantId,
    String? notes,
  });
  Future<Either<Failure, Map<String, dynamic>>> getSubdivisionApplication(
    int applicationId,
  );
  Future<Either<Failure, List<SubdivisionApplication>>> getLocalApplications();
  Future<Either<Failure, void>> saveLocalApplication(
    Map<String, dynamic> applicationData,
  );
  Future<Either<Failure, void>> updateApplicationStep({
    required String applicationId,
    required int currentStep,
  });
  Future<Either<Failure, void>> updateApplicationStatus({
    required String applicationId,
    required String status,
  });
  Future<Either<Failure, SubdivisionApplication?>> getLocalApplicationById(
    String clientId,
  );

  // Parcels
  Future<Either<Failure, Map<String, dynamic>>> createParcel({
    required int subdivisionApplicationId,
    required int zoneId,
    required int localityId,
    int? hamletId,
    required Map<String, dynamic> geometry,
    required String north,
    required String south,
    required String east,
    required String west,
    int? occupancyType,
  });
  Future<Either<Failure, List<Map<String, dynamic>>>> getParcels({
    int? localityId,
    int? zoneId,
    int? applicationId,
    String? stage,
    bool? myParcels,
    bool? hasConflicts,
    bool? readyForCcro,
  });
  Future<Either<Failure, List<Parcel>>> getLocalParcels();
  Future<Either<Failure, void>> saveLocalParcel(
    Map<String, dynamic> parcelData,
  );
  Future<Either<Failure, List<Map<String, dynamic>>>> getParcelsGeoJson({
    required int localityId,
    required int zoneId,
  });

  // Allocations
  Future<Either<Failure, Map<String, dynamic>>> createAllocation({
    required int parcelId,
    required int partyId,
    required double proposedShare,
    String proposedRightType = 'customary',
    String? notes,
  });
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllocations({
    required int parcelId,
  });
  Future<Either<Failure, List<Allocation>>> getLocalAllocations();
  Future<Either<Failure, void>> saveLocalAllocation(
    Map<String, dynamic> allocationData,
  );

  // Photos
  Future<Either<Failure, List<Map<String, dynamic>>>> uploadParcelPhotos({
    required int parcelId,
    required List<String> photoPaths,
    String photoType = 'site',
    String? caption,
  });
  Future<Either<Failure, void>> saveLocalParcelPhoto(
    Map<String, dynamic> photoData,
  );
  Future<Either<Failure, List<ParcelPhoto>>> getLocalParcelPhotos();
  Future<Either<Failure, void>> deleteLocalParcelPhoto(String clientId);
}

class CcroRepositoryImpl implements CcroRepository {
  final CcroService _ccroService;
  final AppDatabase _database;
  final NetworkInfo _networkInfo;

  CcroRepositoryImpl({
    required CcroService ccroService,
    required AppDatabase database,
    required NetworkInfo networkInfo,
  }) : _ccroService = ccroService,
       _database = database,
       _networkInfo = networkInfo;

  // ============== ZONES ==============

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getSubdivisionZones({
    required int localityId,
  }) async {
    try {
      final isOnline = await _networkInfo.isConnected;
      if (!isOnline) {
        return const Left(
          NetworkFailure('Hakuna mtandao. Tafadhali washa mtandao.'),
        );
      }

      final zones = await _ccroService.getSubdivisionZones(
        localityId: localityId,
      );

      // print("=== ZONES Locality: $localityId");
      // print("=== ZONES RESPONSE: $zones");

      // Save to local database
      for (final zone in zones) {
        await saveZone(zone);
      }

      return Right(zones);
    } catch (e) {
      return Left(ServerFailure('Hitilafu ya kupakia maeneo: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getSubdivisionZone({
    required int zoneId,
    required int localityId,
  }) async {
    try {
      final isOnline = await _networkInfo.isConnected;
      if (!isOnline) {
        return const Left(
          NetworkFailure('Hakuna mtandao. Tafadhali washa mtandao.'),
        );
      }

      final zone = await _ccroService.getSubdivisionZone(
        zoneId: zoneId,
        localityId: localityId,
      );

      // Update local database with geometry
      await saveZone(zone);

      return Right(zone);
    } catch (e) {
      return Left(ServerFailure('Hitilafu ya kupakia eneo: $e'));
    }
  }

  @override
  Future<Either<Failure, List<SubdivisionZone>>> getLocalZonesByLocality(
    int localityId,
  ) async {
    try {
      final query = _database.select(_database.subdivisionZones)
        ..where((tbl) => tbl.localityId.equals(localityId));
      final zones = await query.get();
      return Right(zones);
    } catch (e) {
      return Left(CacheFailure('Hitilafu ya kusoma maeneo: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveZone(Map<String, dynamic> zoneData) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final id = zoneData['id'] as int;
      final zoneName = zoneData['zone_name'] as String;
      final localityId = zoneData['locality'] as int;
      final localityName = zoneData['locality_name'] as String? ?? '';
      final landUseName = zoneData['land_use_name'] as String?;
      final canBeSubdivided = zoneData['can_be_subdivided'] as bool? ?? true;
      final areaSqm = (zoneData['area_sqm'] as num?)?.toDouble();
      final geometry = zoneData['geom'];

      String? geomJson;
      if (geometry != null) {
        geomJson = jsonEncode(geometry);
      }

      await _database
          .into(_database.subdivisionZones)
          .insertOnConflictUpdate(
            SubdivisionZonesCompanion(
              id: drift.Value(id),
              zoneName: drift.Value(zoneName),
              localityId: drift.Value(localityId),
              localityName: drift.Value(localityName),
              landUseName: drift.Value(landUseName),
              canBeSubdivided: drift.Value(canBeSubdivided),
              areaSqm: drift.Value(areaSqm),
              geomJson: drift.Value(geomJson),
              downloadedAt: drift.Value(now),
              updatedAt: drift.Value(now),
            ),
          );

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Hitilafu ya kuhifadhi eneo: $e'));
    }
  }

  // ============== PARTIES ==============

  @override
  Future<Either<Failure, Map<String, dynamic>>> createParty({
    required Map<String, dynamic> partyData,
  }) async {
    try {
      final isOnline = await _networkInfo.isConnected;
      if (!isOnline) {
        // Save locally for later upload
        await saveLocalParty(partyData);
        return Right(partyData);
      }

      final party = await _ccroService.createParty(partyData: partyData);
      await saveLocalParty(party);
      return Right(party);
    } catch (e) {
      return Left(ServerFailure('Hitilafu ya kutengeneza mhusika: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getParty(int partyId) async {
    try {
      final isOnline = await _networkInfo.isConnected;
      if (!isOnline) {
        return const Left(
          NetworkFailure('Hakuna mtandao. Tafadhali washa mtandao.'),
        );
      }

      final party = await _ccroService.getParty(partyId);
      return Right(party);
    } catch (e) {
      return Left(ServerFailure('Hitilafu ya kupakia mhusika: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Party>>> getLocalParties() async {
    try {
      final parties = await _database.select(_database.parties).get();
      return Right(parties);
    } catch (e) {
      return Left(CacheFailure('Hitilafu ya kusoma wahusika: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveLocalParty(
    Map<String, dynamic> partyData,
  ) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final clientId =
          partyData['client_id'] as String? ??
          DateTime.now().millisecondsSinceEpoch.toString();

      await _database
          .into(_database.parties)
          .insertOnConflictUpdate(
            PartiesCompanion.insert(
              clientId: clientId,
              serverId: drift.Value(partyData['id'] as int?),
              partyType: partyData['party_type'] as String,
              firstName: drift.Value(partyData['first_name'] as String?),
              middleName: drift.Value(partyData['middle_name'] as String?),
              lastName: drift.Value(partyData['last_name'] as String?),
              nidaNumber: drift.Value(partyData['nida_number'] as String?),
              phone: drift.Value(partyData['phone_number'] as String?),
              email: drift.Value(partyData['email'] as String?),
              gender: drift.Value(partyData['gender'] as String?),
              uploaded: drift.Value(partyData.containsKey('id')),
              createdAt: now,
              updatedAt: now,
            ),
          );

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Hitilafu ya kuhifadhi mhusika: $e'));
    }
  }

  // ============== SUBDIVISION APPLICATIONS ==============

  @override
  Future<Either<Failure, Map<String, dynamic>>> createSubdivisionApplication({
    required int zoneId,
    required int applicantId,
    String? notes,
  }) async {
    try {
      final isOnline = await _networkInfo.isConnected;
      if (!isOnline) {
        return const Left(
          NetworkFailure('Hakuna mtandao. Tafadhali washa mtandao.'),
        );
      }

      final application = await _ccroService.createSubdivisionApplication(
        zoneId: zoneId,
        applicantId: applicantId,
        notes: notes,
      );

      await saveLocalApplication(application);
      return Right(application);
    } catch (e) {
      return Left(ServerFailure('Hitilafu ya kutengeneza ombi: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getSubdivisionApplication(
    int applicationId,
  ) async {
    try {
      final isOnline = await _networkInfo.isConnected;
      if (!isOnline) {
        return const Left(
          NetworkFailure('Hakuna mtandao. Tafadhali washa mtandao.'),
        );
      }

      final application = await _ccroService.getSubdivisionApplication(
        applicationId,
      );
      return Right(application);
    } catch (e) {
      return Left(ServerFailure('Hitilafu ya kupakia ombi: $e'));
    }
  }

  @override
  Future<Either<Failure, List<SubdivisionApplication>>>
  getLocalApplications() async {
    try {
      final applications =
          await _database.select(_database.subdivisionApplications).get();
      return Right(applications);
    } catch (e) {
      return Left(CacheFailure('Hitilafu ya kusoma maombi: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveLocalApplication(
    Map<String, dynamic> applicationData,
  ) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final String clientId =
          applicationData['client_id'] as String? ??
          DateTime.now().millisecondsSinceEpoch.toString();

      final String applicantId =
          applicationData['applicant'] != null
              ? applicationData['applicant'].toString()
              : '';

      await _database
          .into(_database.subdivisionApplications)
          .insertOnConflictUpdate(
            SubdivisionApplicationsCompanion.insert(
              clientId: clientId,
              serverId: drift.Value(applicationData['id'] as int?),
              zoneId: applicationData['zone_snapshot'] as int,
              localityId: applicationData['locality'] as int? ?? 0,
              applicantId: applicantId,
              status: drift.Value(
                applicationData['status'] as String? ?? 'draft',
              ),
              notes: drift.Value(applicationData['notes'] as String?),
              uploaded: drift.Value(applicationData.containsKey('id')),
              createdAt: now,
              updatedAt: now,
            ),
          );

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Hitilafu ya kuhifadhi ombi: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateApplicationStep({
    required String applicationId,
    required int currentStep,
  }) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      
      await (_database.update(_database.subdivisionApplications)
            ..where((t) => t.clientId.equals(applicationId)))
          .write(
        SubdivisionApplicationsCompanion(
          currentStep: drift.Value(currentStep),
          updatedAt: drift.Value(now),
        ),
      );

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Hitilafu ya kusasisha hatua: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateApplicationStatus({
    required String applicationId,
    required String status,
  }) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      
      await (_database.update(_database.subdivisionApplications)
            ..where((t) => t.clientId.equals(applicationId)))
          .write(
        SubdivisionApplicationsCompanion(
          status: drift.Value(status),
          updatedAt: drift.Value(now),
        ),
      );

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Hitilafu ya kusasisha hadhi: $e'));
    }
  }

  @override
  Future<Either<Failure, SubdivisionApplication?>> getLocalApplicationById(
    String clientId,
  ) async {
    try {
      final application = await (_database.select(_database.subdivisionApplications)
            ..where((t) => t.clientId.equals(clientId)))
          .getSingleOrNull();
      
      return Right(application);
    } catch (e) {
      return Left(CacheFailure('Hitilafu ya kusoma ombi: $e'));
    }
  }

  // ============== PARCELS ==============

  @override
  Future<Either<Failure, Map<String, dynamic>>> createParcel({
    required int subdivisionApplicationId,
    required int zoneId,
    required int localityId,
    int? hamletId,
    required Map<String, dynamic> geometry,
    required String north,
    required String south,
    required String east,
    required String west,
    int? occupancyType,
  }) async {
    try {
      final isOnline = await _networkInfo.isConnected;
      if (!isOnline) {
        return const Left(
          NetworkFailure('Hakuna mtandao. Tafadhali washa mtandao.'),
        );
      }

      final parcel = await _ccroService.createParcel(
        subdivisionApplicationId: subdivisionApplicationId,
        zoneId: zoneId,
        localityId: localityId,
        hamletId: hamletId,
        geometry: geometry,
        north: north,
        south: south,
        east: east,
        west: west,
        occupancyType: occupancyType,
      );

      await saveLocalParcel(parcel);
      return Right(parcel);
    } catch (e) {
      return Left(ServerFailure('Hitilafu ya kutengeneza kiwanja: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getParcels({
    int? localityId,
    int? zoneId,
    int? applicationId,
    String? stage,
    bool? myParcels,
    bool? hasConflicts,
    bool? readyForCcro,
  }) async {
    try {
      final isOnline = await _networkInfo.isConnected;
      if (!isOnline) {
        return const Left(
          NetworkFailure('Hakuna mtandao. Tafadhali washa mtandao.'),
        );
      }

      final parcels = await _ccroService.getParcels(
        localityId: localityId,
        zoneId: zoneId,
        applicationId: applicationId,
        stage: stage,
        myParcels: myParcels,
        hasConflicts: hasConflicts,
        readyForCcro: readyForCcro,
      );

      return Right(parcels);
    } catch (e) {
      return Left(ServerFailure('Hitilafu ya kupakia viwanja: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Parcel>>> getLocalParcels() async {
    try {
      final parcels = await _database.select(_database.parcels).get();
      return Right(parcels);
    } catch (e) {
      return Left(CacheFailure('Hitilafu ya kusoma viwanja: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveLocalParcel(
    Map<String, dynamic> parcelData,
  ) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final clientId =
          parcelData['client_id'] as String? ??
          DateTime.now().millisecondsSinceEpoch.toString();

      final geometry = parcelData['geom'];
      String? geomJson;
      if (geometry != null) {
        geomJson = jsonEncode(geometry);
      }

      await _database
          .into(_database.parcels)
          .insertOnConflictUpdate(
            ParcelsCompanion.insert(
              clientId: clientId,
              serverId: drift.Value(parcelData['id'] as int?),
              applicationId: parcelData['subdivision_application'].toString(),
              zoneId: parcelData['land_use_zone'] as int,
              localityId: parcelData['locality'] as int,
              hamletId: drift.Value(parcelData['hamlet'] as int?),
              geomJson: geomJson ?? '{}', // Default empty GeoJSON
              north: drift.Value(parcelData['north'] as String?),
              south: drift.Value(parcelData['south'] as String?),
              east: drift.Value(parcelData['east'] as String?),
              west: drift.Value(parcelData['west'] as String?),
              occupancyType: drift.Value(parcelData['occupancy_type'] as int?),
              stage: drift.Value(parcelData['stage'] as String? ?? 'draft'),
              uploaded: drift.Value(parcelData.containsKey('id')),
              createdAt: now,
              updatedAt: now,
            ),
          );

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Hitilafu ya kuhifadhi kiwanja: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getParcelsGeoJson({
    required int localityId,
    required int zoneId,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final parcels = await _ccroService.getParcelsGeoJson(
          localityId: localityId,
          zoneId: zoneId,
        );
        return Right(parcels);
      } on SocketException {
        return Left(NetworkFailure('Hakuna muunganisho wa mtandao'));
      } catch (e) {
        return Left(ServerFailure('Hitilafu ya kupata vipande: $e'));
      }
    } else {
      // Return empty list when offline - parcels are created locally
      return const Right([]);
    }
  }

  // ============== ALLOCATIONS ==============

  @override
  Future<Either<Failure, Map<String, dynamic>>> createAllocation({
    required int parcelId,
    required int partyId,
    required double proposedShare,
    String proposedRightType = 'customary',
    String? notes,
  }) async {
    try {
      final isOnline = await _networkInfo.isConnected;
      if (!isOnline) {
        return const Left(
          NetworkFailure('Hakuna mtandao. Tafadhali washa mtandao.'),
        );
      }

      final allocation = await _ccroService.createAllocation(
        parcelId: parcelId,
        partyId: partyId,
        proposedShare: proposedShare,
        proposedRightType: proposedRightType,
        notes: notes,
      );

      await saveLocalAllocation(allocation);
      return Right(allocation);
    } catch (e) {
      return Left(ServerFailure('Hitilafu ya kutengeneza mgawanyo: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllocations({
    required int parcelId,
  }) async {
    try {
      final isOnline = await _networkInfo.isConnected;
      if (!isOnline) {
        return const Left(
          NetworkFailure('Hakuna mtandao. Tafadhali washa mtandao.'),
        );
      }

      final allocations = await _ccroService.getAllocations(parcelId: parcelId);
      return Right(allocations);
    } catch (e) {
      return Left(ServerFailure('Hitilafu ya kupakia magawanyo: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Allocation>>> getLocalAllocations() async {
    try {
      final allocations = await _database.select(_database.allocations).get();
      return Right(allocations);
    } catch (e) {
      return Left(CacheFailure('Hitilafu ya kusoma magawanyo: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveLocalAllocation(
    Map<String, dynamic> allocationData,
  ) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final clientId =
          allocationData['client_id'] as String? ??
          DateTime.now().millisecondsSinceEpoch.toString();

      await _database
          .into(_database.allocations)
          .insertOnConflictUpdate(
            AllocationsCompanion.insert(
              clientId: clientId,
              serverId: drift.Value(allocationData['id'] as int?),
              parcelId: allocationData['parcel']?.toString() ?? allocationData['parcel_id']?.toString() ?? '',
              partyId: drift.Value(allocationData['party']?.toString()),
              partyName: drift.Value(allocationData['party_name'] as String?),
              phoneNumber: drift.Value(allocationData['phone_number'] as String?),
              nidaNumber: drift.Value(allocationData['nida_number'] as String?),
              proposedShare: allocationData['proposed_share'] as double,
              proposedRightType: drift.Value(
                allocationData['proposed_right_type'] as String? ?? 'customary',
              ),
              notes: drift.Value(allocationData['notes'] as String?),
              uploaded: drift.Value(allocationData.containsKey('id')),
              createdAt: now,
              updatedAt: now,
            ),
          );

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Hitilafu ya kuhifadhi mgawanyo: $e'));
    }
  }

  // ============== PHOTOS ==============

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> uploadParcelPhotos({
    required int parcelId,
    required List<String> photoPaths,
    String photoType = 'site',
    String? caption,
  }) async {
    try {
      final isOnline = await _networkInfo.isConnected;
      if (!isOnline) {
        return const Left(
          NetworkFailure('Hakuna mtandao. Tafadhali washa mtandao.'),
        );
      }

      final photos = photoPaths.map((path) => File(path)).toList();
      final result = await _ccroService.bulkUploadParcelPhotos(
        parcelId: parcelId,
        photos: photos,
        photoType: photoType,
        caption: caption,
      );

      return Right(result);
    } catch (e) {
      return Left(ServerFailure('Hitilafu ya kupakia picha: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveLocalParcelPhoto(
    Map<String, dynamic> photoData,
  ) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final companion = ParcelPhotosCompanion.insert(
        clientId: photoData['client_id'] as String,
        parcelId: photoData['parcel_id'] as String,
        photoPath: photoData['photo_path'] as String,
        photoType: drift.Value(photoData['photo_type'] as String? ?? 'other'),
        caption: drift.Value(photoData['description'] as String?),
        capturedAt: now,
        createdAt: now,
        updatedAt: now,
      );

      await _database.into(_database.parcelPhotos).insert(companion);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Hitilafu ya kuhifadhi picha: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ParcelPhoto>>> getLocalParcelPhotos() async {
    try {
      final photos = await _database.select(_database.parcelPhotos).get();
      return Right(photos);
    } catch (e) {
      return Left(CacheFailure('Hitilafu ya kusoma picha: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteLocalParcelPhoto(String clientId) async {
    try {
      await (_database.delete(_database.parcelPhotos)
            ..where((tbl) => tbl.clientId.equals(clientId)))
          .go();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Hitilafu ya kufuta picha: $e'));
    }
  }
}
