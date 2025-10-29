class Env {
  // App Info
  static const String appName = 'Tume ya Matumizi Bora ya Ardhi';
  static const String appNameAbbr = 'NLUIS';
  static const String appDescription = 'Mfumo wa Kukusanya Taarifa';
  static const String appVersion = '2.0.0';

  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://144.91.125.106:8000/api/v1',
    // defaultValue: 'http://192.168.0.15:8080/api/v1',
  );

  static const String apiVersion = 'v1';
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
}
