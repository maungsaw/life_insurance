abstract class ThemesConsts {
  static const String lightTheme = 'light';
  static const String darkTheme = 'dark';
  static const String systemTheme = 'system';
  static const String defaultTheme = systemTheme;
  static const String lightThemeName = 'Light';
  static const String darkThemeName = 'Dark';
  static const String systemThemeName = 'System';
  static const String defaultThemeName = systemThemeName;
  static List<String> supportedThemes = [
    ThemesConsts.systemThemeName,
    ThemesConsts.darkThemeName,
    ThemesConsts.lightThemeName,
  ];
}
