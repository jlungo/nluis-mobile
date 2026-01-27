import 'package:flutter/material.dart';

/// Utility class for responsive design across different screen sizes
class ResponsiveUtils {
  // Breakpoints
  static const double breakpointXs = 360;
  static const double breakpointSm = 600;
  static const double breakpointMd = 900;
  static const double breakpointLg = 1200;
  static const double breakpointXl = 1536;

  /// Check if current screen is a small mobile device
  static bool isXsMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < breakpointXs;

  /// Check if current screen is a mobile device
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < breakpointSm;

  /// Check if current screen is a tablet device
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= breakpointSm &&
      MediaQuery.of(context).size.width < breakpointLg;

  /// Check if current screen is a desktop device
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= breakpointLg;

  /// Get screen width
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  /// Get screen height
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  /// Get responsive font size based on screen width
  static double fontSize(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    if (width < breakpointXs) return baseSize * 0.85;
    if (width < breakpointSm) return baseSize;
    if (width < breakpointMd) return baseSize * 1.1;
    if (width < breakpointLg) return baseSize * 1.15;
    return baseSize * 1.2;
  }

  /// Get responsive spacing based on screen width
  static double spacing(BuildContext context, double baseSpacing) {
    final width = MediaQuery.of(context).size.width;
    if (width < breakpointXs) return baseSpacing * 0.8;
    if (width < breakpointSm) return baseSpacing;
    if (width < breakpointMd) return baseSpacing * 1.2;
    if (width < breakpointLg) return baseSpacing * 1.4;
    return baseSpacing * 1.5;
  }

  /// Get responsive icon size based on screen width
  static double iconSize(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    if (width < breakpointXs) return baseSize * 0.85;
    if (width < breakpointSm) return baseSize;
    if (width < breakpointMd) return baseSize * 1.15;
    return baseSize * 1.25;
  }

  /// Get responsive padding based on screen width
  static EdgeInsets padding(BuildContext context, EdgeInsets basePadding) {
    final width = MediaQuery.of(context).size.width;
    double factor;
    if (width < breakpointXs) {
      factor = 0.8;
    } else if (width < breakpointSm) {
      factor = 1.0;
    } else if (width < breakpointMd) {
      factor = 1.2;
    } else if (width < breakpointLg) {
      factor = 1.4;
    } else {
      factor = 1.5;
    }
    return EdgeInsets.only(
      left: basePadding.left * factor,
      right: basePadding.right * factor,
      top: basePadding.top * factor,
      bottom: basePadding.bottom * factor,
    );
  }

  /// Get number of grid columns based on screen width
  static int gridColumns(BuildContext context, {int mobileColumns = 2}) {
    final width = MediaQuery.of(context).size.width;
    if (width < breakpointSm) return mobileColumns;
    if (width < breakpointMd) return mobileColumns + 1;
    if (width < breakpointLg) return mobileColumns + 2;
    return mobileColumns + 3;
  }

  /// Get grid aspect ratio based on screen width
  static double gridAspectRatio(BuildContext context, {double baseRatio = 1.0}) {
    final width = MediaQuery.of(context).size.width;
    if (width < breakpointXs) return baseRatio * 0.9;
    if (width < breakpointSm) return baseRatio;
    if (width < breakpointMd) return baseRatio * 1.1;
    return baseRatio * 1.2;
  }

  /// Get responsive value based on screen type
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile;
    if (isTablet(context)) return tablet ?? mobile;
    return mobile;
  }

  /// Get responsive width percentage
  static double widthPercent(BuildContext context, double percent) =>
      MediaQuery.of(context).size.width * (percent / 100);

  /// Get responsive height percentage
  static double heightPercent(BuildContext context, double percent) =>
      MediaQuery.of(context).size.height * (percent / 100);

  /// Check if device is in landscape orientation
  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  /// Check if device is in portrait orientation
  static bool isPortrait(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  /// Get safe area paddings
  static EdgeInsets safeAreaPadding(BuildContext context) =>
      MediaQuery.of(context).padding;

  /// Get bottom sheet height based on screen size
  static double bottomSheetHeight(BuildContext context, {double factor = 0.7}) {
    final height = MediaQuery.of(context).size.height;
    if (isTablet(context) || isDesktop(context)) {
      return height * (factor * 0.8);
    }
    return height * factor;
  }

  /// Get dialog width based on screen size
  static double dialogWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < breakpointSm) return width * 0.9;
    if (width < breakpointMd) return width * 0.7;
    if (width < breakpointLg) return width * 0.5;
    return 600;
  }
}

/// Extension methods for responsive sizing
extension ResponsiveExtension on num {
  /// Responsive font size
  double rFontSize(BuildContext context) =>
      ResponsiveUtils.fontSize(context, toDouble());

  /// Responsive spacing
  double rSpacing(BuildContext context) =>
      ResponsiveUtils.spacing(context, toDouble());

  /// Responsive icon size
  double rIconSize(BuildContext context) =>
      ResponsiveUtils.iconSize(context, toDouble());

  /// Width percentage
  double wp(BuildContext context) =>
      ResponsiveUtils.widthPercent(context, toDouble());

  /// Height percentage
  double hp(BuildContext context) =>
      ResponsiveUtils.heightPercent(context, toDouble());
}
