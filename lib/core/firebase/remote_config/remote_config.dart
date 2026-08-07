import 'dart:async';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:life_insurance/app/di/app_injection.dart' show AppInjection;

import 'package:life_insurance/core/core.dart'
    show NetworkConnectionService, NetworkStatus; // GetIt instance
import 'const.dart' show RemoteConfigKeys;

class MaintenanceWrapper extends StatefulWidget {
  final Widget child;
  const MaintenanceWrapper({super.key, required this.child});

  @override
  State<MaintenanceWrapper> createState() => _MaintenanceWrapperState();
}

class _MaintenanceWrapperState extends State<MaintenanceWrapper>
    with WidgetsBindingObserver {
  bool _isDialogShowing = false;
  late StreamSubscription<RemoteConfigUpdate> _configSubscription;
  StreamSubscription<void>? _networkSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _configureRemoteConfig();

    // 1. Listen to Remote Config updates from Firebase
    _configSubscription = FirebaseRemoteConfig.instance.onConfigUpdated.listen((
      event,
    ) async {
      await _fetchAndCheckMaintenance();
    });

    // 2. Listen to network restoration: re-fetch remote config when re-connected
    _networkSubscription = AppInjection.sl<NetworkConnectionService>()
        .onConnected
        .listen((_) {
          debugPrint(
            'MaintenanceWrapper: Network restored. Re-checking maintenance mode...',
          );
          _fetchAndCheckMaintenance();
        });

    // 3. Initial check on widget load
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _fetchAndCheckMaintenance(),
    );
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

  /// Fetches latest Remote Config values if online, then checks maintenance state
  Future<void> _fetchAndCheckMaintenance() async {
    final networkService = AppInjection.sl<NetworkConnectionService>();

    // Only attempt network fetch if online
    if (networkService.value == NetworkStatus.online) {
      try {
        await FirebaseRemoteConfig.instance.fetchAndActivate();
      } catch (e) {
        debugPrint('RemoteConfig fetch error (offline/timeout): $e');
      }
    }

    // Evaluate maintenance flag (cached or fresh)
    _checkMaintenance();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchAndCheckMaintenance();
    }
  }

  void _checkMaintenance() {
    if (!mounted) return;

    final isMaintenance = FirebaseRemoteConfig.instance.getBool(
      RemoteConfigKeys.isMaintenanceMode,
    );

    if (isMaintenance && !_isDialogShowing) {
      _showMaintenanceDialog();
    } else if (!isMaintenance && _isDialogShowing) {
      // Auto-dismiss dialog if maintenance mode is toggled OFF remotely
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      _isDialogShowing = false;
    }
  }

  void _showMaintenanceDialog() {
    _isDialogShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => const PopScope(
        canPop: false,
        child: AlertDialog(
          title: Text("System Maintenance"),
          content: Text(
            "We are currently undergoing system maintenance. Please try again later.",
          ),
        ),
      ),
    ).then((_) {
      _isDialogShowing = false;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _configSubscription.cancel();
    _networkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
