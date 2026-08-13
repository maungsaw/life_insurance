import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
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
    if (Firebase.apps.isEmpty) {
      debugPrint('MaintenanceNotifier: Firebase not ready — skip Remote Config');
      return;
    }

    _configureRemoteConfig();

    try {
      _configSubscription = FirebaseRemoteConfig.instance.onConfigUpdated.listen((
        event,
      ) async {
        await fetchAndCheckMaintenance();
      });
    } catch (e) {
      debugPrint('MaintenanceNotifier: onConfigUpdated skipped: $e');
    }

    try {
      _networkSubscription = AppInjection.sl<NetworkConnectionService>()
          .onConnected
          .listen((_) {
            debugPrint(
              'MaintenanceNotifier: Network restored. Re-checking maintenance mode...',
            );
            fetchAndCheckMaintenance();
          });
    } catch (e) {
      debugPrint('MaintenanceNotifier: network listen skipped: $e');
    }

    fetchAndCheckMaintenance();
  }

  Future<void> _configureRemoteConfig() async {
    try {
      await FirebaseRemoteConfig.instance.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero,
        ),
      );
    } catch (e) {
      debugPrint('RemoteConfig setup error: $e');
    }
  }

  Future<void> fetchAndCheckMaintenance() async {
    if (Firebase.apps.isEmpty) return;

    try {
      final networkService = AppInjection.sl<NetworkConnectionService>();
      if (networkService.value == NetworkStatus.online) {
        try {
          await FirebaseRemoteConfig.instance
              .fetchAndActivate()
              .timeout(const Duration(seconds: 8));
        } catch (e) {
          debugPrint('RemoteConfig fetch error (offline/timeout): $e');
        }
      }
      _checkMaintenance();
    } catch (e) {
      debugPrint('MaintenanceNotifier fetch skipped: $e');
    }
  }

  void _checkMaintenance() {
    if (Firebase.apps.isEmpty) return;
    try {
      final isMaintenance = FirebaseRemoteConfig.instance.getBool(
        RemoteConfigKeys.isMaintenanceMode,
      );
      if (value != isMaintenance) {
        value = isMaintenance;
      }
    } catch (e) {
      debugPrint('MaintenanceNotifier check skipped: $e');
    }
  }

  @override
  void dispose() {
    _configSubscription?.cancel();
    _networkSubscription?.cancel();
    super.dispose();
  }
}
