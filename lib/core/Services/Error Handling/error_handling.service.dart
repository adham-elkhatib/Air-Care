//t1 --Imports
//t2 Core Packages Imports
//t3 Services
import 'package:stack_trace/stack_trace.dart';

import '../App/app.service.dart';
import '../Logging/logging.service.dart';
//t2 Dependancies Imports
import 'src/exports.error_handling.dart';

//t3 Models
//t1 --Imports
//t1 Exports
export 'src/exports.error_handling.dart';

typedef FunctionReturner<T> = T Function();

class ErrorHandlingService {
  //------------------------------------------------------------------------------------------
  // Protect
  //------------------------------------------------------------------------------------------
  static protect(Function process) async {
    try {
      await process();
    } catch (e, s) {
      handle(
        e,
        Trace.format(Trace.current(1).terse),
        stackTrace: Trace.from(s).terse,
      );
    }
  }

  //------------------------------------------------------------------------------------------
  // Handling.
  //------------------------------------------------------------------------------------------
  static AppError handle(
    dynamic error,
    String location, {
    bool log = true,
    StackTrace? stackTrace,
  }) {
    LoggingService.log(Trace.format(Trace.current().terse));
    // [1] Map dynamic error to app error
    AppError mappedError = _map(error, location: location);
    // [2] Based on error type, take action
    switch (mappedError.type) {
      case AppErrorType.ignored:
        {
          LoggingService.log(
            mappedError.msg ?? "Ignored Error Logged",
            level: Level.debug,
            error: mappedError,
            stackTrace: stackTrace,
          );
        }
        break;
      case AppErrorType.generic:
        {
          LoggingService.log(
            mappedError.msg ?? "Generic Error Logged",
            level: Level.warning,
          );
          // ReportingService.report(
          //   error,
          //   location: location,
          //   stackTrace: stackTrace,
          // );
          if (App.env == AppEnvironment.prod) {
            // FirebaseCrashlytics.instance
            //     .recordError(error, stackTrace, information: [
            //   'Location: $location',
            // ]);
          }
          // present error
          // ErrorPresenter.present(
          //   mappedError,
          // );
        }
        break;
      case AppErrorType.fatal:
        {
          // log the error
          LoggingService.log(
            "Fatal Error Logged in ${mappedError.location} at ${mappedError.timestamp} || ${mappedError.code}",
            level: Level.wtf,
            error: error,
          );
          // _crashAndReport(
          //   error,
          //   stackTrace,
          //   location,
          // );
        }
        break;
      case AppErrorType.presentable:
        {
          // log the error
          LoggingService.log(
            "Error Logged in ${mappedError.location} at ${mappedError.timestamp} || ${mappedError.code}",
            level: Level.info,
            error: error,
            stackTrace: stackTrace,
          );

          // present error
          // ErrorPresenter.present(
          //   mappedError,
          // );
        }
        break;
    }
    return mappedError;
  }

  static void error(String error, String location) {
    try {
      throw (error);
    } catch (e, s) {
      handle(e, location, stackTrace: s);
    }
  }

  //----------------------- Helper methods
  static AppError _map(dynamic e, {String? location}) {
    DateTime timestamp = DateTime.now();
    //
    String errorWithVar = e.toString().split(']')[0].replaceAll('[', "");
    String errorCode = errorWithVar.split('{')[0];
    String? variable = errorWithVar == errorCode
        ? null
        : errorWithVar.toString().split('{')[1].replaceAll('}', "");
    //
    if (errorMap.keys.contains(errorCode)) {
      // Indexed error
      return errorMap[errorCode]!.copyWith(
        location: location,
        timestamp: timestamp,
        msg: errorMap[errorCode]!.msg!
            .replaceAll("{}", variable ?? '')
            .replaceAll('_', ' '),
      );
    } else {
      // non-indexed/generic error
      return AppError.generic(
        msg: "Generic Error Logged || $e || $location || $timestamp",
        location: location,
        timestamp: timestamp,
      );
    }
  }
}
