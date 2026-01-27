import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../../features/projects/domain/entities/project.dart';
import '../utils/responsive_utils.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.spacing(context, AppConstants.spacingSm)),
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
            padding: EdgeInsets.all(ResponsiveUtils.spacing(context, AppConstants.spacingMd)),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    if (isDownloaded)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          padding: EdgeInsets.all(ResponsiveUtils.spacing(context, 4)),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  isDark ? AppColors.darkSurface : Colors.white,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.cloud_done,
                            size: ResponsiveUtils.iconSize(context, 12),
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: ResponsiveUtils.spacing(context, AppConstants.spacingMd)),
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
                      SizedBox(height: ResponsiveUtils.spacing(context, 4)),
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
                        SizedBox(height: ResponsiveUtils.spacing(context, 4)),
                      ],
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: ResponsiveUtils.iconSize(context, 14),
                            color:
                                isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                          ),
                          SizedBox(width: ResponsiveUtils.spacing(context, 4)),
                          Text(
                            project.authorizationDate,
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
                  ),
                ),
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
                                    size: ResponsiveUtils.iconSize(context, 20),
                                    color: AppColors.primary,
                                  ),
                                  SizedBox(width: ResponsiveUtils.spacing(context, AppConstants.spacingSm)),
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
                                    size: ResponsiveUtils.iconSize(context, 20),
                                    color: AppColors.success,
                                  ),
                                  SizedBox(width: ResponsiveUtils.spacing(context, AppConstants.spacingSm)),
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
                                    size: ResponsiveUtils.iconSize(context, 20),
                                    color:
                                        isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.textSecondary,
                                  ),
                                  SizedBox(width: ResponsiveUtils.spacing(context, AppConstants.spacingSm)),
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
