// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Secured Flutter App';

  @override
  String welcomeMessage(String username) {
    return 'Welcome back, $username!';
  }

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get languageCode => 'en';

  @override
  String get offlineDataNotice => 'Showing cached offline data.';

  @override
  String get errorUnknown => 'Something went wrong. Please try again.';

  @override
  String get errorNetwork => 'No internet connection.';

  @override
  String get errorConnectionTimeout => 'Connection timeout. Please try again.';

  @override
  String get errorReceiveTimeout => 'Server response timeout.';

  @override
  String get errorSendTimeout => 'Request timeout.';

  @override
  String get errorRequestCancelled => 'Request cancelled.';

  @override
  String get errorCertificate => 'Unable to verify server certificate.';

  @override
  String get errorSocket => 'Unable to connect to the server.';

  @override
  String get errorHostLookup => 'Cannot find the server address.';

  @override
  String get errorBadRequest => 'Invalid request.';

  @override
  String get errorUnauthorized => 'Session expired. Please login again.';

  @override
  String get errorForbidden =>
      'You don\'t have permission to perform this action.';

  @override
  String get errorNotFound => 'Requested resource not found.';

  @override
  String get errorMethodNotAllowed => 'Method not allowed.';

  @override
  String get errorRequestTimeout => 'The request timed out.';

  @override
  String get errorConflict => 'Conflict detected.';

  @override
  String get errorGone => 'Requested resource is no longer available.';

  @override
  String get errorValidation => 'Validation failed.';

  @override
  String get errorTooManyRequests =>
      'Too many requests. Please try again later.';

  @override
  String get errorInternalServer => 'Internal server error.';

  @override
  String get errorBadGateway => 'Bad gateway.';

  @override
  String get errorServiceUnavailable => 'Service temporarily unavailable.';

  @override
  String get errorGatewayTimeout => 'Gateway timeout.';

  @override
  String get errorNotImplemented => 'Feature not implemented.';

  @override
  String get errorDataParsing => 'Unable to process server data.';

  @override
  String get errorInvalidResponse => 'Invalid server response.';

  @override
  String get errorEmptyResponse => 'No data available.';

  @override
  String get errorCache => 'Unable to access cached data.';

  @override
  String get errorSecureStorage => 'Secure storage error.';

  @override
  String get errorDatabase => 'Database operation failed.';

  @override
  String get errorPermission => 'Permission denied.';

  @override
  String get errorTokenExpired => 'Your session has expired.';

  @override
  String get errorMaintenance => 'The system is under maintenance.';
}
