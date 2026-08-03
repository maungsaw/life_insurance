import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AppearanceEvent extends Equatable {
  const AppearanceEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered when the app launches to load saved language preference
class LoadSavedAppearanceEvent extends AppearanceEvent {}

/// Triggered when user selects a new language
class ChangeLocaleEvent extends AppearanceEvent {
  final Locale locale;

  const ChangeLocaleEvent(this.locale);

  @override
  List<Object?> get props => [locale];
}

class ChangeThemeEvent extends AppearanceEvent {
  final ThemeMode themeMode;

  const ChangeThemeEvent(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}
