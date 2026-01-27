import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';

class FormProgressIndicator extends StatelessWidget {
  final double progress;
  final bool isDark;
  final bool showPercentage;

  const FormProgressIndicator({
    super.key,
    required this.progress,
    required this.isDark,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressValue = progress / 100;
    final progressColor = _getProgressColor();

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.assignment_outlined,
                size: 20,
                color:
                    isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
              const SizedBox(width: AppConstants.spacingSm),
              Text(
                'Maendeleo ya Fomu',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              if (showPercentage)
                Text(
                  '${progress.toStringAsFixed(0)}%',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: progressColor,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            child: LinearProgressIndicator(
              value: progressValue,
              backgroundColor: isDark
                  ? AppColors.darkDivider
                  : AppColors.divider.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 8,
            ),
          ),
          if (progress < 100) ...[
            const SizedBox(height: AppConstants.spacingXs),
            Text(
              progress < 50
                  ? 'Endelea kujaza sehemu zinazohitajika'
                  : 'Karibu kukamilika!',
              style: theme.textTheme.bodySmall?.copyWith(
                color:
                    isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
          ] else ...[
            const SizedBox(height: AppConstants.spacingXs),
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: progressColor,
                ),
                const SizedBox(width: 4),
                Text(
                  'Fomu zimekamilika!',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: progressColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getProgressColor() {
    if (progress < 30) {
      return isDark ? AppColors.errorDark : AppColors.error;
    } else if (progress < 70) {
      return isDark ? AppColors.warningDark : AppColors.warning;
    } else if (progress < 100) {
      return isDark ? AppColors.infoDark : AppColors.info;
    } else {
      return isDark ? AppColors.successDark : AppColors.success;
    }
  }
}
