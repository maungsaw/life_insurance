import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/core.dart' show AppRoute, PrototypeConfig;
import 'package:life_insurance/features/components/components.dart';

/// Splash — LoginRegister 1st screen · follows app / system theme (docs/39).
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(PrototypeConfig.splashDelay, () {
      if (!mounted) return;
      context.go(AppRoute.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Never hardcode black — respect ThemeMode.system / light / dark from AppearanceBloc.
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: const AppBrandMark.splash(),
        ),
      ),
    );
  }
}
