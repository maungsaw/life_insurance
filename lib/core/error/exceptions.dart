import 'package:flutter/material.dart';
import 'package:life_insurance/core/core.dart' show LocalizationContext;

import 'failures.dart';

class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({required this.message, this.statusCode});
}

class CacheException implements Exception {
  final String message;

  const CacheException([this.message = 'Cache error occurred.']);
}

class DataParsingException implements Exception {
  final String message;

  const DataParsingException([this.message = 'Failed to parse response.']);
}

extension FailureUIExtension on Failure {
  String toErrorMessage(BuildContext context) {
    // Prefer backend/custom message if available
    final customMessage = message?.trim();
    if (customMessage != null && customMessage.isNotEmpty) {
      return customMessage;
    }

    // Otherwise use localization
    return context.trByKey(errorKey);
  }
}
