import 'package:flutter/material.dart';

import 'service.dart';

class MaintenanceWrapper extends StatefulWidget {
  final Widget child;
  const MaintenanceWrapper({super.key, required this.child});

  @override
  State<MaintenanceWrapper> createState() => _MaintenanceWrapperState();
}

class _MaintenanceWrapperState extends State<MaintenanceWrapper>
    with WidgetsBindingObserver {
  late final MaintenanceNotifier _maintenanceNotifier;
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _maintenanceNotifier = MaintenanceNotifier()
      ..addListener(_handleMaintenanceStateChange)
      ..initialize();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _maintenanceNotifier.fetchAndCheckMaintenance();
    }
  }

  void _handleMaintenanceStateChange() {
    if (!mounted) return;

    final isMaintenance = _maintenanceNotifier.value;

    if (isMaintenance && !_isDialogShowing) {
      _showMaintenanceDialog();
    } else if (!isMaintenance && _isDialogShowing) {
      // Auto-dismiss dialog when maintenance mode is turned OFF remotely
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
    _maintenanceNotifier.removeListener(_handleMaintenanceStateChange);
    _maintenanceNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
