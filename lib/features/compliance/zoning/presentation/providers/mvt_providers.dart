import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../data/local/draft_provider.dart';
import '../../data/services/mvt_parser_service.dart';
import '../../data/services/mvt_tile_service.dart'
    show MvtTileService, MvtTilesetInfo;
import './zoning_providers.dart';

/// Provider for MVT Parser Service
final mvtParserServiceProvider = Provider<MvtParserService>((ref) {
  return MvtParserService();
});

/// Provider for MVT Tile Service
final mvtTileServiceProvider = Provider<MvtTileService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  final database = ref.watch(databaseProvider);
  final parser = ref.watch(mvtParserServiceProvider);
  final repository = ref.watch(zoningRepositoryProvider);

  return MvtTileService(
    dioClient: dioClient,
    database: database,
    parser: parser,
    repository: repository,
  );
});

class MvtDownloadState {
  final bool isDownloading;
  final double progress;
  final String? error;
  final bool isComplete;

  const MvtDownloadState({
    this.isDownloading = false,
    this.progress = 0.0,
    this.error,
    this.isComplete = false,
  });

  MvtDownloadState copyWith({
    bool? isDownloading,
    double? progress,
    String? error,
    bool? isComplete,
  }) {
    return MvtDownloadState(
      isDownloading: isDownloading ?? this.isDownloading,
      progress: progress ?? this.progress,
      error: error ?? this.error,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}

class MvtDownloadNotifier extends StateNotifier<MvtDownloadState> {
  final MvtTileService _service;
  final String _localityId;

  MvtDownloadNotifier(this._service, this._localityId)
    : super(const MvtDownloadState());

  Future<void> downloadTiles({
    required String projectId,
    required LatLngBounds bounds,
    required int minZoom,
    required int maxZoom,
    bool isProposed = false,
  }) async {
    state = state.copyWith(
      isDownloading: true,
      progress: 0.0,
      error: null,
      isComplete: false,
    );

    try {
      final success = await _service.downloadTileset(
        projectId: projectId,
        localityId: _localityId,
        bounds: bounds,
        minZoom: minZoom,
        maxZoom: maxZoom,
        isProposed: isProposed,
        onProgress: (progress) {
          state = state.copyWith(progress: progress);
        },
      );

      if (success) {
        state = state.copyWith(
          isDownloading: false,
          isComplete: true,
          progress: 1.0,
        );
      } else {
        state = state.copyWith(isDownloading: false, error: 'Download failed');
      }
    } catch (e) {
      state = state.copyWith(isDownloading: false, error: e.toString());
    }
  }

  void reset() {
    state = const MvtDownloadState();
  }
}

final mvtDownloadStateProvider = StateNotifierProvider.autoDispose
    .family<MvtDownloadNotifier, MvtDownloadState, String>((ref, localityId) {
      final service = ref.watch(mvtTileServiceProvider);
      return MvtDownloadNotifier(service, localityId);
    });

final isMvtTilesetDownloadedProvider = FutureProvider.autoDispose
    .family<bool, String>((ref, localityId) async {
      final service = ref.watch(mvtTileServiceProvider);
      return await service.isTilesetDownloaded(localityId);
    });

final mvtTilesetInfoProvider = FutureProvider.autoDispose
    .family<MvtTilesetInfo?, String>((ref, localityId) async {
      final service = ref.watch(mvtTileServiceProvider);
      return await service.getTilesetInfo(localityId);
    });
