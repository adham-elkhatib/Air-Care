import 'package:flutter/material.dart';

class SnackbarHelper {
  static void showTemplated(
    BuildContext context, {
    Widget? leading,
    required String title,
    String? message,
    Widget? content,
    Widget? trailing,
    Duration duration = const Duration(seconds: 3),
  }) {
    final snackBarContent = Row(
      children: [
        if (leading != null) leading,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
              ),
              if (message != null) Text(message),
              if (content != null) content,
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: snackBarContent,
        duration: duration,
        behavior: SnackBarBehavior.floating, // Float the SnackBar
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Rounded corners
        ),
      ),
    );
  }

  static void showError(
    BuildContext context, {
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 3),
  }) {
    final Color backgroundColor = Theme.of(context).colorScheme.error;
    final Color textColor = Theme.of(context).colorScheme.onError;

    final snackBarContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
        if (message != null) Text(message, style: TextStyle(color: textColor)),
      ],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: snackBarContent,
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static void showCustom(
    BuildContext context, {
    required Widget child,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: child,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
