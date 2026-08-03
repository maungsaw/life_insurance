import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppearanceState extends Equatable {
  final Locale locale;
  final ThemeMode themeMode;

  const AppearanceState(this.locale, this.themeMode);

  @override
  List<Object?> get props => [locale, themeMode];
}
