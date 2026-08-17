import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:life_insurance/core/core.dart'
    show AppColors, ThemeService, ThemesConsts;
import '../bloc/bloc.dart' show AppearanceBloc, ChangeThemeEvent;

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentTheme = context.watch<AppearanceBloc>().state.themeMode;
    final themes = ThemesConsts.supportedThemes;

    return Scaffold(
      appBar: AppBar(title: const Text('Theme')),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemCount: themes.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          indent: 20,
          endIndent: 20,
          color: AppColors.border(context),
        ),
        itemBuilder: (context, index) {
          final theme = themes[index];
          final isSelected =
              theme.toLowerCase() ==
              ThemeService.changeToString(currentTheme).toLowerCase();
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 4.0,
            ),
            title: Text(
              theme,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? AppColors.lightPrimary
                    : AppColors.onSurface(context),
              ),
            ),
            trailing: isSelected
                ? const Icon(Icons.check_circle, color: AppColors.lightPrimary)
                : Icon(
                    Icons.radio_button_unchecked,
                    color: AppColors.hint(context),
                  ),
            onTap: () {
              if (!isSelected) {
                context.read<AppearanceBloc>().add(
                  ChangeThemeEvent(
                    ThemeService.changeToTheme(theme.toLowerCase()),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
