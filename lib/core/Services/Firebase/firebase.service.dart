// ignore_for_file: depend_on_referenced_packages
//t2 Core Packages Imports
import 'package:firebase_core/firebase_core.dart';

//t2 Dependancies Imports
//t3 Services
// import '../Error Handling/error_handling.service.dart';
import '../Error Handling/error_handling.service.dart';
import '../Logging/logging.service.dart';
//t3 Models
import 'src/firebase_options.dart';
//t1 Exports

class FirebaseService {
  static Future<FirebaseApp?> initialize() async {
    FirebaseApp? app;
    try {
      app = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      LoggingService.log("Firebase App Initialized: ${app.name}");
    } catch (e, s) {
      ErrorHandlingService.handle(
        e,
        'FirebaseService/initialize',
        stackTrace: s,
      );
    }
    return app;
  }
}
