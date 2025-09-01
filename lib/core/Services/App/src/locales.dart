import 'package:flutter/widgets.dart';

import 'fonts.dart';

enum AppLocale { en, ar }

extension LocaleInfo on AppLocale {
  Locale get locale {
    return Locale(
      name.contains('_') ? name.split('_')[0] : name,
      name.contains('_') ? name.split('_')[1] : null,
    );
  }

  String get languageCode {
    return locale.languageCode;
  }

  AppFont get font {
    switch (this) {
      case AppLocale.en:
        return AppFont.cairo;
      case AppLocale.ar:
        return AppFont.cairo;
    }
  }
}
