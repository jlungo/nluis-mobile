import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database.dart';
import 'draft_service.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final draftServiceProvider = Provider<DraftService>((ref) {
  final database = ref.watch(databaseProvider);
  return DraftService(database);
});
