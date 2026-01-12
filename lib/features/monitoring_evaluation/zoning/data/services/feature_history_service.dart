import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';

import '../../../../../data/local/database.dart' as db;
import '../../domain/entities/zoning_feature.dart' as domain;

/// Service for tracking feature edit history
class FeatureHistoryService {
  final db.AppDatabase _database;

  FeatureHistoryService(this._database);

  /// Records a feature creation event
  Future<void> recordCreate({
    required domain.ZoningFeature feature,
    String? userId,
  }) async {
    final historyEntry = db.ZoningFeatureHistoryCompanion(
      id: drift.Value(const Uuid().v4()),
      featureId: drift.Value(feature.clientUuid),
      action: const drift.Value('create'),
      userId: drift.Value(userId),
      oldDataJson: const drift.Value(null),
      newDataJson: drift.Value(_serializeFeature(feature)),
      changesJson: const drift.Value(null),
      timestamp: drift.Value(DateTime.now().millisecondsSinceEpoch),
    );

    await _database.into(_database.zoningFeatureHistory).insert(historyEntry);
  }

  /// Records a feature update event with specific field changes
  Future<void> recordUpdate({
    required domain.ZoningFeature oldFeature,
    required domain.ZoningFeature newFeature,
    String? userId,
  }) async {
    final changes = _detectChanges(oldFeature, newFeature);

    final historyEntry = db.ZoningFeatureHistoryCompanion(
      id: drift.Value(const Uuid().v4()),
      featureId: drift.Value(newFeature.clientUuid),
      action: const drift.Value('update'),
      userId: drift.Value(userId),
      oldDataJson: drift.Value(_serializeFeature(oldFeature)),
      newDataJson: drift.Value(_serializeFeature(newFeature)),
      changesJson: drift.Value(jsonEncode(changes)),
      timestamp: drift.Value(DateTime.now().millisecondsSinceEpoch),
    );

    await _database.into(_database.zoningFeatureHistory).insert(historyEntry);
  }

  /// Records a coordinate edit event (specific action type)
  Future<void> recordCoordinateEdit({
    required domain.ZoningFeature oldFeature,
    required domain.ZoningFeature newFeature,
    String? userId,
  }) async {
    final changes = {
      'coordinates': {
        'old': oldFeature.coordinates.map((c) => [c.latitude, c.longitude]).toList(),
        'new': newFeature.coordinates.map((c) => [c.latitude, c.longitude]).toList(),
        'pointsChanged': oldFeature.coordinates.length != newFeature.coordinates.length 
            ? 'Count changed from ${oldFeature.coordinates.length} to ${newFeature.coordinates.length}'
            : 'Coordinates modified',
      },
    };

    final historyEntry = db.ZoningFeatureHistoryCompanion(
      id: drift.Value(const Uuid().v4()),
      featureId: drift.Value(newFeature.clientUuid),
      action: const drift.Value('coordinate_edit'),
      userId: drift.Value(userId),
      oldDataJson: drift.Value(_serializeFeature(oldFeature)),
      newDataJson: drift.Value(_serializeFeature(newFeature)),
      changesJson: drift.Value(jsonEncode(changes)),
      timestamp: drift.Value(DateTime.now().millisecondsSinceEpoch),
    );

    await _database.into(_database.zoningFeatureHistory).insert(historyEntry);
  }

  /// Records a feature deletion event
  Future<void> recordDelete({
    required domain.ZoningFeature feature,
    String? userId,
  }) async {
    final historyEntry = db.ZoningFeatureHistoryCompanion(
      id: drift.Value(const Uuid().v4()),
      featureId: drift.Value(feature.clientUuid),
      action: const drift.Value('delete'),
      userId: drift.Value(userId),
      oldDataJson: drift.Value(_serializeFeature(feature)),
      newDataJson: const drift.Value('null'),
      changesJson: const drift.Value(null),
      timestamp: drift.Value(DateTime.now().millisecondsSinceEpoch),
    );

    await _database.into(_database.zoningFeatureHistory).insert(historyEntry);
  }

  /// Retrieves edit history for a specific feature
  Future<List<db.ZoningFeatureHistoryData>> getFeatureHistory(String featureId) async {
    return await (_database.select(_database.zoningFeatureHistory)
          ..where((tbl) => tbl.featureId.equals(featureId))
          ..orderBy([
            (tbl) => drift.OrderingTerm(
                  expression: tbl.timestamp,
                  mode: drift.OrderingMode.desc,
                ),
          ]))
        .get();
  }

  /// Retrieves recent history across all features (for audit trail)
  Future<List<db.ZoningFeatureHistoryData>> getRecentHistory({
    int limit = 50,
  }) async {
    return await (_database.select(_database.zoningFeatureHistory)
          ..orderBy([
            (tbl) => drift.OrderingTerm(
                  expression: tbl.timestamp,
                  mode: drift.OrderingMode.desc,
                ),
          ])
          ..limit(limit))
        .get();
  }

  /// Clears old history entries (for database maintenance)
  Future<int> clearOldHistory({
    required Duration olderThan,
  }) async {
    final cutoffTimestamp = DateTime.now()
        .subtract(olderThan)
        .millisecondsSinceEpoch;

    return await (_database.delete(_database.zoningFeatureHistory)
          ..where((tbl) => tbl.timestamp.isSmallerThanValue(cutoffTimestamp)))
        .go();
  }

  /// Serializes a feature to JSON string
  String _serializeFeature(domain.ZoningFeature feature) {
    return jsonEncode({
      'clientUuid': feature.clientUuid,
      'serverId': feature.serverId,
      'projectId': feature.projectId,
      'localityId': feature.localityId,
      'landUseId': feature.landUseId,
      'featureType': feature.featureType.name,
      'coordinates': feature.coordinates.map((c) => [c.latitude, c.longitude]).toList(),
      'areaSqm': feature.area,
      'lengthM': feature.length,
      'plotId': feature.plotId,
      'plotName': feature.plotName,
      'notes': feature.notes,
      'isDraft': feature.isDraft,
      'isProposed': feature.isProposed,
      'status': feature.status,
      'uploaded': feature.uploaded,
      'uploadedAt': feature.uploadedAt?.millisecondsSinceEpoch,
    });
  }

  /// Detects what changed between two feature versions
  Map<String, dynamic> _detectChanges(
    domain.ZoningFeature oldFeature,
    domain.ZoningFeature newFeature,
  ) {
    final changes = <String, dynamic>{};

    if (oldFeature.plotId != newFeature.plotId) {
      changes['plotId'] = {'old': oldFeature.plotId, 'new': newFeature.plotId};
    }

    if (oldFeature.plotName != newFeature.plotName) {
      changes['plotName'] = {'old': oldFeature.plotName, 'new': newFeature.plotName};
    }

    if (oldFeature.landUseId != newFeature.landUseId) {
      changes['landUseId'] = {'old': oldFeature.landUseId, 'new': newFeature.landUseId};
    }

    if (oldFeature.notes != newFeature.notes) {
      changes['notes'] = {'old': oldFeature.notes, 'new': newFeature.notes};
    }

    if (oldFeature.isProposed != newFeature.isProposed) {
      changes['isProposed'] = {'old': oldFeature.isProposed, 'new': newFeature.isProposed};
    }

    if (oldFeature.isDraft != newFeature.isDraft) {
      changes['isDraft'] = {'old': oldFeature.isDraft, 'new': newFeature.isDraft};
    }

    if (oldFeature.status != newFeature.status) {
      changes['status'] = {'old': oldFeature.status, 'new': newFeature.status};
    }

    // Check coordinate changes
    if (oldFeature.coordinates.length != newFeature.coordinates.length ||
        !_coordinatesEqual(oldFeature.coordinates, newFeature.coordinates)) {
      changes['coordinates'] = {
        'old': oldFeature.coordinates.map((c) => [c.latitude, c.longitude]).toList(),
        'new': newFeature.coordinates.map((c) => [c.latitude, c.longitude]).toList(),
      };
    }

    return changes;
  }

  /// Checks if two coordinate lists are equal
  bool _coordinatesEqual(List<dynamic> coords1, List<dynamic> coords2) {
    if (coords1.length != coords2.length) return false;

    for (var i = 0; i < coords1.length; i++) {
      final c1 = coords1[i];
      final c2 = coords2[i];
      
      // Compare latitude and longitude with small tolerance
      if ((c1.latitude - c2.latitude).abs() > 0.0000001 ||
          (c1.longitude - c2.longitude).abs() > 0.0000001) {
        return false;
      }
    }

    return true;
  }
}
