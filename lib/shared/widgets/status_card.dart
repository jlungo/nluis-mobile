import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../utils/responsive_utils.dart';

class StatusCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? statusLabel;
  final Color statusColor;
  final String? updatedAt;
  final String? uploadedAt;
  final int? completedCount;
  final int? totalCount;
  final bool showProgress;
  final bool showProgressBar;
  final VoidCallback onTap;
  final bool isDark;

  const StatusCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.statusLabel,
    required this.statusColor,
    this.updatedAt,
    this.uploadedAt,
    this.completedCount,
    this.totalCount,
    this.showProgress = false,
    this.showProgressBar = false,
    required this.onTap,
    required this.isDark,
  });

  double get _progress {
    if (totalCount == null || totalCount == 0 || completedCount == null) {
      return 0;
    }
    return completedCount! / totalCount!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      // margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color:
              isDark
                  ? AppColors.darkDivider.withValues(alpha: 0.5)
                  : AppColors.divider.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color:
                                  isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (statusLabel != null) ...[
                      const SizedBox(width: AppConstants.spacingSm),
                      StatusChip(
                        label: statusLabel!,
                        color: statusColor,
                        isDark: isDark,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppConstants.spacingSm),
                if (uploadedAt == null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: ResponsiveUtils.iconSize(context, 16),
                        color:
                            isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        updatedAt ?? '',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color:
                              isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
                if (uploadedAt != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.cloud_upload_rounded,
                        size: ResponsiveUtils.iconSize(context, 16),
                        color:
                            isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Uploaded $uploadedAt',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color:
                              isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
                if (showProgress && totalCount != null && totalCount! > 0) ...[
                  const SizedBox(height: AppConstants.spacingMd),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showProgressBar)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: _progress,
                            minHeight: 8,
                            backgroundColor:
                                isDark
                                    ? AppColors.darkDivider
                                    : AppColors.divider.withValues(alpha: 0.4),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              statusColor,
                            ),
                          ),
                        ),
                      if (showProgressBar) const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$completedCount/$totalCount completed',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${(_progress * 100).toStringAsFixed(0)}%',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Status chip for consistent status display
class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isDark;

  const StatusChip({
    super.key,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.15)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.5 : 0.3),
          width: 1.5,
        ),
      ),
      child: Builder(
        builder: (context) {
          return Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
              fontSize: ResponsiveUtils.fontSize(context, 11),
            ),
          );
        },
      ),
    );
  }
}
