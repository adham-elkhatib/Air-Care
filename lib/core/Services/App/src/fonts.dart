enum AppFont { cairo }

extension FontInfo on AppFont {
  String get assetName {
    switch (this) {
      case AppFont.cairo:
        return 'Cairo';
    }
  }
}
