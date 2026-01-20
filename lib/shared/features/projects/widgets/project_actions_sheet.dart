import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/responsive_utils.dart';
import '../../../widgets/action_menu_item.dart';
import '../../../models/project.dart';

/// An action item for the project actions bottom sheet
class ProjectAction {
  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;

  const ProjectAction({
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
  });
}

/// Shows a bottom sheet with project actions
void showProjectActionsSheet({
  required BuildContext context,
  required Project project,
  required List<ProjectAction> actions,
}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppConstants.radiusXl),
          topRight: Radius.circular(AppConstants.radiusXl),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: ResponsiveUtils.spacing(context, AppConstants.spacingMd)),
            Center(
              child: Container(
                width: ResponsiveUtils.spacing(context, 40),
                height: ResponsiveUtils.spacing(context, 4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkDivider : AppColors.divider,
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
              ),
            ),
            SizedBox(height: ResponsiveUtils.spacing(context, AppConstants.spacingLg)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.spacing(context, AppConstants.spacingLg)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.spacing(context, AppConstants.spacingSm)),
                  Text(
                    'Choose an action',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveUtils.spacing(context, AppConstants.spacingLg)),
            if (actions.isNotEmpty)
              ...actions.map(
                (action) => ActionMenuItem(
                  icon: action.icon,
                  label: action.label,
                  description: action.description,
                  onTap: () {
                    Navigator.pop(context);
                    action.onTap();
                  },
                ),
              )
            else
              Padding(
                padding: EdgeInsets.all(ResponsiveUtils.spacing(context, AppConstants.spacingLg)),
                child: Text(
                  'No actions available for this project',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ),
              ),
            SizedBox(height: ResponsiveUtils.spacing(context, AppConstants.spacingLg)),
          ],
        ),
      ),
    ),
  );
}
