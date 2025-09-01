//t2 Core Packages Imports
import 'package:logger/logger.dart';

//t2 Dependancies Imports
import '../App/app.service.dart';

//t3 Services
//t3 Models
//t1 Exports
export 'package:logger/logger.dart' show Level;

class LoggingService {
  static bool dev = App.env == AppEnvironment.dev;

  //
  static final Level _level = dev ? Level.debug : Level.error;

  //
  static final Logger _service = Logger(
    level: _level,
    filter: dev ? DevelopmentFilter() : ProductionFilter(),
    printer: PrettyPrinter(
      colors: true,
      printEmojis: true,
      noBoxingByDefault: false,
      printTime: false,
    ),
  );

  //
  //
  static void log(
    String message, {
    Level? level,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _service.log(
      level ?? _level,
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
