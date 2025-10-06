import 'package:flutter/material.dart';
import 'package:nluis_app/shared/widgets/badge_chip.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../models/project.dart';

class ProjectListCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;
  final VoidCallback? onMoreTap;
  final IconData? icon;

  const ProjectListCard({
    super.key,
    required this.project,
    required this.onTap,
    this.onMoreTap,
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
                // Icon
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
                    borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                  ),
                  child: Icon(
                    icon ?? Icons.description_outlined,
                    color: isDark ? AppColors.darkTextInverse : Colors.white,
                    size: 24,
                  ),
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
                // More icon
                if (onMoreTap != null)
                  IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      color:
                          isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                    ),
                    onPressed: onMoreTap,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
