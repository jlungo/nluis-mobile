import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth/auth_state.dart';
import '../../features/auth/presentation/bloc/auth/auth_event.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../utils/responsive_utils.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final authState = context.watch<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;

    final goRouter = GoRouter.maybeOf(context);
    final location =
        goRouter?.routeInformationProvider.value.uri.toString() ?? '';

    final isOnSwitchboard = location == '/module-switchboard';

    return Drawer(
      backgroundColor:
          isDark ? AppColors.darkSurface : theme.colorScheme.surface,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(
              ResponsiveUtils.spacing(context, AppConstants.spacingLg),
            ),
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
                    child: Icon(
                      Icons.account_circle,
                      size: ResponsiveUtils.spacing(context, 75),
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      AppConstants.spacingMd,
                    ),
                  ),
                  Text(
                    '${user?.firstName ?? 'User'} ${user?.lastName ?? ''}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: isDark ? AppColors.darkTextInverse : Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.spacing(context, 4)),
                  Text(
                    user?.email ?? '',
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

          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveUtils.spacing(
                  context,
                  AppConstants.spacingMd,
                ),
              ),
              children: [
                _DrawerMenuItem(
                  icon: Icons.apps_outlined,
                  label: 'Switchboard',
                  isSelected: isOnSwitchboard,
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/module-switchboard');
                  },
                ),
                _DrawerMenuItem(
                  icon: Icons.settings_outlined,
                  label: 'Mipangilio',
                  isSelected: location == '/settings',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/settings');
                  },
                ),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.all(
              ResponsiveUtils.spacing(context, AppConstants.spacingMd),
            ),
            child: ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                context.read<AuthBloc>().add(const UserLoggedOut());
                context.go('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                minimumSize: Size(
                  double.infinity,
                  ResponsiveUtils.spacing(context, 48),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout_outlined,
                    size: ResponsiveUtils.iconSize(context, 24),
                  ),
                  SizedBox(
                    width: ResponsiveUtils.spacing(
                      context,
                      AppConstants.spacingSm,
                    ),
                  ),
                  Text(
                    'Logout',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
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
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerMenuItem({
    required this.icon,
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing(context, AppConstants.spacingMd),
        vertical: ResponsiveUtils.spacing(context, 2),
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
      ),
    );
  }
}
