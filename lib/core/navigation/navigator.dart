import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_insurance/core/error/error.dart' show ExceptionHandler;
import 'package:life_insurance/features/features.dart'
    show
        LanguagePage,
        LoginPage,
        ForgotPasswordPage,
        OtpVerifyPage,
        CreatePasswordPage,
        RegisterPage,
        RegistrationPendingPage,
        AuthOtpArgs,
        AuthOtpPurpose,
        AuthPasswordArgs,
        AuthPasswordMode,
        SplashPage,
        ThemePage,
        LifeInsurancePage,
        CustomerDetailPage,
        CustomerEntity,
        LeadEntity,
        LeadDetailPage;
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
        path: AppRoute.customerDetail,
        name: AppRoute.customerDetail,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return AppTransition.fade(
            key: state.pageKey,
            child: CustomerDetailPage(customer: state.extra as CustomerEntity),
          );
        },
      ),
      GoRoute(
        path: AppRoute.leadDetail,
        name: AppRoute.leadDetail,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return AppTransition.fade(
            key: state.pageKey,
            child: LeadDetailPage(lead: state.extra as LeadEntity),
          );
        },
      ),
      GoRoute(
        path: AppRoute.home,
        name: AppRoute.home,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return AppTransition.slide(
            key: state.pageKey,
            child: const LifeInsurancePage(),
          );
        },
      ),
      GoRoute(
        path: AppRoute.login,
        name: AppRoute.login,
        builder: (_, _) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoute.forgotPassword,
        name: AppRoute.forgotPassword,
        pageBuilder: (context, state) {
          return AppTransition.slide(
            key: state.pageKey,
            child: const ForgotPasswordPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoute.otp,
        name: AppRoute.otp,
        pageBuilder: (context, state) {
          final args = state.extra as AuthOtpArgs? ??
              const AuthOtpArgs(
                mobile: '',
                purpose: AuthOtpPurpose.forgotPassword,
              );
          return AppTransition.slide(
            key: state.pageKey,
            child: OtpVerifyPage(args: args),
          );
        },
      ),
      GoRoute(
        path: AppRoute.createPassword,
        name: AppRoute.createPassword,
        pageBuilder: (context, state) {
          final args = state.extra as AuthPasswordArgs? ??
              const AuthPasswordArgs(
                mobile: '',
                mode: AuthPasswordMode.create,
              );
          return AppTransition.slide(
            key: state.pageKey,
            child: CreatePasswordPage(args: args),
          );
        },
      ),
      GoRoute(
        path: AppRoute.register,
        name: AppRoute.register,
        pageBuilder: (context, state) {
          return AppTransition.slide(
            key: state.pageKey,
            child: const RegisterPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoute.registrationPending,
        name: AppRoute.registrationPending,
        pageBuilder: (context, state) {
          return AppTransition.fade(
            key: state.pageKey,
            child: const RegistrationPendingPage(),
          );
        },
      ),
    ],
  );
}
