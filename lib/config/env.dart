// lib/config/env.dart
abstract class Env {
  static const String baseApiUrl = String.fromEnvironment(
    'BASE_API_URL',
    defaultValue: 'http://10.0.2.2:3001/api/v1',
  );
}
