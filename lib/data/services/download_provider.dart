import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../local/draft_provider.dart';
import 'project_download_service.dart';
import '../../core/network/dio_client.dart';

final downloadServiceProvider = Provider<ProjectDownloadService>((ref) {
  final database = ref.watch(databaseProvider);
  // final DioClient dioClient = ref.watch(dioClientProvider);
  // return ProjectDownloadService(database, dioClient);
  return ProjectDownloadService(database, DioClient());
});
