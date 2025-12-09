import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../data/local/database.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';

class SubdivisionApplicationCard extends StatelessWidget {
  final SubdivisionApplication application;
  final String projectName;
  final String? applicantName;
  final bool isDark;
  final VoidCallback onTap;

  const SubdivisionApplicationCard({
    super.key,
    required this.application,
    required this.projectName,
    this.applicantName,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Determine status
    final isDraft = application.status == 'draft';
    final isCompleted = application.status == 'completed';
    final isUploaded = application.status == 'uploaded';
    
    // Calculate progress
    final totalSteps = 6;
    final currentStep = application.currentStep;
    final progress = currentStep / totalSteps;
    
    // Status color and icon
    Color statusColor;
    IconData statusIcon;
    String statusLabel;
    
    if (isDraft) {
      statusColor = AppColors.warning;
      statusIcon = Icons.edit_note;
      statusLabel = 'Rasimu';
    } else if (isUploaded) {
      statusColor = AppColors.success;
      statusIcon = Icons.cloud_done;
      statusLabel = 'Imepakiwa';
    } else if (isCompleted) {
      statusColor = AppColors.info;
      statusIcon = Icons.check_circle;
      statusLabel = 'Imekamilika';
    } else {
      statusColor = AppColors.info;
      statusIcon = Icons.pending;
      statusLabel = 'Inaendelea';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      color: isDark ? AppColors.darkSurface : Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        side: BorderSide(
          color: isDark ? AppColors.darkDivider : AppColors.divider,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with status
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingSm),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: isDark ? 0.2 : 0.12),
                      borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                    ),
                    child: Icon(
                      statusIcon,
                      color: statusColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingSm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          applicantName ?? 'Mwombaji',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          projectName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingSm,
                      vertical: AppConstants.spacingXs,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: isDark ? 0.2 : 0.12),
                      borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                    ),
                    child: Text(
                      statusLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppConstants.spacingMd),
              
              // Progress indicator for draft applications
              if (isDraft) ...[
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: (isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary)
                              .withValues(alpha: 0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingSm),
                    Text(
                      'Hatua $currentStep/$totalSteps',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingMd),
              ],
              
              // Meta information
              Wrap(
                spacing: AppConstants.spacingSm,
                runSpacing: AppConstants.spacingSm,
                children: [
                  _MetaItem(
                    icon: Icons.calendar_today,
                    label: _formatDate(application.createdAt),
                    isDark: isDark,
                  ),
                  if (isUploaded && application.uploadedAt != null)
                    _MetaItem(
                      icon: Icons.cloud_upload,
                      label: 'Ilipakiwa ${_formatDate(application.uploadedAt!)}',
                      isDark: isDark,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('d MMM yyyy').format(date);
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;

  const _MetaItem({
    required this.icon,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingSm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
