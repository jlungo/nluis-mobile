import 'package:flutter/material.dart';

class AppConstants {
  
  // Colors (Light Theme)
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color borderColor = Color(0xFFE0E0E0);

  // Colors (Dark Theme)
  static const Color darkPrimary = Color(0xFF64B5F6);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkBorder = Color(0xFF424242);
  
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

  // Map Configuration
  static const double mapDefaultZoom = 15.0;
  static const double mapMinZoom = 8.0;
  static const double mapMaxZoom = 20.0;
  static const double mapLocationZoom = 16.0;
  static const double mapBoundaryFitPadding = 50.0;
  static const int mapTileCacheDurationDays = 30;
  static const int mapMaxTileCacheSize = 500; // MB
  
  // Map Tile URLs
  static const String mapTileStandard = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String mapTileSatellite = 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
  static const String mapTileDark = 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';
  static const String mapTileLabels = 'https://server.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/MapServer/tile/{z}/{y}/{x}';
  
  // Map UI
  static const double mapControlSize = 48.0;
  static const double mapLocationIndicatorSize = 56.0;
  static const double mapMarkerSize = 20.0;
  static const double mapMarkerBorderWidth = 2.0;
  static const double mapPolylineWidth = 3.0;
  static const double mapPolygonBorderWidth = 2.0;
  static const double mapPolygonAlpha = 0.3;
  static const int mapTypeBannerDuration = 1200; // milliseconds
  static const int mapFadeDuration = 250; // milliseconds
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
