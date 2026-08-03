import 'dart:ui';

abstract class LocalizationService {
  static String getLanguageDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'my':
        return 'မြန်မာ (Myanmar)';
      case 'zh':
        return '中文 (Chinese)';
      case 'th':
        return 'ไทย (Thai)';
      default:
        return locale.languageCode.toUpperCase();
    }
  }
}
