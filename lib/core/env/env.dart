class Env {
  static const String appName = 'NLUIS Collect';
  static const String appNameAbbr = 'NLUIS';
  static const String appDescription =
      'Mfumo wa Ukusanyaji wa Taarifa za Ardhi';
  static const String appVersion = '2.0.0';

  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://ardhi.info.tz/api/v1/',
    // defaultValue: 'http://144.91.125.106:8000/api/v1',
  );

  static const String apiVersion = 'v1';
  static const int connectionTimeout = 60000;
  static const int receiveTimeout = 60000;
}
