import 'package:flutter/material.dart';

import '../../Contexter/contexter.service.dart';
import 'error_model.dart';

class ErrorPresenter {
  static Future<void> present(AppError error) async {
    final context = Contexter.currentContext;

    final snackBar = SnackBar(
      content: Text(
        error.type == AppErrorType.generic
            ? 'A generic error has occurred!'
            : error.msg!,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          backgroundColor: Theme.of(context).colorScheme.onError,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.error,
      duration: const Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
