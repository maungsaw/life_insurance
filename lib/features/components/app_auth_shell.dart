import 'package:flutter/material.dart';

/// Consistent SafeArea + scroll padding for auth screens.
class AppAuthShell extends StatelessWidget {
  const AppAuthShell({
    super.key,
    required this.child,
    this.horizontal = 24,
    this.vertical = 16,
  });

  final Widget child;
  final double horizontal;
  final double vertical;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
        child: child,
      ),
    );
  }
}
