import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../local/draft_provider.dart';
import 'project_download_service.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

final downloadServiceProvider = Provider<ProjectDownloadService>((ref) {
  final database = ref.watch(databaseProvider);
  final dio = ref.watch(dioProvider);
  return ProjectDownloadService(database, dio);
});
