/// Central image / asset paths — always import this instead of hardcoding strings.
/// See docs/39-splash-login-brand-assets.md · brand-logo-placement-brainstorm.md
abstract final class AppAssets {
  AppAssets._();

  /// Horizontal wordmark (mark + KBZ LIFE + slogan). Wide headers / marketing.
  static const String mainLogo = 'assets/main-logo.png';

  /// Stacked lockup (icon + KBZ LIFE + Insurance). Splash / Get Started + Login.
  static const String splashLockup = 'assets/splash-lockup.png';

  /// Geometric brand mark only (no wordmark text). App bar / home header.
  static const String brandMark = 'assets/brand-mark.png';

  /// Alias kept for older references (same file as [brandMark]).
  static const String brandMarkLegacy = 'assets/images.png';

  /// Galaxy Member status banner (Home, after Commission — docs/48).
  static const String galaxyMember = 'assets/galaxy-member.png';
}
