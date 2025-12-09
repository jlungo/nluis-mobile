import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final bool showNotifications;
  final bool hasNotification;
  final bool showProfile;
  final VoidCallback? onNotificationTap;
  final String? title;
  final String? subtitle;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    this.showNotifications = false,
    this.hasNotification = false,
    this.showBackButton = false,
    this.showProfile = true,
    this.onNotificationTap,
    this.title,
    this.subtitle,
    this.bottom,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final authState = ref.watch(authStateProvider);
    final user = authState.valueOrNull;

    return AppBar(
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      surfaceTintColor: isDark ? AppColors.darkSurface : Colors.white,
      elevation: 0,
      title: title != null
          ? subtitle != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                )
              : Text(
                  title!,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                )
          : null,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(
            showBackButton ? Icons.arrow_back : Icons.menu,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.textPrimary,
          ),
          onPressed: () {
            if (showBackButton) {
              // Always try to pop first for proper back navigation
              context.pop();
            } else {
              Scaffold.of(context).openDrawer();
            }
          },
        ),
      ),
      bottom: bottom,
      actions: [
        if (showNotifications)
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
                onPressed: onNotificationTap ??
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationsPage(),
                        ),
                      );
                    },
              ),
              if (hasNotification)
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkSurface
                            : Colors.white,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        if (showProfile)
          Padding(
            padding: const EdgeInsets.only(right: AppConstants.spacingMd),
            child: CircleAvatar(
              backgroundColor:
                  isDark ? AppColors.darkPrimary : AppColors.primary,
              child: Text(
                user != null ? user.firstName[0].toUpperCase() : 'U',
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextInverse
                      : Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
