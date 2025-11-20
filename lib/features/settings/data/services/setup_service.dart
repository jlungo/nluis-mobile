import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../core/error/failures.dart';
import '../../../../data/local/database.dart';
import '../../../land_use/zoning/domain/entities/land_use.dart' as domain;
import '../../../land_use/zoning/data/services/land_use_api_service.dart';

/// Service for managing app configurations and setup data
class SetupService {
  final AppDatabase _database;
  final LandUseApiService _landUseApi;

  SetupService({
    required AppDatabase database,
    required LandUseApiService landUseApi,
  })  : _database = database,
        _landUseApi = landUseApi;

  // ========== Land Uses ==========

  /// Fetch land uses from API and store locally
  Future<Either<Failure, List<domain.LandUse>>> fetchAndStoreLandUses() async {
    try {
      final landUses = await _landUseApi.fetchLandUses();
      
      // Store in local database
      final now = DateTime.now().millisecondsSinceEpoch;
      for (final landUse in landUses) {
        final companion = LandUsesCompanion.insert(
          id: drift.Value(landUse.id),
          name: landUse.name,
          description: landUse.description,
          color: landUse.color ?? '#808080',
          styleJson: drift.Value(
            landUse.style != null ? jsonEncode(landUse.style!.toJson()) : null,
          ),
          updatedAt: now,
        );

        await _database.into(_database.landUses).insertOnConflictUpdate(companion);
      }

      return Right(landUses);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Get all land uses from local database
  Future<Either<Failure, List<domain.LandUse>>> getLocalLandUses() async {
    try {
      final landUses = await _database.select(_database.landUses).get();
      
      final entities = landUses.map((db) => domain.LandUse(
        id: db.id,
        name: db.name,
        description: db.description,
        color: db.color,
        style: db.styleJson != null 
            ? domain.LandUseStyle.fromJson(jsonDecode(db.styleJson!) as Map<String, dynamic>)
            : null,
      )).toList();

      return Right(entities);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  /// Get a specific land use by ID
  Future<Either<Failure, domain.LandUse?>> getLandUseById(int id) async {
    try {
      final landUse = await (_database.select(_database.landUses)
        ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();

      if (landUse == null) {
        return const Right(null);
      }

      final entity = domain.LandUse(
        id: landUse.id,
        name: landUse.name,
        description: landUse.description,
        color: landUse.color,
        style: landUse.styleJson != null 
            ? domain.LandUseStyle.fromJson(jsonDecode(landUse.styleJson!) as Map<String, dynamic>)
            : null,
      );

      return Right(entity);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  // ========== App Settings (Buffer Defaults)

  /// Get buffer default for a specific feature type
  Future<double> getDefaultBuffer(String featureType) async {
    try {
      final key = 'buffer_default_$featureType';
      final setting = await (_database.select(_database.appSettings)
        ..where((tbl) => tbl.key.equals(key)))
        .getSingleOrNull();

      if (setting == null) {
        return 0.0;
      }

      return double.tryParse(setting.value) ?? 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  /// Set buffer default for a specific feature type
  Future<Either<Failure, bool>> setDefaultBuffer(String featureType, double buffer) async {
    try {
      final key = 'buffer_default_$featureType';
      final now = DateTime.now().millisecondsSinceEpoch;
      
      final companion = AppSettingsCompanion.insert(
        key: key,
        value: buffer.toString(),
        updatedAt: now,
      );

      await _database.into(_database.appSettings).insertOnConflictUpdate(companion);
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  /// Get all buffer defaults
  Future<Map<String, double>> getAllBufferDefaults() async {
    try {
      final settings = await (_database.select(_database.appSettings)
        ..where((tbl) => tbl.key.like('buffer_default_%')))
        .get();

      final Map<String, double> defaults = {
        'point': 0.0,
        'lineString': 0.0,
        'polygon': 0.0,
      };

      for (final setting in settings) {
        final featureType = setting.key.replaceFirst('buffer_default_', '');
        defaults[featureType] = double.tryParse(setting.value) ?? 0.0;
      }

      return defaults;
    } catch (e) {
      return {
        'point': 0.0,
        'lineString': 0.0,
        'polygon': 0.0,
      };
    }
  }

  /// Update all buffer defaults at once
  Future<Either<Failure, bool>> updateAllBufferDefaults(Map<String, double> defaults) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;

      for (final entry in defaults.entries) {
        final key = 'buffer_default_${entry.key}';
        final companion = AppSettingsCompanion.insert(
          key: key,
          value: entry.value.toString(),
          updatedAt: now,
        );

        await _database.into(_database.appSettings).insertOnConflictUpdate(companion);
      }

      return const Right(true);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
