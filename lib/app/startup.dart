import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:life_insurance/features/features.dart'
    show AppearanceBloc, AppearanceState;
import '../core/core.dart'
    show AppLocalizations, AppNavigator, AppTheme, MaintenanceWrapper;
import 'di/di.dart' show BlocDependencies;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaintenanceWrapper(
      child: BlocDependencies(
        child: BlocBuilder<AppearanceBloc, AppearanceState>(
          builder: (context, state) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'KBZ Life Insurance',
              routerConfig: AppNavigator.router,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: state.themeMode,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              locale: state.locale,
            );
          },
        ),
      ),
    );
  }
}
