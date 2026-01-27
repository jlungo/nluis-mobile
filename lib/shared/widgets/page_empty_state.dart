import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';

class PageEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final bool isDark;
  final Widget? action;

  const PageEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.isDark,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: isDark
                  ? AppColors.darkTextSecondary.withValues(alpha: 0.5)
                  : AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppConstants.spacingLg),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: AppConstants.spacingXl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
