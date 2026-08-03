import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  /// Custom message from backend (optional)
  final String? message;

  final int? statusCode;

  const Failure({this.message, this.statusCode});

  /// Localization key
  String get errorKey;

  @override
  List<Object?> get props => [message, statusCode, errorKey];
}

/// ===============================
/// NETWORK
/// ===============================

class NetworkFailure extends Failure {
  const NetworkFailure({super.message});

  @override
  String get errorKey => 'errorNetwork';
}

class ConnectionTimeoutFailure extends Failure {
  const ConnectionTimeoutFailure({super.message});

  @override
  String get errorKey => 'errorConnectionTimeout';
}

class ReceiveTimeoutFailure extends Failure {
  const ReceiveTimeoutFailure({super.message});

  @override
  String get errorKey => 'errorReceiveTimeout';
}

class SendTimeoutFailure extends Failure {
  const SendTimeoutFailure({super.message});

  @override
  String get errorKey => 'errorSendTimeout';
}

class RequestCancelledFailure extends Failure {
  const RequestCancelledFailure({super.message});

  @override
  String get errorKey => 'errorRequestCancelled';
}

class CertificateFailure extends Failure {
  const CertificateFailure({super.message});

  @override
  String get errorKey => 'errorCertificate';
}

class SocketFailure extends Failure {
  const SocketFailure({super.message});

  @override
  String get errorKey => 'errorSocket';
}

class HostLookupFailure extends Failure {
  const HostLookupFailure({super.message});

  @override
  String get errorKey => 'errorHostLookup';
}

/// ===============================
/// SERVER
/// ===============================

class ServerFailure extends Failure {
  const ServerFailure({super.message, super.statusCode});

  @override
  String get errorKey => 'errorUnknown';
}

class BadRequestFailure extends Failure {
  const BadRequestFailure({super.message, super.statusCode = 400});

  @override
  String get errorKey => 'errorBadRequest';
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message, super.statusCode = 401});

  @override
  String get errorKey => 'errorUnauthorized';
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure({super.message, super.statusCode = 403});

  @override
  String get errorKey => 'errorForbidden';
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message, super.statusCode = 404});

  @override
  String get errorKey => 'errorNotFound';
}

class MethodNotAllowedFailure extends Failure {
  const MethodNotAllowedFailure({super.message, super.statusCode = 405});

  @override
  String get errorKey => 'errorMethodNotAllowed';
}

class RequestTimeoutFailure extends Failure {
  const RequestTimeoutFailure({super.message, super.statusCode = 408});

  @override
  String get errorKey => 'errorRequestTimeout';
}

class ConflictFailure extends Failure {
  const ConflictFailure({super.message, super.statusCode = 409});

  @override
  String get errorKey => 'errorConflict';
}

class GoneFailure extends Failure {
  const GoneFailure({super.message, super.statusCode = 410});

  @override
  String get errorKey => 'errorGone';
}

class ValidationFailure extends Failure {
  const ValidationFailure({super.message, super.statusCode = 422});

  @override
  String get errorKey => 'errorValidation';
}

class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure({super.message, super.statusCode = 429});

  @override
  String get errorKey => 'errorTooManyRequests';
}

class InternalServerFailure extends Failure {
  const InternalServerFailure({super.message, super.statusCode = 500});

  @override
  String get errorKey => 'errorInternalServer';
}

class NotImplementedFailure extends Failure {
  const NotImplementedFailure({super.message, super.statusCode = 501});

  @override
  String get errorKey => 'errorNotImplemented';
}

class BadGatewayFailure extends Failure {
  const BadGatewayFailure({super.message, super.statusCode = 502});

  @override
  String get errorKey => 'errorBadGateway';
}

class ServiceUnavailableFailure extends Failure {
  const ServiceUnavailableFailure({super.message, super.statusCode = 503});

  @override
  String get errorKey => 'errorServiceUnavailable';
}

class GatewayTimeoutFailure extends Failure {
  const GatewayTimeoutFailure({super.message, super.statusCode = 504});

  @override
  String get errorKey => 'errorGatewayTimeout';
}

/// ===============================
/// DATA
/// ===============================

class DataParsingFailure extends Failure {
  const DataParsingFailure({super.message});

  @override
  String get errorKey => 'errorDataParsing';
}

class InvalidResponseFailure extends Failure {
  const InvalidResponseFailure({super.message});

  @override
  String get errorKey => 'errorInvalidResponse';
}

class EmptyResponseFailure extends Failure {
  const EmptyResponseFailure({super.message});

  @override
  String get errorKey => 'errorEmptyResponse';
}

/// ===============================
/// LOCAL STORAGE
/// ===============================

class CacheFailure extends Failure {
  const CacheFailure({super.message});

  @override
  String get errorKey => 'errorCache';
}

class SecureStorageFailure extends Failure {
  const SecureStorageFailure({super.message});

  @override
  String get errorKey => 'errorSecureStorage';
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({super.message});

  @override
  String get errorKey => 'errorDatabase';
}

/// ===============================
/// BUSINESS
/// ===============================

class BusinessFailure extends Failure {
  const BusinessFailure({super.message, super.statusCode});

  @override
  String get errorKey => 'errorUnknown';
}

class PermissionFailure extends Failure {
  const PermissionFailure({super.message});

  @override
  String get errorKey => 'errorPermission';
}

class TokenExpiredFailure extends Failure {
  const TokenExpiredFailure({super.message, super.statusCode = 401});

  @override
  String get errorKey => 'errorTokenExpired';
}

class MaintenanceFailure extends Failure {
  const MaintenanceFailure({super.message, super.statusCode = 503});

  @override
  String get errorKey => 'errorMaintenance';
}

/// ===============================
/// UNKNOWN
/// ===============================

class UnknownFailure extends Failure {
  const UnknownFailure({super.message});

  @override
  String get errorKey => 'errorUnknown';
}
