import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';

class ShimmerLoading {
  ShimmerLoading._();

  static Widget _baseShimmer({
    required Widget child,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final baseColor = isDark ? AppColors.darkSurfaceVariant : Colors.grey[300]!;
    final highlightColor = isDark ? AppColors.darkSurface : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: child,
    );
  }

  static Widget listItem({
    required BuildContext context,
    double height = 80,
    EdgeInsets margin = const EdgeInsets.symmetric(
      horizontal: AppConstants.spacingMd,
      vertical: AppConstants.spacingSm,
    ),
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final containerColor = isDark ? AppColors.darkSurface : AppColors.surface;

    return _baseShimmer(
      context: context,
      child: Container(
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
      ),
    );
  }

  static Widget card({
    required BuildContext context,
    double height = 200,
    EdgeInsets margin = const EdgeInsets.all(AppConstants.spacingMd),
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final containerColor = isDark ? AppColors.darkSurface : AppColors.surface;

    return _baseShimmer(
      context: context,
      child: Container(
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        ),
      ),
    );
  }

  static Widget gridItem({
    required BuildContext context,
    double aspectRatio = 1.2,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final containerColor = isDark ? AppColors.darkSurface : AppColors.surface;

    return _baseShimmer(
      context: context,
      child: Container(
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
      ),
    );
  }

  static Widget textLine({
    required BuildContext context,
    double width = double.infinity,
    double height = 16,
    EdgeInsets margin = EdgeInsets.zero,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final containerColor = isDark ? AppColors.darkSurface : AppColors.surface;

    return _baseShimmer(
      context: context,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        ),
      ),
    );
  }

  static Widget custom({
    required BuildContext context,
    required Widget child,
  }) {
    return _baseShimmer(context: context, child: child);
  }

  static Widget listView({
    required BuildContext context,
    int itemCount = 5,
    double itemHeight = 80,
  }) {
    return ListView.builder(
      itemCount: itemCount,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return listItem(context: context, height: itemHeight);
      },
    );
  }

  static Widget gridView({
    required BuildContext context,
    int itemCount = 6,
    int crossAxisCount = 2,
    double childAspectRatio = 1.2,
  }) {
    return GridView.builder(
      itemCount: itemCount,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppConstants.spacingMd,
        mainAxisSpacing: AppConstants.spacingMd,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        return gridItem(context: context, aspectRatio: childAspectRatio);
      },
    );
  }
}
