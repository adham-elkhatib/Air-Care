import 'package:flutter_dotenv/flutter_dotenv.dart';

enum AppEnvironment { dev, prod }

extension Info on AppEnvironment {
  //t2 Environment Names
  String get name {
    switch (this) {
      case AppEnvironment.dev:
        return "dev";
      case AppEnvironment.prod:
        return 'prod';
    }
  }

  //t2 Environment Loaders
  Future<void> load() async {
    // Make Sure app environment location is suited for platform.
    switch (this) {
      case AppEnvironment.dev:
        return await dotenv.load(fileName: 'dev.env');
      case AppEnvironment.prod:
        return await dotenv.load(fileName: 'prod.env');
    }
  }

  //t2 Get Environment Variables
  String get(String variable) {
    return dotenv.get(variable, fallback: '');
  }
}
