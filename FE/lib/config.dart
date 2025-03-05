import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvironmentConfig {
  static final EnvironmentConfig _instance = EnvironmentConfig._internal();

  factory EnvironmentConfig() {
    return _instance;
  }

  EnvironmentConfig._internal();

  static String get apiKey {
    const String apiKeyFromDefine = String.fromEnvironment('AWS_API_KEY', defaultValue: '');
    return apiKeyFromDefine.isNotEmpty ? apiKeyFromDefine : (dotenv.env['AWS_API_KEY'] ?? '');
  }
}