import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/error/error.dart' show ExceptionHandler;
import 'package:life_insurance/features/features.dart'
    show LanguagePage, LoginPage, SplashPage, ThemePage;
import 'package:life_insurance/features/widgets.dart';

import 'root.dart';
import 'name.dart';
import 'transition.dart';

class AppNavigator {
  static final GoRouter router = GoRouter(
    navigatorKey: AppRoot.rootKey,
    initialLocation: AppRoute.splash,
    debugLogDiagnostics: kDebugMode,
    //  refreshListenable: Injection.sl<AuthBloc>(),
    redirect: (context, state) async {
      debugPrint("state.matchedLocation  ${state.matchedLocation}");

      return null;
    },
    errorBuilder: (context, state) {
      final failure = ExceptionHandler.handle(state.error);
      return Scaffold(body: GlobalWidget.errorView(failure, context));
    },

    routes: <RouteBase>[
      GoRoute(
        path: AppRoute.splash,
        name: AppRoute.splash,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return AppTransition.slide(key: state.pageKey, child: SplashPage());
        },
      ),
      GoRoute(
        path: AppRoute.language,
        name: AppRoute.language,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return AppTransition.slide(
            key: state.pageKey,
            child: const LanguagePage(),
          );
        },
      ),
      GoRoute(
        path: AppRoute.theme,
        name: AppRoute.theme,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return AppTransition.fade(key: state.pageKey, child: ThemePage());
        },
      ),
      GoRoute(
        path: AppRoute.login,
        name: AppRoute.login,
        builder: (BuildContext context, GoRouterState state) {
          return LoginPage();
        },
      ),
    ],
  );
}
