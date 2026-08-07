import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show ValueNotifier, debugPrint;
import 'package:life_insurance/features/components/components.dart';
import '../navigation/navigation.dart' show AppRoot;
import 'enum.dart' show NetworkStatus;

class NetworkConnectionService extends ValueNotifier<NetworkStatus> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  // Broadcast stream controller to emit event streams to multiple listeners
  final StreamController<NetworkStatus> _statusController =
      StreamController<NetworkStatus>.broadcast();

  NetworkConnectionService() : super(NetworkStatus.offline) {
    _init();
  }

  void _init() {
    checkStatus();
    _subscription = _connectivity.onConnectivityChanged.listen(_updateStatus);
  }

  Stream<NetworkStatus> get onStatusChanged => _statusController.stream;
  Stream<void> get onConnected =>
      onStatusChanged.where((status) => status == NetworkStatus.online);
  Stream<void> get onDisconnected =>
      onStatusChanged.where((status) => status == NetworkStatus.offline);

  Future<NetworkStatus> checkStatus() async {
    final results = await _connectivity.checkConnectivity();
    _updateStatus(results);
    return value;
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final newStatus =
        (results.contains(ConnectivityResult.none) || results.isEmpty)
        ? NetworkStatus.offline
        : NetworkStatus.online;
    final rootKey = AppRoot.rootKey.currentContext;
    if (value != newStatus) {
      value = newStatus;
      _statusController.add(newStatus);
      if (rootKey != null) {
        AppSnackbar.showInfo(rootKey, newStatus.name.toUpperCase());
      }
      debugPrint('NetworkConnectionService: Status changed to $newStatus');
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _statusController.close();
    super.dispose();
  }
}
