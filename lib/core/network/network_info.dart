import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_info.g.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Future<bool> get hasInternetConnection;
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
  Future<bool> get hasInternetConnection async {
    try {
      // First check if device has network connectivity
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        return false;
      }

      // Then check actual internet connectivity by pinging Google DNS
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      // If ping fails, try alternative method with socket connection
      try {
        final result = await Socket.connect('8.8.8.8', 53, timeout: const Duration(seconds: 3));
        result.destroy();
        return true;
      } catch (_) {
        return false;
      }
    }
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
