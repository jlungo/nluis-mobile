import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_info.g.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return connectivity.onConnectivityChanged.map((results) {
      return !results.contains(ConnectivityResult.none);
    });
  }
}

@riverpod
NetworkInfo networkInfo(Ref ref) {
  return NetworkInfoImpl(Connectivity());
}

@riverpod
Stream<bool> connectivityStream(Ref ref) {
  return ref.watch(networkInfoProvider).onConnectivityChanged;
}

final onlineStatusProvider = StreamProvider<bool>((ref) async* {
  final network = ref.watch(networkInfoProvider);
  final initial = await network.isConnected;
  yield initial;
  yield* network.onConnectivityChanged;
});
