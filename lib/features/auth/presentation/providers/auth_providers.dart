import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

// Dio Client Provider
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(secureStorage: ref.watch(secureStorageProvider));
});

// Secure Storage Provider
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
});

// Shared Preferences Provider - Synchronous to avoid null issues
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

// Auth Data Sources
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AuthRemoteDataSourceImpl(dioClient.dio);
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl(
    secureStorage: ref.watch(secureStorageProvider),
    sharedPreferences: ref.watch(sharedPreferencesProvider),
  );
});

// Auth Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
  );
});

// Auth State Notifier
class AuthStateNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository repository;

  AuthStateNotifier(this.repository) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    final result = await repository.getCurrentUser();
    state = result.fold(
      (failure) => const AsyncValue.data(null),
      (user) => AsyncValue.data(user),
    );
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    final result = await repository.login(email, password);

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (user) => AsyncValue.data(user),
    );
  }

  Future<void> logout({bool clearData = false}) async {
    await repository.logout(clearData: clearData);
    state = const AsyncValue.data(null);
  }

  Future<void> setActiveModule(int moduleId) async {
    await repository.setActiveModule(moduleId);
  }

  Future<String?> getActiveModule() async {
    final result = await repository.getActiveModule();
    return result.fold((failure) => null, (module) => module);
  }
}

// Auth State Provider
final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AsyncValue<User?>>((ref) {
      return AuthStateNotifier(ref.watch(authRepositoryProvider));
    });

// Active Module Provider
final activeModuleProvider = FutureProvider<String?>((ref) async {
  final repository = ref.watch(authRepositoryProvider);
  final result = await repository.getActiveModule();
  return result.fold((failure) => null, (module) => module);
});
