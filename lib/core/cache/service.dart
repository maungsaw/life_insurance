import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:life_insurance/core/core.dart';

abstract class LocalCacheService {
  Future<void> write({required String key, required String value});
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<void> clearAll();
  Future<bool> isBiometricsEnabled();
  Future<void> setBiometricsEnabled(bool enabled);
}

class ILocalCacheService implements LocalCacheService {
  final FlutterSecureStorage _storage;

  ILocalCacheService({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            // Android: Enables hardware-backed key encryption
            aOptions: AndroidOptions(resetOnError: true),
            // iOS: Standard Keychain access
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock,
            ),
          );

  @override
  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  @override
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  @override
  Future<bool> isBiometricsEnabled() async {
    final val = await _storage.read(key: CacheConstants.bioMetric);
    return val == 'true';
  }

  @override
  Future<void> setBiometricsEnabled(bool enabled) {
    return write(
      key: CacheConstants.bioMetric,
      value: enabled ? 'true' : 'false',
    );
  }
}
