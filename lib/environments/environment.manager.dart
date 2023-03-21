import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvironmentManager {
  static String? get apiUrl => dotenv.env['API'];
}
