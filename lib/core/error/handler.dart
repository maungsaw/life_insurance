import 'dart:io';
import 'package:dio/dio.dart';
import 'exceptions.dart';
import 'failures.dart';

class ExceptionHandler {
  static Failure handle(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is TypeError ||
        error is FormatException ||
        error is DataParsingException) {
      // Handles type casting issues like parsing String to int or null field errors
      return const DataParsingFailure();
    } else if (error is CacheException) {
      return CacheFailure(message: error.message);
    } else if (error is ServerException) {
      return ServerFailure(
        message: error.message,
        statusCode: error.statusCode,
      );
    } else if (error is Failure) {
      return error;
    } else {
      return UnknownFailure(message: error.toString());
    }
  }

  static Failure _handleDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkFailure();

      case DioExceptionType.badResponse:
        final statusCode = dioError.response?.statusCode;
        final responseData = dioError.response?.data;

        if (statusCode == 401 || statusCode == 403) {
          return const UnauthorizedFailure();
        }

        // Try extracting backend message from JSON response body
        String errorMessage = 'Server error occurred ($statusCode)';
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('message')) {
          errorMessage = responseData['message'].toString();
        }

        return ServerFailure(message: errorMessage, statusCode: statusCode);

      case DioExceptionType.cancel:
        return const UnknownFailure(message: 'Request was cancelled.');

      default:
        if (dioError.error is SocketException) {
          return const NetworkFailure();
        }
        return const UnknownFailure();
    }
  }
}
