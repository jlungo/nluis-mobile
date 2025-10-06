import 'package:flutter/material.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/app_drawer.dart';

class SurveyListPage extends StatelessWidget {
  final String projectId;

  const SurveyListPage({super.key, required this.projectId});

  void _showSurveyTypesSheet(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            builder:
                (context, scrollController) => Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppConstants.radiusXl),
                      topRight: Radius.circular(AppConstants.radiusXl),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: AppConstants.spacingMd),
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color:
                                isDark
                                    ? AppColors.darkDivider
                                    : AppColors.divider,
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusSm,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingLg),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingLg,
                        ),
                        child: Text(
                          'Chagua Aina ya Dodoso',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color:
                                isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingLg),
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          padding: EdgeInsets.zero,
                          children: [
                            _SurveyTypeItem(
                              icon: Icons.map_outlined,
                              label: 'Dodoso la Matumizi ya Ardhi ya Makazi',
                              description:
                                  'Taarifa za matumizi ya ardhi ya makazi ya kaya',
                              onTap: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Inakuja - Dodoso la Makazi'),
                                  ),
                                );
                              },
                            ),
                            _SurveyTypeItem(
                              icon: Icons.agriculture_outlined,
                              label: 'Dodoso la Matumizi ya Ardhi ya Kilimo',
                              description:
                                  'Taarifa za mashamba na shughuli za kilimo',
                              onTap: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Inakuja - Dodoso la Kilimo'),
                                  ),
                                );
                              },
                            ),
                            _SurveyTypeItem(
                              icon: Icons.store_mall_directory_outlined,
                              label: 'Dodoso la Maeneo ya Kibiashara',
                              description:
                                  'Taarifa za vibanda, maduka, minada na biashara ndogondogo',
                              onTap: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Inakuja - Dodoso la Biashara',
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: AppConstants.spacingLg),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

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
                      AppColors.info.withValues(alpha: 0.1),
                      AppColors.info.withValues(alpha: 0.05),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.info.withValues(alpha: 0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.assignment_late_outlined,
                  size: 80,
                  color: AppColors.info,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Hakuna Dodoso Lililojazwa',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Dodoso zitaonyeshwa hapa',
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
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                isDark
                    ? [AppColors.darkPrimary, AppColors.darkPrimaryDark]
                    : [AppColors.primary, AppColors.primaryDark],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color:
                  isDark
                      ? AppColors.darkPrimary.withValues(alpha: 0.4)
                      : AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => _showSurveyTypesSheet(context),
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: Icon(
            Icons.add,
            color: isDark ? AppColors.darkTextInverse : AppColors.textInverse,
          ),
          label: Text(
            'Jaza Dodoso',
            style: TextStyle(
              color: isDark ? AppColors.darkTextInverse : AppColors.textInverse,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _SurveyTypeItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;

  const _SurveyTypeItem({
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
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingLg,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(AppConstants.spacingSm),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:
                  isDark
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
            color:
                isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        ),
        onTap: onTap,
      ),
    );
  }
}
