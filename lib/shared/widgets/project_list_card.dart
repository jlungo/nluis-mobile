import 'package:flutter/material.dart';
import 'package:nluis_app/shared/widgets/badge_chip.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../models/project.dart';

class ProjectListCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;
  final VoidCallback? onMoreTap;
  final VoidCallback? onDownload;
  final VoidCallback? onUpload;
  final bool isDownloaded;
  final IconData? icon;

  const ProjectListCard({
    super.key,
    required this.project,
    required this.onTap,
    this.onMoreTap,
    this.onDownload,
    this.onUpload,
    this.isDownloaded = false,
    this.icon,
  });

  Color _getStatusColor(String status, bool isDark) {
    switch (status.toLowerCase()) {
      case 'completed':
        return isDark ? AppColors.successDark : AppColors.success;
      case 'in process':
        return isDark ? AppColors.infoDark : AppColors.info;
      case 'on hold':
        return isDark ? AppColors.errorDark : AppColors.error;
      case 'pending':
      case 'unknown':
      default:
        return isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingSm),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color:
              isDark
                  ? AppColors.darkDivider
                  : AppColors.divider.withValues(alpha: 0.5),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            child: Row(
              children: [
                // Icon with download indicator
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppConstants.spacingMd),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors:
                              isDark
                                  ? [
                                    AppColors.darkPrimary,
                                    AppColors.darkPrimaryDark,
                                  ]
                                  : [AppColors.primary, AppColors.primaryDark],
                        ),
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusSm,
                        ),
                      ),
                      child: Icon(
                        icon ?? Icons.description_outlined,
                        color:
                            isDark ? AppColors.darkTextInverse : Colors.white,
                        size: 24,
                      ),
                    ),
                    // Download indicator badge
                    if (isDownloaded)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  isDark ? AppColors.darkSurface : Colors.white,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.cloud_done,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: AppConstants.spacingMd),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color:
                              isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (project.organization.isNotEmpty) ...[
                        Text(
                          project.organization,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color:
                                isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color:
                                isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            project.authorizationDate,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: AppConstants.spacingMd),
                          Icon(
                            Icons.show_chart,
                            size: 14,
                            color:
                                isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${project.progress.toStringAsFixed(1)}%',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          BadgeChip(
                            color: _getStatusColor(project.status, isDark),
                            label: project.status,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Action menu dropdown
                if (onDownload != null || onUpload != null || onMoreTap != null)
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color:
                          isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusSm,
                      ),
                    ),
                    onSelected: (value) {
                      if (value == 'download' && onDownload != null) {
                        onDownload!();
                      } else if (value == 'upload' && onUpload != null) {
                        onUpload!();
                      } else if (value == 'more' && onMoreTap != null) {
                        onMoreTap!();
                      }
                    },
                    itemBuilder:
                        (context) => [
                          if (!isDownloaded && onDownload != null)
                            PopupMenuItem(
                              value: 'download',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.cloud_download_outlined,
                                    size: 20,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: AppConstants.spacingSm),
                                  Text(
                                    'Pakua Data',
                                    style: TextStyle(
                                      color:
                                          isDark
                                              ? AppColors.darkTextPrimary
                                              : AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (isDownloaded && onUpload != null)
                            PopupMenuItem(
                              value: 'upload',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 20,
                                    color: AppColors.success,
                                  ),
                                  const SizedBox(width: AppConstants.spacingSm),
                                  Text(
                                    'Pakia Dodoso',
                                    style: TextStyle(
                                      color:
                                          isDark
                                              ? AppColors.darkTextPrimary
                                              : AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (onMoreTap != null)
                            PopupMenuItem(
                              value: 'more',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 20,
                                    color:
                                        isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: AppConstants.spacingSm),
                                  Text(
                                    'Maelezo',
                                    style: TextStyle(
                                      color:
                                          isDark
                                              ? AppColors.darkTextPrimary
                                              : AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
