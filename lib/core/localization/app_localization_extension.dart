import 'package:flutter/material.dart';

import 'app_localizations.dart';

extension LocalizationContext on BuildContext {
  AppLocalizations get tr => AppLocalizations.of(this)!;

  String trByKey(String key) {
    switch (key) {
      case 'errorNetwork':
        return tr.errorNetwork;

      case 'errorConnectionTimeout':
        return tr.errorConnectionTimeout;

      case 'errorReceiveTimeout':
        return tr.errorReceiveTimeout;

      case 'errorSendTimeout':
        return tr.errorSendTimeout;

      case 'errorRequestCancelled':
        return tr.errorRequestCancelled;

      case 'errorCertificate':
        return tr.errorCertificate;

      case 'errorSocket':
        return tr.errorSocket;

      case 'errorHostLookup':
        return tr.errorHostLookup;

      case 'errorBadRequest':
        return tr.errorBadRequest;

      case 'errorUnauthorized':
        return tr.errorUnauthorized;

      case 'errorForbidden':
        return tr.errorForbidden;

      case 'errorNotFound':
        return tr.errorNotFound;

      case 'errorMethodNotAllowed':
        return tr.errorMethodNotAllowed;

      case 'errorRequestTimeout':
        return tr.errorRequestTimeout;

      case 'errorConflict':
        return tr.errorConflict;

      case 'errorGone':
        return tr.errorGone;

      case 'errorValidation':
        return tr.errorValidation;

      case 'errorTooManyRequests':
        return tr.errorTooManyRequests;

      case 'errorInternalServer':
        return tr.errorInternalServer;

      case 'errorNotImplemented':
        return tr.errorNotImplemented;

      case 'errorBadGateway':
        return tr.errorBadGateway;

      case 'errorServiceUnavailable':
        return tr.errorServiceUnavailable;

      case 'errorGatewayTimeout':
        return tr.errorGatewayTimeout;

      case 'errorDataParsing':
        return tr.errorDataParsing;

      case 'errorInvalidResponse':
        return tr.errorInvalidResponse;

      case 'errorEmptyResponse':
        return tr.errorEmptyResponse;

      case 'errorCache':
        return tr.errorCache;

      case 'errorSecureStorage':
        return tr.errorSecureStorage;

      case 'errorDatabase':
        return tr.errorDatabase;

      case 'errorPermission':
        return tr.errorPermission;

      case 'errorTokenExpired':
        return tr.errorTokenExpired;

      case 'errorMaintenance':
        return tr.errorMaintenance;

      default:
        return tr.errorUnknown;
    }
  }
}
