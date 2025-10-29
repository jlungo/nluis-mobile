import 'package:flutter/material.dart';

import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../models/survey_item.dart';

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
      padding: const EdgeInsets.symmetric(
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


class SurveyCard extends StatelessWidget {
  final SurveyItem survey;
  final String projectName;
  final bool isDark;
  final bool isSelected;
  final Function(bool) onSelectionChanged;
  final VoidCallback onTap;
  final VoidCallback? onRetry;

  const SurveyCard({
    super.key,
    required this.survey,
    required this.projectName,
    required this.isDark,
    required this.isSelected,
    required this.onSelectionChanged,
    required this.onTap,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUploading = survey.uploadStatus == UploadStatus.uploading;
    final canSelect = !survey.isDraft && !isUploading;

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
        return StatusChip(
          label: 'Rasimu',
          color: AppColors.warning,
          isDark: isDark,
        );
      }

      switch (survey.uploadStatus) {
        case UploadStatus.uploading:
          return const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        case UploadStatus.success:
          return StatusChip(
            label: 'Imepakiwa',
            color: AppColors.success,
            isDark: isDark,
          );
        case UploadStatus.failure:
          return StatusChip(
            label: 'Imeshindikana',
            color: AppColors.error,
            isDark: isDark,
          );
        case UploadStatus.idle:
          return StatusChip(
            label: survey.isDirty ? 'Haijapakiwa' : 'Imehifadhiwa',
            color: survey.isDirty ? AppColors.info : AppColors.success,
            isDark: isDark,
          );
      }
    }

    final statusIndicator = buildStatusIndicator();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppConstants.spacingSm),
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border:
              isSelected
                  ? Border.all(color: AppColors.primary, width: 1.6)
                  : null,
          boxShadow: [
            BoxShadow(
              color:
                  isDark
                      ? Colors.black.withValues(alpha: 0.18)
                      : Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 36,
              child:
                  survey.isDraft
                      ? const SizedBox.shrink()
                      : Checkbox(
                        value: isSelected,
                        onChanged:
                            canSelect
                                ? (value) => onSelectionChanged(value ?? false)
                                : null,
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        activeColor: AppColors.primary,
                      ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
              child: Icon(statusIcon, color: statusColor, size: 22),
            ),
            const SizedBox(width: AppConstants.spacingSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          survey.questionnaireName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color:
                                isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      statusIndicator,
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingXs),
                  Wrap(
                    spacing: AppConstants.spacingSm,
                    runSpacing: AppConstants.spacingXs,
                    children: [
                      _MetaItem(
                        icon: Icons.folder_outlined,
                        label: projectName,
                        isDark: isDark,
                      ),
                      _MetaItem(
                        icon: Icons.assignment_outlined,
                        label: '${survey.formsCount} fomu',
                        isDark: isDark,
                      ),
                      _MetaItem(
                        icon: Icons.schedule,
                        label: survey.savedDate,
                        isDark: isDark,
                      ),
                    ],
                  ),
                  if (survey.uploadStatus == UploadStatus.failure &&
                      survey.lastError != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppConstants.spacingXs,
                      ),
                      child: Text(
                        survey.lastError!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  if (survey.uploadStatus == UploadStatus.failure &&
                      onRetry != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppConstants.spacingXs,
                      ),
                      child: TextButton(
                        onPressed: onRetry,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Jaribu tena'),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
