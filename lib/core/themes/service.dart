import 'package:flutter/material.dart' show ThemeMode;

import 'const.dart';

abstract class ThemeService {
  static ThemeMode changeToTheme(String mode) {
    final themeMode = mode == ThemesConsts.darkTheme
        ? ThemeMode.dark
        : mode == ThemesConsts.systemTheme
        ? ThemeMode.system
        : ThemeMode.light;
    return themeMode;
  }

  static String changeToString(ThemeMode mode) {
    final themeMode = mode.isDark
        ? ThemesConsts.darkTheme
        : mode.isSystem
        ? ThemesConsts.systemTheme
        : ThemesConsts.lightTheme;
    return themeMode;
  }
}
