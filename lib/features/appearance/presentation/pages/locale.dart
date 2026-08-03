import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:life_insurance/core/core.dart'
    show AppLocalizations, LocalizationContext, LocalizationService;
import '../bloc/bloc.dart' show AppearanceBloc, ChangeLocaleEvent;

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.watch<AppearanceBloc>().state.locale;
    final languages = AppLocalizations.supportedLocales;

    return Scaffold(
      appBar: AppBar(title: Text(context.tr.language)),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemCount: languages.length,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          indent: 20,
          endIndent: 20,
          color: Colors.grey,
        ),
        itemBuilder: (context, index) {
          final locale = languages[index];

          // Reliable equality check based on language code
          final isSelected = locale.languageCode == currentLocale.languageCode;

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 4.0,
            ),
            title: Text(
              LocalizationService.getLanguageDisplayName(locale),
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),

            // Active vs Inactive Visual Indicator
            trailing: isSelected
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).primaryColor,
                  )
                : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
            onTap: () {
              if (!isSelected) {
                context.read<AppearanceBloc>().add(ChangeLocaleEvent(locale));
              }
            },
          );
        },
      ),
    );
  }
}
