import 'package:flutter/material.dart';

import '../../../constants/app_constants.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/responsive_utils.dart';
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
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing(context, AppConstants.spacingSm),
        vertical: ResponsiveUtils.spacing(context, AppConstants.spacingXs),
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
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing(context, AppConstants.spacingSm),
        vertical: ResponsiveUtils.spacing(context, 6),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: ResponsiveUtils.iconSize(context, 14), color: color),
          SizedBox(width: ResponsiveUtils.spacing(context, 4)),
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
  });

  /// Check if survey can be selected (complete + waiting for upload or failed)
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
      onLongPress: canBeSelected ? onLongPress : null,
      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: ResponsiveUtils.spacing(context, AppConstants.spacingSm)),
        padding: EdgeInsets.all(ResponsiveUtils.spacing(context, AppConstants.spacingMd)),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : AppColors.primary.withValues(alpha: 0.08))
              : (isDark ? AppColors.darkSurface : Colors.white),
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: isDark
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
            // Selection indicator (WhatsApp style)
            if (isSelectionMode && canBeSelected)
              Padding(
                padding: EdgeInsets.only(right: ResponsiveUtils.spacing(context, AppConstants.spacingSm)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: ResponsiveUtils.spacing(context, 24),
                  height: ResponsiveUtils.spacing(context, 24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? AppColors.primary
                        : (isDark
                            ? AppColors.darkSurface
                            : Colors.grey.shade200),
                    border: isSelected
                        ? null
                        : Border.all(
                            color: isDark
                                ? Colors.grey.shade600
                                : Colors.grey.shade400,
                            width: 2,
                          ),
                  ),
                  child: isSelected
                      ? Icon(Icons.check, size: ResponsiveUtils.iconSize(context, 16), color: Colors.white)
                      : null,
                ),
              ),
            Container(
              width: ResponsiveUtils.spacing(context, 40),
              height: ResponsiveUtils.spacing(context, 40),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
              child: Icon(statusIcon, color: statusColor, size: ResponsiveUtils.iconSize(context, 22)),
            ),
            SizedBox(width: ResponsiveUtils.spacing(context, AppConstants.spacingSm)),
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
                  SizedBox(height: ResponsiveUtils.spacing(context, AppConstants.spacingXs)),
                  Wrap(
                    spacing: AppConstants.spacingSm,
                    runSpacing: AppConstants.spacingXs,
                    children: [
                      if (projectName != null)
                        _MetaItem(
                          icon: Icons.folder_outlined,
                          label: projectName!,
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
                      padding: EdgeInsets.only(
                        top: ResponsiveUtils.spacing(context, AppConstants.spacingXs),
                      ),
                      child: Text(
                        survey.lastError!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  // if (survey.uploadStatus == UploadStatus.failure &&
                  //     onRetry != null)
                  //   Padding(
                  //     padding: const EdgeInsets.only(
                  //       top: AppConstants.spacingXs,
                  //     ),
                  //     child: TextButton(
                  //       onPressed: onRetry,
                  //       style: TextButton.styleFrom(
                  //         padding: EdgeInsets.zero,
                  //         minimumSize: const Size(0, 0),
                  //         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //       ),
                  //       child: const Text('Jaribu tena'),
                  //     ),
                  //   ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
