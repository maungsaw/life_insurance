/// Local-only prototype rules (docs/37 · docs/38 · docs/45). No network.
abstract final class PrototypeConfig {
  static const bool enabled = true;

  /// Demo wrong-password path from LoginRegister error modal.
  static const String wrongPasswordDemo = '0000';

  static const Duration shortDelay = Duration(milliseconds: 500);
  static const Duration mediumDelay = Duration(milliseconds: 700);
  static const Duration splashDelay = Duration(milliseconds: 1200);

  static const int otpLength = 6;
  /// Register / generic OTP resend.
  static const int otpResendSeconds = 45;
  /// Forgot Password wireframe shows 06:00.
  static const int otpResendSecondsForgot = 360;

  /// Demo: always lands on Registration Inprogress (docs/45).
  static const String registrationPendingDemo = '09999999999';

  /// Session memory — lost on app restart (prototype only).
  static final Set<String> _pendingMobiles = {registrationPendingDemo};
  static final Set<String> _activeMobiles = <String>{};

  static String normalizeMobile(String mobile) =>
      mobile.trim().replaceAll(' ', '');

  /// Mock CORE gate: mobile must look like MM local format.
  static bool isCoreMobileOk(String mobile) {
    final t = normalizeMobile(mobile);
    return t.startsWith('09') && t.length >= 9;
  }

  static bool isWrongPassword(String password) =>
      password.trim() == wrongPasswordDemo;

  static bool isRegistrationPending(String mobile) {
    final t = normalizeMobile(mobile);
    if (t == registrationPendingDemo) return true;
    return _pendingMobiles.contains(t);
  }

  static bool isRegistrationActive(String mobile) {
    final t = normalizeMobile(mobile);
    if (t == registrationPendingDemo) return false;
    return _activeMobiles.contains(t);
  }

  static void markPending(String mobile) {
    final t = normalizeMobile(mobile);
    if (t.isEmpty) return;
    _activeMobiles.remove(t);
    _pendingMobiles.add(t);
  }

  /// After Create Password SAVE — invited agent can log in.
  static void markActive(String mobile) {
    final t = normalizeMobile(mobile);
    if (t.isEmpty) return;
    if (t == registrationPendingDemo) return;
    _pendingMobiles.remove(t);
    _activeMobiles.add(t);
  }

  // Bottom-nav slots (docs/44): Home · Customer · Product · Profile
  static const int tabHome = 0;
  static const int tabCustomer = 1;
  static const int tabProduct = 2;
  static const int tabProfile = 3;
  /// Off-nav stack pages (reachable via Home tiles / FAB).
  static const int tabLeads = 4;
  static const int tabTasks = 5;

  /// Alias — prefer [tabCustomer].
  static const int tabCustomers = tabCustomer;
  /// Alias — prefer [tabProfile].
  static const int tabMore = tabProfile;
}
