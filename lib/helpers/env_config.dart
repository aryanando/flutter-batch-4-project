import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api.batubhayangkara.com';
  static bool get debug => dotenv.env['DEBUG'] == 'true';
}
