import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../utils/responsive_utils.dart';

class ActionMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;

  const ActionMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing(context, AppConstants.spacingLg),
        vertical: ResponsiveUtils.spacing(context, 4),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(ResponsiveUtils.spacing(context, AppConstants.spacingSm)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [AppColors.darkPrimary, AppColors.darkPrimaryDark]
                  : [AppColors.primary, AppColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
          ),
          child: Icon(
            icon,
            color: isDark ? AppColors.darkTextInverse : Colors.white,
          ),
        ),
        title: Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          description,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: ResponsiveUtils.iconSize(context, 16),
          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        ),
        onTap: onTap,
      ),
    );
  }
}
