import 'package:flutter/material.dart';

/// Lets Home (and children) switch the shell bottom tab without go_router.
class MainTabScope extends InheritedWidget {
  const MainTabScope({
    super.key,
    required this.selectedIndex,
    required this.goToTab,
    required super.child,
  });

  final int selectedIndex;
  final ValueChanged<int> goToTab;

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
