class AppConstants {
  
  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacing2xl = 48.0;

  // Border Radius
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Storage Keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUser = 'user';
  static const String keyActiveModule = 'active_module';
  static const String keyLocale = 'locale';
  static const String keyThemeMode = 'theme_mode';

  // Sync
  static const int syncBatchSize = 50;
  static const Duration syncRetryDelay = Duration(seconds: 5);

  // Locales
  static const String localeSwahili = 'sw';
  static const String localeEnglish = 'en';

  // Project Status
  static const String statusActive = 'active';
  static const String statusInactive = 'inactive';
  static const String statusCompleted = 'completed';

  // Pack Status
  static const String packStatusPending = 'pending';
  static const String packStatusDownloading = 'downloading';
  static const String packStatusComplete = 'complete';
  static const String packStatusFailed = 'failed';

  // Sync Status
  static const String syncStatusPending = 'pending';
  static const String syncStatusInProgress = 'in_progress';
  static const String syncStatusSuccess = 'success';
  static const String syncStatusFailed = 'failed';
}

class ModuleType {
  static const int landUse = 1;
  static const int landSubDivision = 2;
  static const int monitoringAndEvaluation = 3;
  static const int compliance = 4;

  static const Map<int, String> labels = {
    landUse: "Land Use",
    landSubDivision: "Land Sub Division",
    monitoringAndEvaluation: "Monitoring & Evaluation",
    compliance: "Compliance",
  };
}
