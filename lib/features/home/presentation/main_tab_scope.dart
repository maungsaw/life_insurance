import 'package:flutter/material.dart';

/// Lets Home (and children) switch the shell bottom tab without go_router.
/// Nav slots are Home · Customer · Product · Profile; Leads/Tasks are off-nav (docs/44).
class MainTabScope extends InheritedWidget {
  const MainTabScope({
    super.key,
    required this.selectedIndex,
    required this.goToTab,
    required this.openLeads,
    required this.openTasks,
    required this.openFabSheet,
    required super.child,
  });

  /// Current IndexedStack index (may be off-nav Leads/Tasks).
  final int selectedIndex;
  final ValueChanged<int> goToTab;
  final VoidCallback openLeads;
  final VoidCallback openTasks;
  final VoidCallback openFabSheet;

  static MainTabScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MainTabScope>();
  }

  static MainTabScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(scope != null, 'MainTabScope not found');
    return scope!;
  }

  @override
  bool updateShouldNotify(MainTabScope oldWidget) =>
      selectedIndex != oldWidget.selectedIndex;
}
