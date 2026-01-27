import 'package:flutter/material.dart';
import '../models/survey_item.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';

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
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.spacingSm,
        vertical: AppConstants.spacingXs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.12),
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;

  const MetaItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Container(
      padding: EdgeInsets.symmetric(
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

class SurveyCard extends StatelessWidget {
  final SurveyItem survey;
  final String? projectName;
  final bool isDark;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback? onRetry;
  final double? uploadProgress;

  const SurveyCard({
    super.key,
    required this.survey,
    this.projectName,
    required this.isDark,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onTap,
    required this.onLongPress,
    this.onRetry,
    this.uploadProgress,
  });

  bool get canBeSelected {
    if (survey.isDraft) return false;
    return survey.uploadStatus == UploadStatus.failure ||
        (survey.isDirty && survey.uploadStatus == UploadStatus.idle);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color statusColor;
    IconData statusIcon;

    if (survey.isDraft) {
      statusColor = AppColors.warning;
      statusIcon = Icons.drafts;
    } else {
      switch (survey.uploadStatus) {
        case UploadStatus.success:
          statusColor = AppColors.success;
          statusIcon = Icons.cloud_done;
          break;
        case UploadStatus.failure:
          statusColor = AppColors.error;
          statusIcon = Icons.error_outline;
          break;
        case UploadStatus.uploading:
          statusColor = AppColors.info;
          statusIcon = Icons.cloud_upload;
          break;
        case UploadStatus.idle:
          statusColor = survey.isDirty ? AppColors.info : AppColors.success;
          statusIcon =
              survey.isDirty ? Icons.pending_outlined : Icons.check_circle;
      }
    }

    Widget buildStatusIndicator() {
      if (survey.isDraft) {
        return StatusChip(label: 'Rasimu', color: statusColor, isDark: isDark);
      }

      if (survey.uploadStatus == UploadStatus.uploading) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'Inapakia...',
              style: theme.textTheme.bodySmall?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      }

      if (survey.uploadStatus == UploadStatus.failure) {
        return StatusChip(
          label: 'Imeshindwa',
          color: statusColor,
          isDark: isDark,
        );
      }

      if (survey.uploadStatus == UploadStatus.success ||
          (!survey.isDraft && !survey.isDirty)) {
        return StatusChip(
          label: 'Imepakiwa',
          color: statusColor,
          isDark: isDark,
        );
      }

      if (survey.isDirty) {
        return StatusChip(
          label: 'Inasubiri kupakia',
          color: statusColor,
          isDark: isDark,
        );
      }

      return const SizedBox.shrink();
    }

    final borderColor =
        isSelected
            ? AppColors.primary
            : isDark
            ? AppColors.darkTextSecondary.withValues(alpha: 0.3)
            : AppColors.textSecondary.withValues(alpha: 0.2);

    final cardColor = isDark ? AppColors.darkSurface : Colors.white;

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      elevation: 0,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        side: BorderSide(color: borderColor, width: isSelected ? 2 : 1),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (isSelectionMode && canBeSelected)
                    Container(
                      margin: const EdgeInsets.only(
                        right: AppConstants.spacingSm,
                      ),
                      child: Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color:
                            isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                        size: 24,
                      ),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          survey.questionnaireName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color:
                                isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                          ),
                        ),
                        if (projectName != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            projectName!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(statusIcon, color: statusColor, size: 24),
                ],
              ),
              const SizedBox(height: AppConstants.spacingSm),
              buildStatusIndicator(),
              const SizedBox(height: AppConstants.spacingSm),
              Row(
                children: [
                  MetaItem(
                    icon: Icons.description_outlined,
                    label: '${survey.formsCount} fomu',
                    isDark: isDark,
                  ),
                  const SizedBox(width: AppConstants.spacingSm),
                  MetaItem(
                    icon: Icons.access_time,
                    label: survey.savedDate,
                    isDark: isDark,
                  ),
                ],
              ),
              if (survey.lastError != null) ...[
                const SizedBox(height: AppConstants.spacingSm),
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacingSm),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 16,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          survey.lastError!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                      if (onRetry != null)
                        TextButton(
                          onPressed: onRetry,
                          child: const Text('Jaribu tena'),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
