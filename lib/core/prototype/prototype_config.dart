/// Local-only prototype rules (docs/37 · docs/38). No network.
abstract final class PrototypeConfig {
  static const bool enabled = true;

  /// Demo wrong-password path from LoginRegister error modal.
  static const String wrongPasswordDemo = '0000';

  static const Duration shortDelay = Duration(milliseconds: 500);
  static const Duration mediumDelay = Duration(milliseconds: 700);
  static const Duration splashDelay = Duration(milliseconds: 1200);

  static const int otpLength = 6;
  static const int otpResendSeconds = 45;

  /// Mock CORE gate: mobile must look like MM local format.
  static bool isCoreMobileOk(String mobile) {
    final t = mobile.trim();
    return t.startsWith('09') && t.length >= 9;
  }

  static bool isWrongPassword(String password) =>
      password.trim() == wrongPasswordDemo;

  // Bottom-nav indices in LifeInsurancePage
  static const int tabHome = 0;
  static const int tabLeads = 1;
  static const int tabCustomers = 2;
  static const int tabTasks = 3;
  static const int tabMore = 4;
}
