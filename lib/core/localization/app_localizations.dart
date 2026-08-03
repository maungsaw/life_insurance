import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_my.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('my'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Secured Flutter App'**
  String get appTitle;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {username}!'**
  String welcomeMessage(String username);

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @languageCode.
  ///
  /// In en, this message translates to:
  /// **'en'**
  String get languageCode;

  /// No description provided for @offlineDataNotice.
  ///
  /// In en, this message translates to:
  /// **'Showing cached offline data.'**
  String get offlineDataNotice;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorUnknown;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection.'**
  String get errorNetwork;

  /// No description provided for @errorConnectionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout. Please try again.'**
  String get errorConnectionTimeout;

  /// No description provided for @errorReceiveTimeout.
  ///
  /// In en, this message translates to:
  /// **'Server response timeout.'**
  String get errorReceiveTimeout;

  /// No description provided for @errorSendTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timeout.'**
  String get errorSendTimeout;

  /// No description provided for @errorRequestCancelled.
  ///
  /// In en, this message translates to:
  /// **'Request cancelled.'**
  String get errorRequestCancelled;

  /// No description provided for @errorCertificate.
  ///
  /// In en, this message translates to:
  /// **'Unable to verify server certificate.'**
  String get errorCertificate;

  /// No description provided for @errorSocket.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to the server.'**
  String get errorSocket;

  /// No description provided for @errorHostLookup.
  ///
  /// In en, this message translates to:
  /// **'Cannot find the server address.'**
  String get errorHostLookup;

  /// No description provided for @errorBadRequest.
  ///
  /// In en, this message translates to:
  /// **'Invalid request.'**
  String get errorBadRequest;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please login again.'**
  String get errorUnauthorized;

  /// No description provided for @errorForbidden.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to perform this action.'**
  String get errorForbidden;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Requested resource not found.'**
  String get errorNotFound;

  /// No description provided for @errorMethodNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Method not allowed.'**
  String get errorMethodNotAllowed;

  /// No description provided for @errorRequestTimeout.
  ///
  /// In en, this message translates to:
  /// **'The request timed out.'**
  String get errorRequestTimeout;

  /// No description provided for @errorConflict.
  ///
  /// In en, this message translates to:
  /// **'Conflict detected.'**
  String get errorConflict;

  /// No description provided for @errorGone.
  ///
  /// In en, this message translates to:
  /// **'Requested resource is no longer available.'**
  String get errorGone;

  /// No description provided for @errorValidation.
  ///
  /// In en, this message translates to:
  /// **'Validation failed.'**
  String get errorValidation;

  /// No description provided for @errorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please try again later.'**
  String get errorTooManyRequests;

  /// No description provided for @errorInternalServer.
  ///
  /// In en, this message translates to:
  /// **'Internal server error.'**
  String get errorInternalServer;

  /// No description provided for @errorBadGateway.
  ///
  /// In en, this message translates to:
  /// **'Bad gateway.'**
  String get errorBadGateway;

  /// No description provided for @errorServiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Service temporarily unavailable.'**
  String get errorServiceUnavailable;

  /// No description provided for @errorGatewayTimeout.
  ///
  /// In en, this message translates to:
  /// **'Gateway timeout.'**
  String get errorGatewayTimeout;

  /// No description provided for @errorNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'Feature not implemented.'**
  String get errorNotImplemented;

  /// No description provided for @errorDataParsing.
  ///
  /// In en, this message translates to:
  /// **'Unable to process server data.'**
  String get errorDataParsing;

  /// No description provided for @errorInvalidResponse.
  ///
  /// In en, this message translates to:
  /// **'Invalid server response.'**
  String get errorInvalidResponse;

  /// No description provided for @errorEmptyResponse.
  ///
  /// In en, this message translates to:
  /// **'No data available.'**
  String get errorEmptyResponse;

  /// No description provided for @errorCache.
  ///
  /// In en, this message translates to:
  /// **'Unable to access cached data.'**
  String get errorCache;

  /// No description provided for @errorSecureStorage.
  ///
  /// In en, this message translates to:
  /// **'Secure storage error.'**
  String get errorSecureStorage;

  /// No description provided for @errorDatabase.
  ///
  /// In en, this message translates to:
  /// **'Database operation failed.'**
  String get errorDatabase;

  /// No description provided for @errorPermission.
  ///
  /// In en, this message translates to:
  /// **'Permission denied.'**
  String get errorPermission;

  /// No description provided for @errorTokenExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired.'**
  String get errorTokenExpired;

  /// No description provided for @errorMaintenance.
  ///
  /// In en, this message translates to:
  /// **'The system is under maintenance.'**
  String get errorMaintenance;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'my'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'my':
      return AppLocalizationsMy();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
