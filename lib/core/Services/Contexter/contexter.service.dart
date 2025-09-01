import 'package:flutter/widgets.dart';

/// Build context holder.
class Contexter {
  /// get current context.
  static BuildContext get currentContext {
    return key.currentContext!;
  }

  /// get current state.
  static get currentState {
    return key.currentState;
  }

  /// get current widget.
  static Widget get currentWidget {
    return key.currentWidget!;
  }

  /// get current overlay.
  static OverlayState get currentOverlay {
    return key.currentState!.overlay!;
  }

  /// root app navigator key.
  /// set this key to your root app's navigatorKey.
  static final key = GlobalKey<NavigatorState>();
}
