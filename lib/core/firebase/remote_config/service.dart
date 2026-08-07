import 'dart:async';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:life_insurance/app/di/app_injection.dart' show AppInjection;
import 'package:life_insurance/core/core.dart'
    show NetworkConnectionService, NetworkStatus;
import 'const.dart' show RemoteConfigKeys;

class MaintenanceNotifier extends ValueNotifier<bool> {
  MaintenanceNotifier() : super(false);

  StreamSubscription<RemoteConfigUpdate>? _configSubscription;
  StreamSubscription<void>? _networkSubscription;

  /// Initializes Remote Config and sets up event listeners
  void initialize() {
    _configureRemoteConfig();

    // 1. Listen to Remote Config updates from Firebase
    _configSubscription = FirebaseRemoteConfig.instance.onConfigUpdated.listen((
      event,
    ) async {
      await fetchAndCheckMaintenance();
    });

    // 2. Listen to network restoration
    _networkSubscription = AppInjection.sl<NetworkConnectionService>()
        .onConnected
        .listen((_) {
          debugPrint(
            'MaintenanceNotifier: Network restored. Re-checking maintenance mode...',
          );
          fetchAndCheckMaintenance();
        });

    // 3. Initial check
    fetchAndCheckMaintenance();
  }

  Future<void> _configureRemoteConfig() async {
    try {
      await FirebaseRemoteConfig.instance.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero, // Use Duration.zero for testing
        ),
      );
    } catch (e) {
      debugPrint('RemoteConfig setup error: $e');
    }
  }

  /// Fetches latest Remote Config values if online, then updates maintenance state
  Future<void> fetchAndCheckMaintenance() async {
    final networkService = AppInjection.sl<NetworkConnectionService>();

    if (networkService.value == NetworkStatus.online) {
      try {
        await FirebaseRemoteConfig.instance.fetchAndActivate();
      } catch (e) {
        debugPrint('RemoteConfig fetch error (offline/timeout): $e');
      }
    }

    _checkMaintenance();
  }

  void _checkMaintenance() {
    final isMaintenance = FirebaseRemoteConfig.instance.getBool(
      RemoteConfigKeys.isMaintenanceMode,
    );

    // Notify listeners only when value changes
    if (value != isMaintenance) {
      value = isMaintenance;
    }
  }

  @override
  void dispose() {
    _configSubscription?.cancel();
    _networkSubscription?.cancel();
    super.dispose();
  }
}
