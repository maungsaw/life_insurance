import 'package:flutter/material.dart';

abstract class AppColors {
  // ==================== LIGHT THEME PALETTE ====================
  static const Color lightPrimary = Color(0xFFD30F1D);
  static const Color lightPrimaryContainer = Color(0xFFFFF0F1);
  static const Color lightPrimarySoftTint = Color(0xFFFDE8EA);

  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFEAEAEA);

  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF757575);
  static const Color lightTextHint = Color(0xFF9E9E9E);

  // ==================== DARK THEME PALETTE ====================
  // Slightly brighter/desaturated red for better contrast on dark surfaces
  static const Color darkPrimary = Color(0xFFFF4D4D);
  static const Color darkPrimaryContainer = Color(0xFF3B1114);
  static const Color darkPrimarySoftTint = Color(0xFF2C0A0C);

  static const Color darkBackground = Color(0xFF1E1E1E);
  static const Color darkSurface = Color(0xFF121212);

  static const Color darkBorder = Color(0xFF2C2C2C);

  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFAAAAAA);
  static const Color darkTextHint = Color(0xFF757575);

  // ==================== SHARED ACCENTS ====================
  static const Color gold = Color(0xFFFFB300);
  static const Color successGreen = Color(0xFF2E7D32);
  static const Color successGreenDark = Color(0xFF4CAF50);
}
