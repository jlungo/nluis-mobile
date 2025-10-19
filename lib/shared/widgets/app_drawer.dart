import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final authState = ref.watch(authStateProvider);
    final user = authState.valueOrNull;

    final goRouter = GoRouter.maybeOf(context);
    final location =
        goRouter?.routeInformationProvider.value.uri.toString() ?? '';

    bool matchesLocation(String path) => location.startsWith(path);

    final isOnSwitchboard = location == '/module-switch';
    final isOnDashboard = matchesLocation('/module/land-use/dashboard');
    final isOnProjects =
        matchesLocation('/module/land-use/projects') ||
        matchesLocation('/module/land-use/survey') ||
        matchesLocation('/module/land-use/zoning');
    final isOnDrafts = matchesLocation('/drafts');
    final isOnSettings = matchesLocation('/settings');
    final isOnNotifications = matchesLocation('/notifications');

    return Drawer(
      backgroundColor:
          isDark ? AppColors.darkSurface : theme.colorScheme.surface,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors:
                    isDark
                        ? [AppColors.darkPrimary, AppColors.darkPrimaryDark]
                        : [AppColors.primary, AppColors.primaryDark],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/logo/nlupc_logo.png',
                      width: 75,
                      height: 75,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                  // User Name
                  Text(
                    user?.organization?.name ?? 'User',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: isDark ? AppColors.darkTextInverse : Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.role?.name ?? 'User',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          isDark
                              ? AppColors.darkTextInverse
                              : Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                vertical: AppConstants.spacingMd,
              ),
              children: [
                _DrawerMenuItem(
                  icon: Icons.home_outlined,
                  label: 'Switchboard',
                  isSelected: isOnSwitchboard,
                  onTap: () {
                    Navigator.pop(context);
                    context.goNamed('moduleSwitch');
                  },
                ),
                _DrawerMenuItem(
                  icon: Icons.dashboard_outlined,
                  label: 'Dashboard',
                  isSelected: isOnDashboard,
                  onTap: () {
                    Navigator.pop(context);
                    context.goNamed('luDashboard');
                  },
                ),
                _DrawerMenuItem(
                  icon: Icons.folder_outlined,
                  label: 'My Projects',
                  isSelected: isOnProjects,
                  onTap: () {
                    Navigator.pop(context);
                    context.goNamed('luProjects');
                  },
                ),
                _DrawerMenuItem(
                  icon: Icons.description_outlined,
                  label: 'Madodoso',
                  isSelected: isOnDrafts,
                  onTap: () {
                    Navigator.pop(context);
                    context.goNamed('drafts');
                  },
                ),
                _DrawerMenuItem(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  isSelected: isOnSettings,
                  onTap: () {
                    Navigator.pop(context);
                    context.goNamed('settings');
                  },
                ),
                _DrawerMenuItem(
                  icon: Icons.notifications_outlined,
                  label: 'Notifications',
                  badge: '1',
                  isSelected: isOnNotifications,
                  onTap: () {
                    Navigator.pop(context);
                    context.goNamed('notifications');
                  },
                ),
              ],
            ),
          ),

          Container(
            margin: const EdgeInsets.all(AppConstants.spacingLg),
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color:
                  isDark
                      ? AppColors.darkPrimary.withValues(alpha: 0.1)
                      : AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(
                color:
                    isDark
                        ? AppColors.darkPrimary.withValues(alpha: 0.3)
                        : AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors:
                          isDark
                              ? [
                                AppColors.darkPrimary,
                                AppColors.darkPrimaryDark,
                              ]
                              : [AppColors.primary, AppColors.primaryDark],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      user != null ? user.firstName[0].toUpperCase() : 'U',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color:
                            isDark ? AppColors.darkTextInverse : Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${user?.firstName ?? 'User'} ${user?.lastName ?? ''}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color:
                              isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        user?.role?.name ?? '',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color:
                              isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? badge;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerMenuItem({
    required this.icon,
    required this.label,
    this.badge,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color:
            isSelected
                ? (isDark
                    ? AppColors.darkPrimary.withValues(alpha: 0.15)
                    : AppColors.primary.withValues(alpha: 0.1))
                : Colors.transparent,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color:
              isSelected
                  ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                  : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary),
        ),
        title: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color:
                isSelected
                    ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                    : (isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary),
          ),
        ),
        trailing:
            badge != null
                ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors:
                          isDark
                              ? [AppColors.successDark, AppColors.successDark]
                              : [AppColors.success, AppColors.success],
                    ),
                    borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                  ),
                  child: Text(
                    badge!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                )
                : null,
      ),
    );
  }
}
