import 'package:flutter/material.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/app_drawer.dart';

class SurveyEditPage extends StatelessWidget {
  final String projectId;
  final String responseId;

  const SurveyEditPage({
    super.key,
    required this.projectId,
    required this.responseId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(hasNotification: true),
      drawer: const AppDrawer(),
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.warning.withValues(alpha: 0.1),
                      AppColors.warning.withValues(alpha: 0.05),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.edit_outlined,
                  size: 80,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? AppColors.darkShadow : AppColors.shadow,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _InfoRow(
                      icon: Icons.folder_outlined,
                      label: 'Project',
                      value: projectId,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),
                    Divider(
                      color:
                          isDark
                              ? AppColors.darkDivider.withValues(alpha: 0.5)
                              : AppColors.divider.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.receipt_outlined,
                      label: 'Response',
                      value: responseId,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Fomu ya kuhariri',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Fomu itaonyeshwa hapa',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color:
                      isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color:
                isDark
                    ? AppColors.darkPrimary.withValues(alpha: 0.1)
                    : AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isDark ? AppColors.darkPrimary : AppColors.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:
                      isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
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
    );
  }
}
