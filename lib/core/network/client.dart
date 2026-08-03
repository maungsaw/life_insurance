import 'package:dio/dio.dart' show Dio, BaseOptions, Headers;
import 'package:flutter/foundation.dart';
import 'package:life_insurance/core/core.dart'
    show ApiClient, NetworkServiceType, ILocalCacheService, DioInterceptor;

class NetworkClient {
  static final Map<NetworkServiceType, Dio> _instances = {};

  static Dio getClient(NetworkServiceType type) {
    final expectedBaseUrl = '${ApiClient.baseUrl}${ApiClient.clientVersion}';

    final existing = _instances[type];
    if (existing != null) {
      if (existing.options.baseUrl != expectedBaseUrl) {
        existing.options.baseUrl = expectedBaseUrl;
      }
      return existing;
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: expectedBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        contentType: Headers.jsonContentType,
        headers: const {'Accept': 'application/json'},
      ),
    );

    if (kDebugMode) {
      // dio.interceptors.add();
    }

    if (type == NetworkServiceType.protected) {
      dio.interceptors.add(
        DioInterceptor(dio: dio, localCacheService: ILocalCacheService()),
      );
    }

    _instances[type] = dio;
    return dio;
  }

  static void reset() => _instances.clear();
}
