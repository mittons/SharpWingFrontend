// lib/config/config.dart

class AppConfig {
  final String baseApiUrl;

  AppConfig({required this.baseApiUrl});
}

class ProductionConfig extends AppConfig {
  static const String baseApiUrlValue = "https://production-api.example.com";

  ProductionConfig() : super(baseApiUrl: baseApiUrlValue);
}

class TestConfig extends AppConfig {
  static const String baseApiUrlValue = 'https://test-api.example.com';

  TestConfig() : super(baseApiUrl: baseApiUrlValue);
}

class DevConfig extends AppConfig {
  static const String baseApiUrlValue = 'http://localhost:5000';

  DevConfig() : super(baseApiUrl: baseApiUrlValue);
}
