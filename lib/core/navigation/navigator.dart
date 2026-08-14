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
        NotificationsPage,
        NotificationDetailPage,
        NotificationProductPage,
        NotificationItem,
        NotificationMockData,
        ProfileDetailsPage,
        ChangePasswordPage,
        FaqPage,
        FaqDetailPage,
        FaqItem,
        FaqMockData,
        NotificationPrefsPage,
        CommissionReportPage,
        CommissionHistoryPage,
        AuthOtpArgs,
        AuthOtpPurpose,
        AuthPasswordArgs,
        AuthPasswordMode,
        SplashPage,
        ThemePage,
        LifeInsurancePage,
        CustomerDetailPage,
        CustomerProfileDetailsPage,
        PolicyDetailsPage,
        CustomerMock,
        CustomerMockData,
        PolicyMock,
        LeadEntity,
        LeadDetailPage,
        CatalogProduct,
        ProductMockData,
        SavedQuote,
        EappDraft,
        ProductDetailPage,
        ProductQuotePage,
        ProductQuoteSavedPage,
        ProductQuotesPage,
        ProductTrackerPage,
        ProductTrackerDetailPage,
        ProductEappPage,
        ProductEappSuccessPage,
        ProductSearchPage,
        ProductComparePage,
        ProductSession;
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
          final customer = state.extra as CustomerMock? ??
              CustomerMockData.customers.first;
          return AppTransition.slide(
            key: state.pageKey,
            child: CustomerDetailPage(customer: customer),
          );
        },
      ),
      GoRoute(
        path: AppRoute.customerProfile,
        name: AppRoute.customerProfile,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final customer = state.extra as CustomerMock? ??
              CustomerMockData.customers.first;
          return AppTransition.slide(
            key: state.pageKey,
            child: CustomerProfileDetailsPage(customer: customer),
          );
        },
      ),
      GoRoute(
        path: AppRoute.policyDetail,
        name: AppRoute.policyDetail,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final policy = state.extra as PolicyMock? ??
              CustomerMockData.customers.first.policies.first;
          return AppTransition.slide(
            key: state.pageKey,
            child: PolicyDetailsPage(policy: policy),
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
      GoRoute(
        path: AppRoute.notifications,
        name: AppRoute.notifications,
        pageBuilder: (context, state) {
          return AppTransition.slide(
            key: state.pageKey,
            child: const NotificationsPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoute.notificationDetail,
        name: AppRoute.notificationDetail,
        pageBuilder: (context, state) {
          final item = state.extra as NotificationItem? ??
              NotificationMockData.items.first;
          return AppTransition.slide(
            key: state.pageKey,
            child: NotificationDetailPage(item: item),
          );
        },
      ),
      GoRoute(
        path: AppRoute.notificationProduct,
        name: AppRoute.notificationProduct,
        pageBuilder: (context, state) {
          final item = state.extra as NotificationItem?;
          return AppTransition.slide(
            key: state.pageKey,
            child: NotificationProductPage(item: item),
          );
        },
      ),
      GoRoute(
        path: AppRoute.profileDetails,
        name: AppRoute.profileDetails,
        pageBuilder: (context, state) {
          return AppTransition.slide(
            key: state.pageKey,
            child: const ProfileDetailsPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoute.profilePassword,
        name: AppRoute.profilePassword,
        pageBuilder: (context, state) {
          return AppTransition.slide(
            key: state.pageKey,
            child: const ChangePasswordPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoute.profileFaq,
        name: AppRoute.profileFaq,
        pageBuilder: (context, state) {
          return AppTransition.slide(
            key: state.pageKey,
            child: const FaqPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoute.profileFaqDetail,
        name: AppRoute.profileFaqDetail,
        pageBuilder: (context, state) {
          final item = state.extra as FaqItem? ?? FaqMockData.items.first;
          return AppTransition.slide(
            key: state.pageKey,
            child: FaqDetailPage(item: item),
          );
        },
      ),
      GoRoute(
        path: AppRoute.profileNotificationPrefs,
        name: AppRoute.profileNotificationPrefs,
        pageBuilder: (context, state) {
          return AppTransition.slide(
            key: state.pageKey,
            child: const NotificationPrefsPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoute.profileReport,
        name: AppRoute.profileReport,
        pageBuilder: (context, state) {
          return AppTransition.slide(
            key: state.pageKey,
            child: const CommissionReportPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoute.commissionHistory,
        name: AppRoute.commissionHistory,
        pageBuilder: (context, state) {
          return AppTransition.slide(
            key: state.pageKey,
            child: const CommissionHistoryPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoute.productDetail,
        name: AppRoute.productDetail,
        pageBuilder: (context, state) {
          final product = state.extra as CatalogProduct? ??
              ProductMockData.products.first;
          return AppTransition.slide(
            key: state.pageKey,
            child: ProductDetailPage(product: product),
          );
        },
      ),
      GoRoute(
        path: AppRoute.productQuote,
        name: AppRoute.productQuote,
        pageBuilder: (context, state) {
          final product = state.extra as CatalogProduct? ??
              ProductMockData.products.first;
          return AppTransition.slide(
            key: state.pageKey,
            child: ProductQuotePage(product: product),
          );
        },
      ),
      GoRoute(
        path: AppRoute.productQuoteSaved,
        name: AppRoute.productQuoteSaved,
        pageBuilder: (context, state) {
          final quote = state.extra as SavedQuote? ??
              (ProductSession.quotes.isNotEmpty
                  ? ProductSession.quotes.first
                  : null);
          return AppTransition.slide(
            key: state.pageKey,
            child: quote == null
                ? const ProductQuotesPage()
                : ProductQuoteSavedPage(quote: quote),
          );
        },
      ),
      GoRoute(
        path: AppRoute.productQuotes,
        name: AppRoute.productQuotes,
        pageBuilder: (context, state) {
          return AppTransition.slide(
            key: state.pageKey,
            child: const ProductQuotesPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoute.productTracker,
        name: AppRoute.productTracker,
        pageBuilder: (context, state) {
          return AppTransition.slide(
            key: state.pageKey,
            child: const ProductTrackerPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoute.productTrackerDetail,
        name: AppRoute.productTrackerDetail,
        pageBuilder: (context, state) {
          final draft = state.extra as EappDraft? ??
              (ProductSession.applications.isNotEmpty
                  ? ProductSession.applications.first
                  : null);
          return AppTransition.slide(
            key: state.pageKey,
            child: draft == null
                ? const ProductTrackerPage()
                : ProductTrackerDetailPage(draft: draft),
          );
        },
      ),
      GoRoute(
        path: AppRoute.productEapp,
        name: AppRoute.productEapp,
        pageBuilder: (context, state) {
          final draft = state.extra as EappDraft? ??
              (ProductSession.applications.isNotEmpty
                  ? ProductSession.applications.first
                  : null);
          return AppTransition.slide(
            key: state.pageKey,
            child: draft == null
                ? const ProductQuotesPage()
                : ProductEappPage(draft: draft),
          );
        },
      ),
      GoRoute(
        path: AppRoute.productEappSuccess,
        name: AppRoute.productEappSuccess,
        pageBuilder: (context, state) {
          final draft = state.extra as EappDraft? ??
              (ProductSession.applications.isNotEmpty
                  ? ProductSession.applications.first
                  : null);
          return AppTransition.slide(
            key: state.pageKey,
            child: draft == null
                ? const ProductTrackerPage()
                : ProductEappSuccessPage(draft: draft),
          );
        },
      ),
      GoRoute(
        path: AppRoute.productSearch,
        name: AppRoute.productSearch,
        pageBuilder: (context, state) {
          final q = state.extra as String? ?? '';
          return AppTransition.slide(
            key: state.pageKey,
            child: ProductSearchPage(initialQuery: q),
          );
        },
      ),
      GoRoute(
        path: AppRoute.productCompare,
        name: AppRoute.productCompare,
        pageBuilder: (context, state) {
          final pair = state.extra as List<CatalogProduct>?;
          final left = pair != null && pair.isNotEmpty
              ? pair[0]
              : ProductMockData.products.first;
          final right = pair != null && pair.length > 1
              ? pair[1]
              : ProductMockData.products[1];
          return AppTransition.slide(
            key: state.pageKey,
            child: ProductComparePage(left: left, right: right),
          );
        },
      ),
    ],
  );
}
