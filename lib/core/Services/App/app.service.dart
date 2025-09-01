//t1 --Imports
//t2 Core Packages Imports
//t2 Dependancies Imports
// import '../Error Handling/error_handling.service.dart';

import 'src/exports.app.dart';

//t3 Services
//t3 Models
//t1 --Imports
//t1 Exports
export 'src/exports.app.dart';
//t1 --Exports

class App {
  //t2 Environment
  static late AppEnvironment env;

  //
  //
  static Future<void> initialize(AppEnvironment environment) async {
    env = environment;
    try {
      return await environment.load();
    } catch (e) {
      // ErrorHandlingService.handle(e, "App/initialize", stackTrace: s);
    }
  }
}
