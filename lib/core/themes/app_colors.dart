import 'package:flutter/material.dart';

abstract class AppColors {
  // ==================== LIGHT THEME PALETTE ====================
  static const Color lightPrimary = Color(0xFF00adee);
  static const Color lightPrimaryContainer = Color(0xFFFFF0F1);
  static const Color lightPrimarySoftTint = Color(0xFFFDE8EA);

  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFEAEAEA);

  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF757575);
  static const Color lightTextHint = Color(0xFF9E9E9E);

  // ==================== DARK THEME PALETTE ====================
  /// Same brand cyan as light so CTAs stay visible on charcoal.
  static const Color darkPrimary = Color(0xFF00adee);
  static const Color darkPrimaryContainer = Color(0xFF0A3A4D);
  static const Color darkPrimarySoftTint = Color(0xFF0D2A38);

  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkBorder = Color(0xFF3A3A3A);

  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkTextHint = Color(0xFF8E8E8E);

  // ==================== SHARED ACCENTS ====================
  static const Color gold = Color(0xFFFFB300);
  static const Color successGreen = Color(0xFF2E7D32);
  static const Color successGreenDark = Color(0xFF4CAF50);
  static const Color onPrimary = Color(0xFFFFFFFF);

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color primary(BuildContext context) =>
      isDark(context) ? darkPrimary : lightPrimary;

  static Color primaryContainer(BuildContext context) =>
      isDark(context) ? darkPrimaryContainer : lightPrimaryContainer;

  static Color primarySoftTint(BuildContext context) =>
      isDark(context) ? darkPrimarySoftTint : lightPrimarySoftTint;

  static Color background(BuildContext context) =>
      isDark(context) ? darkBackground : lightBackground;

  static Color surface(BuildContext context) =>
      isDark(context) ? darkSurface : lightSurface;

  static Color border(BuildContext context) =>
      isDark(context) ? darkBorder : lightBorder;

  static Color onSurface(BuildContext context) =>
      isDark(context) ? darkTextPrimary : lightTextPrimary;

  static Color onSurfaceSecondary(BuildContext context) =>
      isDark(context) ? darkTextSecondary : lightTextSecondary;

  static Color hint(BuildContext context) =>
      isDark(context) ? darkTextHint : lightTextHint;

  static Color success(BuildContext context) =>
      isDark(context) ? successGreenDark : successGreen;

  /// Chip tracks, tab wells, inset fills.
  static Color mutedFill(BuildContext context) =>
      isDark(context) ? const Color(0xFF2A2A2A) : const Color(0xFFF3F4F6);

  /// Bottom-nav unlabeled tabs (`44` near-black on Light · readable grey on Dark).
  static Color navInactive(BuildContext context) =>
      isDark(context) ? const Color(0xFFC8C8C8) : const Color(0xFF2D2D2D);

  /// Floating pill / FAB disc — lifted above the page in Dark (`84`).
  static Color navPill(BuildContext context) =>
      isDark(context) ? mutedFill(context) : surface(context);
}
