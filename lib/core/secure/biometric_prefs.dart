import 'package:life_insurance/core/cache/service.dart'
    show ILocalCacheService, LocalCacheService;
import 'package:life_insurance/core/prototype/prototype_config.dart'
    show PrototypeConfig;
import 'package:life_insurance/core/secure/biometric.dart' show BiometricService;

/// Profile + Login biometric preference (docs/70). Prototype may mock when no sensor.
abstract final class BiometricPrefs {
  static final LocalCacheService _cache = ILocalCacheService();
  static final BiometricService _bio = BiometricService();

  static bool enabled = false;
  static bool hardwareReady = false;
  static String kindLabel = 'Biometric';

  static Future<void> load() async {
    enabled = await _cache.isBiometricsEnabled();
    hardwareReady = await _bio.isBiometricsAvailable();
    kindLabel = await _bio.kindLabel();
  }

  static Future<bool> authenticate({required String reason}) {
    return _bio.authenticate(reason: reason);
  }

  static Future<void> setEnabled(bool value) async {
    enabled = value;
    await _cache.setBiometricsEnabled(value);
  }

  /// Simulator / no sensor — still allow UX review (docs/70 · 37).
  static bool get allowPrototypeMock =>
      PrototypeConfig.enabled && !hardwareReady;

  /// Login / Profile CTA: Unlock with Face ID · fingerprint · biometric.
  static String get unlockCtaLabel {
    switch (kindLabel) {
      case 'Face ID':
        return 'Unlock with Face ID';
      case 'Fingerprint':
        return 'Unlock with fingerprint';
      default:
        return 'Unlock with biometric';
    }
  }

  static String get profileSubtitle {
    if (!hardwareReady && !allowPrototypeMock) {
      return 'Not available on this device';
    }
    if (enabled) {
      if (allowPrototypeMock) {
        return 'Prototype: biometric mocked — no sensor.';
      }
      return '$kindLabel to open the app';
    }
    if (allowPrototypeMock) {
      return 'Not available on this device. Prototype can mock On.';
    }
    return 'Use Face ID or fingerprint next time you open the app.';
  }
}
