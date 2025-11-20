import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/local/draft_provider.dart';
import '../../../land_use/zoning/domain/entities/land_use.dart' as domain;
import '../../../land_use/zoning/presentation/providers/zoning_providers.dart';
import '../../data/services/setup_service.dart';

final setupServiceProvider = Provider<SetupService>((ref) {
  return SetupService(
    database: ref.watch(databaseProvider),
    landUseApi: ref.watch(landUseApiServiceProvider),
  );
});

final localLandUsesProvider = FutureProvider<List<domain.LandUse>>((ref) async {
  final service = ref.watch(setupServiceProvider);
  final result = await service.getLocalLandUses();
  return result.fold(
    (failure) => <domain.LandUse>[],
    (landUses) => landUses,
  );
});

final bufferDefaultsProvider = FutureProvider<Map<String, double>>((ref) async {
  final service = ref.watch(setupServiceProvider);
  return await service.getAllBufferDefaults();
});

class SetupStateNotifier extends StateNotifier<AsyncValue<void>> {
  final SetupService _setupService;

  SetupStateNotifier(this._setupService) : super(const AsyncValue.data(null));

  Future<void> fetchLandUses() async {
    state = const AsyncValue.loading();
    final result = await _setupService.fetchAndStoreLandUses();
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (_) => const AsyncValue.data(null),
    );
  }

  Future<void> updateBufferDefaults(Map<String, double> defaults) async {
    state = const AsyncValue.loading();
    final result = await _setupService.updateAllBufferDefaults(defaults);
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (_) => const AsyncValue.data(null),
    );
  }
}

final setupStateProvider = StateNotifierProvider<SetupStateNotifier, AsyncValue<void>>((ref) {
  return SetupStateNotifier(ref.watch(setupServiceProvider));
});
