import 'package:life_insurance/core/core.dart'
    show BiometricService, LocalCacheService, CacheConstants;
import 'package:life_insurance/features/auth/auth.dart';

class IAuthRepository implements AuthRepository {
  final LocalCacheService tokenStorage;
  final BiometricService biometricService;

  IAuthRepository({required this.tokenStorage, required this.biometricService});

  @override
  Future<String?> retrieveSessionWithBiometrics() async {
    // 1. Check if biometrics enabled for this user
    final isEnabled = await tokenStorage.isBiometricsEnabled();
    if (!isEnabled) return null;

    // 2. Check hardware availability
    final isHardwareReady = await biometricService.isBiometricsAvailable();
    if (!isHardwareReady) return null;

    // 3. Prompt user for biometric unlock
    final isAuthenticated = await biometricService.authenticate(
      reason: 'Please authenticate to log in to your account',
    );

    if (isAuthenticated) {
      // 4. Return stored refresh token to exchange for a fresh access token
      return await tokenStorage.read(CacheConstants.refreshToken);
    }

    return null; // Auth failed or user canceled
  }

  /// Authenticate session on App Launch
}
