// lib/config/env.dart
abstract class Env {
  static const String baseApiUrl = String.fromEnvironment(
    'BASE_API_URL',
    defaultValue: 'http://localhost:3001/api/v1',
  );
}
