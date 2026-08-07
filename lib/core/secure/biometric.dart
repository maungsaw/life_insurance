import 'package:flutter/foundation.dart' show debugPrint;
import 'package:local_auth/local_auth.dart' show LocalAuthentication;
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
    }
  }

  /// Trigger native biometric prompt
  Future<bool> authenticate({required String reason}) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
      );
    } on PlatformException catch (e) {
      // Handle OS errors (e.g., user canceled, too many failed attempts)
      debugPrint("Bio Metric Error -> $e");
      return false;
    }
  }
}
