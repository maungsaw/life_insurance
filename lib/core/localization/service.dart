import 'dart:ui';

import 'const.dart' show LanguageConstants;

abstract class LocalizationService {
  static String getLanguageDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case LanguageConstants.englishKey:
        return LanguageConstants.englishDisplayName;
      case LanguageConstants.myanmarKey:
        return LanguageConstants.myanmarDisplayName;
      case LanguageConstants.chineseKey:
        return LanguageConstants.chineseDisplayName;
      case LanguageConstants.thaiKey:
        return LanguageConstants.thaiDisplayName;
      default:
        return locale.languageCode.toUpperCase();
    }
  }
}
