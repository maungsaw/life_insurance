import 'package:flutter/foundation.dart' show debugPrint;
import 'package:local_auth/local_auth.dart'
    show LocalAuthentication, BiometricType, LocalAuthException;
import 'package:flutter/services.dart' show PlatformException;

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();
  Future<bool> isBiometricsAvailable() async {
    try {
      final canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();
      return canAuthenticateWithBiometrics && isDeviceSupported;
    } on PlatformException {
      return false;
    } on LocalAuthException {
      return false;
    }
  }

  /// Face ID / Fingerprint / Biometric — for Profile & Login copy.
  Future<String> kindLabel() async {
    try {
      final types = await _auth.getAvailableBiometrics();
      if (types.contains(BiometricType.face)) return 'Face ID';
      if (types.contains(BiometricType.fingerprint)) return 'Fingerprint';
      if (types.contains(BiometricType.iris)) return 'Iris';
    } on PlatformException {
      // Fall through to generic label.
    } on LocalAuthException {
      // Fall through to generic label.
    }
    return 'Biometric';
  }

  /// Trigger native biometric prompt
  Future<bool> authenticate({required String reason}) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
      );
    } on PlatformException catch (e) {
      debugPrint("Bio Metric Error -> $e");
      return false;
    } on LocalAuthException catch (e) {
      debugPrint("Bio Metric Error -> $e");
      return false;
    }
  }
}
