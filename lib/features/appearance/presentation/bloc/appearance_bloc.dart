import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:life_insurance/core/core.dart'
    show CacheConstants, LocalCacheService, ThemeService;

import 'appearance_event.dart';
import 'appearance_state.dart';

class AppearanceBloc extends Bloc<AppearanceEvent, AppearanceState> {
  final LocalCacheService localCacheService;
  AppearanceBloc({required this.localCacheService})
    : super(const AppearanceState(Locale('en'), ThemeMode.system)) {
    on<LoadSavedAppearanceEvent>(_onLoadSavedApperance);
    on<ChangeLocaleEvent>(_onChangeLocale);
    on<ChangeThemeEvent>(_onChangeTheme);
  }

  void _onLoadSavedApperance(
    LoadSavedAppearanceEvent event,
    Emitter<AppearanceState> emit,
  ) async {
    final languageCode = await localCacheService.read(
      CacheConstants.selectedLanguageCode,
    );
    final themeModeString = await localCacheService.read(
      CacheConstants.selectedThemeMode,
    );
    final themeMode = ThemeService.changeToTheme(themeModeString ?? 'system');

    emit(AppearanceState(Locale(languageCode ?? "en"), themeMode));
  }

  Future<void> _onChangeLocale(
    ChangeLocaleEvent event,
    Emitter<AppearanceState> emit,
  ) async {
    await localCacheService.write(
      key: CacheConstants.selectedLanguageCode,
      value: event.locale.languageCode,
    );
    emit(AppearanceState(event.locale, state.themeMode));
  }

  Future<void> _onChangeTheme(
    ChangeThemeEvent event,
    Emitter<AppearanceState> emit,
  ) async {
    final themeMode = ThemeService.changeToString(event.themeMode);
    await localCacheService.write(
      key: CacheConstants.selectedThemeMode,
      value: themeMode,
    );
    emit(AppearanceState(state.locale, event.themeMode));
  }
}
