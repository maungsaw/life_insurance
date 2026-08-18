import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppTheme {
  static ThemeData get lightTheme => _build(
    brightness: Brightness.light,
    primary: AppColors.lightPrimary,
    background: AppColors.lightBackground,
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightTextPrimary,
    onSurfaceSecondary: AppColors.lightTextSecondary,
    hint: AppColors.lightTextHint,
    border: AppColors.lightBorder,
  );

  static ThemeData get darkTheme => _build(
    brightness: Brightness.dark,
    primary: AppColors.darkPrimary,
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkTextPrimary,
    onSurfaceSecondary: AppColors.darkTextSecondary,
    hint: AppColors.darkTextHint,
    border: AppColors.darkBorder,
  );

  static ThemeData _build({
    required Brightness brightness,
    required Color primary,
    required Color background,
    required Color surface,
    required Color onSurface,
    required Color onSurfaceSecondary,
    required Color hint,
    required Color border,
  }) {
    final isDark = brightness == Brightness.dark;
    final pressTint = primary.withValues(alpha: isDark ? 0.16 : 0.10);
    final softTint = primary.withValues(alpha: isDark ? 0.12 : 0.08);
    WidgetStateProperty<Color?> actionOverlay() =>
        WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) return pressTint;
          if (states.contains(WidgetState.focused)) return softTint;
          // Keep hover/long-press feel "motion first": no sticky tint slab.
          if (states.contains(WidgetState.hovered)) return Colors.transparent;
          return Colors.transparent;
        });
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      splashFactory: InkRipple.splashFactory,
      splashColor: pressTint,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: primary.withValues(alpha: 0.10),
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      dividerColor: border,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: AppColors.onPrimary,
        secondary: primary,
        onSecondary: AppColors.onPrimary,
        error: const Color(0xFFE11D48),
        onError: AppColors.onPrimary,
        surface: surface,
        onSurface: onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: onSurface),
        titleTextStyle: TextStyle(
          color: onSurface,
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(color: onSurface),
        titleMedium: TextStyle(color: onSurface),
        titleSmall: TextStyle(color: onSurface),
        bodyLarge: TextStyle(color: onSurface),
        bodyMedium: TextStyle(color: onSurface),
        bodySmall: TextStyle(color: onSurfaceSecondary),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: onSurface,
        textColor: onSurface,
        titleTextStyle: TextStyle(
          color: onSurface,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        subtitleTextStyle: TextStyle(color: onSurfaceSecondary, fontSize: 13),
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStateProperty.all(AppColors.onPrimary),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primary;
          return Colors.transparent;
        }),
        side: BorderSide(color: border, width: 1.5),
      ),
      radioTheme: RadioThemeData(fillColor: WidgetStateProperty.all(primary)),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.onPrimary;
          return surface;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primary;
          return onSurface.withValues(alpha: 0.3);
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(primary),
          foregroundColor: const WidgetStatePropertyAll(AppColors.onPrimary),
          elevation: const WidgetStatePropertyAll(0),
          overlayColor: actionOverlay(),
          splashFactory: InkRipple.splashFactory,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(primary),
          foregroundColor: const WidgetStatePropertyAll(AppColors.onPrimary),
          overlayColor: actionOverlay(),
          splashFactory: InkRipple.splashFactory,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(primary),
          overlayColor: actionOverlay(),
          splashFactory: InkRipple.splashFactory,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(primary),
          side: WidgetStatePropertyAll(BorderSide(color: primary)),
          overlayColor: actionOverlay(),
          splashFactory: InkRipple.splashFactory,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(onSurface),
          overlayColor: actionOverlay(),
          splashFactory: InkRipple.splashFactory,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        labelStyle: TextStyle(color: onSurfaceSecondary),
        hintStyle: TextStyle(color: hint),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primary, width: 2),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: isDark ? 0 : 1,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        titleTextStyle: TextStyle(
          color: onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
        contentTextStyle: TextStyle(color: onSurfaceSecondary, height: 1.4),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: surface,
      ),
      dividerTheme: DividerThemeData(color: border, space: 1, thickness: 1),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: onSurfaceSecondary,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primary.withValues(alpha: 0.2),
        iconTheme: WidgetStateProperty.all(IconThemeData(color: onSurface)),
        overlayColor: actionOverlay(),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.onPrimary,
      ),
      iconTheme: IconThemeData(color: onSurface),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? const Color(0xFF2A2A2A) : onSurface,
        contentTextStyle: TextStyle(color: isDark ? onSurface : surface),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        selectedColor: primary.withValues(alpha: 0.18),
        labelStyle: TextStyle(color: onSurface),
        side: BorderSide(color: border),
        surfaceTintColor: Colors.transparent,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: surface,
        textStyle: TextStyle(color: onSurface),
      ),
    );
  }
}
