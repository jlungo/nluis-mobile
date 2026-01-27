import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth/auth_state.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../utils/responsive_utils.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final bool showNotifications;
  final bool hasNotification;
  final bool showProfile;
  final VoidCallback? onNotificationTap;
  final String? title;
  final String? subtitle;
  final PreferredSizeWidget? bottom;
  final Widget? leading;
  final List<Widget>? actions;

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
    this.leading,
    this.actions,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final authState = context.watch<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;

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
      automaticallyImplyLeading: false,
      leading: leading ??
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                showBackButton ? Icons.arrow_back : Icons.menu,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
              onPressed: () {
                if (showBackButton) {
                  context.pop();
                } else {
                  Scaffold.of(context).openDrawer();
                }
              },
            ),
          ),
      actions: actions ??
          [
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
                    onPressed: onNotificationTap,
                  ),
                  if (hasNotification)
                    Positioned(
                      right: ResponsiveUtils.spacing(context, 10),
                      top: ResponsiveUtils.spacing(context, 10),
                      child: Container(
                        width: ResponsiveUtils.spacing(context, 8),
                        height: ResponsiveUtils.spacing(context, 8),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? AppColors.darkSurface : Colors.white,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            if (showProfile)
              Padding(
                padding: EdgeInsets.only(
                  right: ResponsiveUtils.spacing(context, AppConstants.spacingMd),
                ),
                child: CircleAvatar(
                  backgroundColor:
                      isDark ? AppColors.darkPrimary : AppColors.primary,
                  child: Text(
                    user != null ? user.firstName[0].toUpperCase() : 'U',
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextInverse : Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
      bottom: bottom,
    );
  }
}
