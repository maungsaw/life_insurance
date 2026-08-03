import 'package:flutter/material.dart';

abstract class ThemeService {
  static ThemeMode changeToTheme(String mode) {
    final themeMode = mode == 'dark'
        ? ThemeMode.dark
        : mode == 'system'
        ? ThemeMode.system
        : ThemeMode.light;
    return themeMode;
  }

  static String changeToString(ThemeMode mode) {
    final themeMode = mode.isDark
        ? 'dark'
        : mode.isSystem
        ? 'system'
        : 'light';
    return themeMode;
  }

  static List<String> supportedThemes() {
    return ['System', 'Dark', 'Light'];
  }
}
