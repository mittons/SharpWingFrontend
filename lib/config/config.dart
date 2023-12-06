// lib/config/config.dart

class AppConfig {
  final String baseApiUrl;

  AppConfig({required this.baseApiUrl});
}

class ProductionConfig extends AppConfig {
  static const String baseApiUrlValue =
      "https://sharp-wing-backend-69be84f59c7d.herokuapp.com";

  ProductionConfig() : super(baseApiUrl: baseApiUrlValue);
}

class TestConfig extends AppConfig {
  static const String baseApiUrlValue = 'http://localhost:3000';
  final int containerPort = 5000;
  final int hostPort = 3000;
  final String dockerImage = "ghcr.io/mittons/sharpwingback:latest";

  TestConfig() : super(baseApiUrl: baseApiUrlValue);
}

class DevConfig extends AppConfig {
  static const String baseApiUrlValue = 'http://localhost:5000';

  DevConfig() : super(baseApiUrl: baseApiUrlValue);
}
