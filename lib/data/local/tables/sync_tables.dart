import 'package:drift/drift.dart';

/// Sync logs for tracking data synchronization
class SyncLogs extends Table {
  TextColumn get id => text()();
  TextColumn get refType => text().named('ref_type')();
  TextColumn get refId => text().named('ref_id')();
  TextColumn get op => text()();
  TextColumn get status => text()();
  TextColumn get lastError => text().named('last_error').nullable()();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}
