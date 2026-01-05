import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/utils/responsive_utils.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/utils/snackbar_utils.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final currentTheme = ref.watch(themeProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final user = authState.valueOrNull;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: const CustomAppBar(
        showBackButton: true,
        title: 'Mipangilio',
        // subtitle: 'Dhibiti programu yako',
        showProfile: false,
        hasNotification: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(
          ResponsiveUtils.spacing(context, AppConstants.spacingLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Section
            _buildSectionTitle(context, 'AKAUNTI'),
            SizedBox(
              height: ResponsiveUtils.spacing(context, AppConstants.spacingSm),
            ),
            _SettingCard(
              theme: theme,
              children: [
                _SettingTile(
                  theme: theme,
                  icon: Icons.person_outline,
                  iconColor: isDark ? AppColors.darkPrimary : AppColors.primary,
                  title: 'Wasifu',
                  subtitle: user?.fullName ?? 'User',
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: ResponsiveUtils.iconSize(context, 16),
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                  ),
                  onTap: () {
                    SnackBarUtils.showInfo(
                      context,
                      'This is feature coming soon.',
                    );
                  },
                ),
                Divider(
                  height: 1,
                  color: isDark ? AppColors.darkDivider : AppColors.divider,
                ),
                _SettingTile(
                  theme: theme,
                  icon: Icons.security_outlined,
                  iconColor: isDark ? AppColors.infoDark : AppColors.info,
                  title: 'Usalama',
                  subtitle: 'Badilisha neno la siri',
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: ResponsiveUtils.iconSize(context, 16),
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                  ),
                  onTap: () {
                    SnackBarUtils.showInfo(
                      context,
                      'This is feature coming soon.',
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: ResponsiveUtils.spacing(context, AppConstants.spacingLg),
            ),

            // Preferences Section
            _buildSectionTitle(context, 'MAPENDELEO'),
            SizedBox(
              height: ResponsiveUtils.spacing(context, AppConstants.spacingSm),
            ),
            _SettingCard(
              theme: theme,
              children: [
                _SettingTile(
                  theme: theme,
                  icon: Icons.language_outlined,
                  iconColor: isDark ? AppColors.successDark : AppColors.success,
                  title: 'Lugha',
                  subtitle: 'Kiswahili',
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: ResponsiveUtils.iconSize(context, 16),
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                  ),
                  onTap: () => _showLanguagePicker(context, ref),
                ),
                Divider(
                  height: 1,
                  color: isDark ? AppColors.darkDivider : AppColors.divider,
                ),
                _SettingTile(
                  theme: theme,
                  icon: Icons.palette_outlined,
                  iconColor: isDark ? AppColors.warningDark : AppColors.warning,
                  title: 'Muonekano',
                  subtitle: currentTheme.label,
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: ResponsiveUtils.iconSize(context, 16),
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                  ),
                  onTap: () => _showThemePicker(context, ref),
                ),
                Divider(
                  height: 1,
                  color: isDark ? AppColors.darkDivider : AppColors.divider,
                ),
                // _SettingTile(
                //   theme: theme,
                //   icon: Icons.notifications_outlined,
                //   iconColor: isDark ? AppColors.infoDark : AppColors.info,
                //   title: 'Arifa',
                //   subtitle: 'Simamia arifa',
                //   trailing: Icon(
                //     Icons.arrow_forward_ios,
                //     size: 16,
                //     color:
                //         isDark
                //             ? AppColors.darkTextSecondary
                //             : AppColors.textSecondary,
                //   ),
                //   onTap: () {
                //     SnackBarUtils.showInfo(
                //       context,
                //       'This is feature coming soon.',
                //     );
                //   },
                // ),
              ],
            ),
            SizedBox(
              height: ResponsiveUtils.spacing(context, AppConstants.spacingLg),
            ),

            // Data Section
            _buildSectionTitle(context, 'DATA'),
            SizedBox(
              height: ResponsiveUtils.spacing(context, AppConstants.spacingSm),
            ),
            _SettingCard(
              theme: theme,
              children: [
                _SettingTile(
                  theme: theme,
                  icon: Icons.settings_applications_outlined,
                  iconColor: isDark ? AppColors.successDark : AppColors.success,
                  title: 'Mipangilio ya Programu',
                  subtitle: 'Mipangilio na data za msingi',
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: ResponsiveUtils.iconSize(context, 16),
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                  ),
                  onTap: () {
                    context.pushNamed('appConfigurations');
                  },
                ),
                Divider(
                  height: 1,
                  color: isDark ? AppColors.darkDivider : AppColors.divider,
                ),
                _SettingTile(
                  theme: theme,
                  icon: Icons.delete_outline,
                  iconColor: isDark ? AppColors.errorDark : AppColors.error,
                  title: 'Clear Storage Data',
                  subtitle: 'Futa data zote zilizohifadhiwa',
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: ResponsiveUtils.iconSize(context, 16),
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                  ),
                  onTap: () => unawaited(_showClearStorageDialog(context, ref)),
                ),
              ],
            ),
            SizedBox(
              height: ResponsiveUtils.spacing(context, AppConstants.spacingLg),
            ),

            // Help Section
            _buildSectionTitle(context, 'MSAADA'),
            SizedBox(
              height: ResponsiveUtils.spacing(context, AppConstants.spacingSm),
            ),
            _SettingCard(
              theme: theme,
              children: [
                _SettingTile(
                  theme: theme,
                  icon: Icons.help_outline,
                  iconColor: isDark ? AppColors.warningDark : AppColors.warning,
                  title: 'Kituo cha Msaada',
                  subtitle: 'Pata msaada na maswali',
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: ResponsiveUtils.iconSize(context, 16),
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                  ),
                  onTap: () {
                    SnackBarUtils.showInfo(
                      context,
                      'This is feature coming soon.',
                    );
                  },
                ),
                Divider(
                  height: 1,
                  color: isDark ? AppColors.darkDivider : AppColors.divider,
                ),
                _SettingTile(
                  theme: theme,
                  icon: Icons.article_outlined,
                  iconColor: isDark ? AppColors.darkPrimary : AppColors.primary,
                  title: 'Kuhusu ${Env.appNameAbbr}',
                  subtitle: 'Toleo ${Env.appVersion}',
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: ResponsiveUtils.iconSize(context, 16),
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                  ),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: Env.appNameAbbr,
                      applicationVersion: Env.appVersion,
                      applicationIcon: Image.asset(
                        'assets/images/logo/nlupc_logo.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                      applicationLegalese: 'NLUIS Test Legal txt',
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: ResponsiveUtils.spacing(context, AppConstants.spacingXl),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
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
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      AppConstants.spacingMd,
                    ),
                  ),
                  Container(
                    width: ResponsiveUtils.spacing(context, 40),
                    height: ResponsiveUtils.spacing(context, 4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkDivider : AppColors.divider,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusSm,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      AppConstants.spacingLg,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingLg,
                    ),
                    child: Text(
                      'Chagua Lugha',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color:
                            isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      AppConstants.spacingLg,
                    ),
                  ),
                  _LanguageOption(
                    theme: theme,
                    label: 'Kiswahili',
                    isSelected: true,
                    onTap: () => Navigator.pop(context),
                  ),
                  _LanguageOption(
                    theme: theme,
                    label: 'English',
                    isSelected: false,
                    onTap: () {
                      Navigator.pop(context);
                      SnackBarUtils.showInfo(
                        context,
                        'This is feature coming soon.',
                      );
                    },
                  ),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      AppConstants.spacingLg,
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing(context, 8),
      ),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color:
              theme.brightness == Brightness.dark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Future<void> _showClearStorageDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    // final result = await ClearStorageBottomSheet.show(context);

    // if (result == true && context.mounted) {
    //   SnackBarUtils.showSuccess(
    //     context,
    //     'Data zilizochaguliwa zimefutwa kamili',
    //   );
    // } else if (result == false && context.mounted) {
    //   SnackBarUtils.showError(
    //     context,
    //     'Hitilafu imetokea wakati wa kufuta data',
    //   );
    // }
  }

  void _showThemePicker(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.read(themeProvider);
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: ResponsiveUtils.spacing(context, 40),
                    height: ResponsiveUtils.spacing(context, 4),
                    decoration: BoxDecoration(
                      color:
                          theme.brightness == Brightness.dark
                              ? AppColors.darkDivider
                              : AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Chagua Mandhari',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...AppThemeMode.values.map((mode) {
                    final isSelected = mode == currentTheme;
                    return _ThemeOptionTile(
                      theme: theme,
                      icon: _getThemeIcon(mode),
                      label: mode.label,
                      isSelected: isSelected,
                      onTap: () {
                        ref.read(themeProvider.notifier).setTheme(mode);
                        Navigator.pop(context);
                      },
                    );
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
    );
  }

  IconData _getThemeIcon(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
      case AppThemeMode.system:
        return Icons.settings_brightness;
    }
  }
}

class _SettingCard extends StatelessWidget {
  final List<Widget> children;
  final ThemeData theme;

  const _SettingCard({required this.children, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                theme.brightness == Brightness.dark
                    ? AppColors.darkShadow
                    : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;
  final ThemeData theme;

  const _SettingTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing(context, 20),
        vertical: ResponsiveUtils.spacing(context, 4),
      ),
      leading: Container(
        padding: EdgeInsets.all(ResponsiveUtils.spacing(context, 10)),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: ResponsiveUtils.iconSize(context, 24),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: ResponsiveUtils.fontSize(context, 16),
          color: theme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color:
              theme.brightness == Brightness.dark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
          fontSize: ResponsiveUtils.fontSize(context, 13),
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;

  const _ThemeOptionTile({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color:
            isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isSelected
                  ? theme.colorScheme.primary
                  : (theme.brightness == Brightness.dark
                      ? AppColors.darkDivider
                      : AppColors.divider),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? theme.colorScheme.primary
                    : (theme.brightness == Brightness.dark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: theme.colorScheme.surface, size: 20),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color:
                isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
          ),
        ),
        trailing:
            isSelected
                ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                : null,
        onTap: onTap,
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;

  const _LanguageOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingLg,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color:
            isSelected
                ? (isDark
                    ? AppColors.darkPrimary.withValues(alpha: 0.15)
                    : AppColors.primary.withValues(alpha: 0.1))
                : Colors.transparent,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color:
              isSelected
                  ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                  : (isDark ? AppColors.darkDivider : AppColors.divider),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        title: Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color:
                isSelected
                    ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                    : (isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary),
          ),
        ),
        trailing:
            isSelected
                ? Icon(
                  Icons.check_circle,
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                )
                : null,
        onTap: onTap,
      ),
    );
  }
}
