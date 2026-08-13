/// Central image / asset paths — always import this instead of hardcoding strings.
/// See docs/39-splash-login-brand-assets.md
abstract final class AppAssets {
  AppAssets._();

  /// Full wordmark (mark + KBZ LIFE + slogan). Splash + Login (LoginRegister 1st/2nd).
  static const String mainLogo = 'assets/main-logo.png';

  /// Geometric brand mark only (no wordmark text).
  static const String brandMark = 'assets/images.png';
}
