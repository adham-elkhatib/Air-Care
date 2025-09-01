import 'package:min_id/min_id.dart';

class IdGeneratingService {
  // static const String defaultPattern = '5{w}-3{d}-3{w}-5{d}';
  static const String defaultPattern = '3{d}-3{w}-5{d}';

  static String generate({String? pattern}) {
    return MinId.getId(pattern ?? defaultPattern);
  }
}
