import 'package:flutter/material.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/app_drawer.dart';

class ZoningPage extends StatelessWidget {
  final String projectId;

  const ZoningPage({super.key, required this.projectId});

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
              const SizedBox(height: 24),
              Text(
                'Zoning Basemap',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color:
                      isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'TODO: Ramani itaonyeshwa hapa',
                style: theme.textTheme.bodyLarge?.copyWith(
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
