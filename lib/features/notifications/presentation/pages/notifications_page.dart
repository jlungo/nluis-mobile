import 'package:flutter/material.dart';
import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/app_drawer.dart';
import '../../../../shared/utils/snackbar_utils.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Mock notifications
    final notifications = [
      _NotificationItem(
        icon: Icons.info_outline,
        iconColor: AppColors.info,
        title: 'Taarifa za Mfumo',
        message: 'Mfumo utaboreshwa saa 2:00 alfajiri. Huduma zitasimama kwa muda mfupi.',
        timestamp: 'Saa 2 zilizopita',
        isRead: false,
      ),
      _NotificationItem(
        icon: Icons.check_circle_outline,
        iconColor: AppColors.success,
        title: 'Dodoso Limepokelewa',
        message: 'Dodoso lako la Matumizi ya Ardhi ya Makazi limepokelewa kwa mafanikio.',
        timestamp: 'Jana, 3:45 PM',
        isRead: false,
      ),
      _NotificationItem(
        icon: Icons.warning_amber_outlined,
        iconColor: AppColors.warning,
        title: 'Kumbusho',
        message: 'Una dodoso 3 zilizohifadhiwa kama rasimu. Zitatoweshwa baada ya siku 30.',
        timestamp: 'Wiki 1 iliyopita',
        isRead: true,
      ),
    ];

    return Scaffold(
      appBar: const CustomAppBar(hasNotification: false),
      drawer: const AppDrawer(),
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingLg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Taarifa',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      SnackBarUtils.showInfo(
                        context,
                        'Taarifa zote zimesomwa',
                      );
                    },
                    icon: const Icon(Icons.done_all, size: 18),
                    label: const Text('Weka zote zimesomwa'),
                    style: TextButton.styleFrom(
                      foregroundColor: isDark ? AppColors.darkPrimary : AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingLg,
                  vertical: AppConstants.spacingSm,
                ),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return _NotificationCard(
                    notification: notifications[index],
                    isDark: isDark,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String timestamp;
  final bool isRead;

  _NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.isRead,
  });
}

class _NotificationCard extends StatelessWidget {
  final _NotificationItem notification;
  final bool isDark;

  const _NotificationCard({
    required this.notification,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: isDark
            ? (notification.isRead
                ? AppColors.darkSurface
                : AppColors.darkSurfaceVariant)
            : (notification.isRead
                ? Colors.white
                : AppColors.surfaceVariant),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: notification.isRead
              ? Colors.transparent
              : (isDark ? AppColors.darkPrimary.withValues(alpha: 0.3) : AppColors.primary.withValues(alpha: 0.3)),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd,
          vertical: AppConstants.spacingSm,
        ),
        leading: Container(
          padding: const EdgeInsets.all(AppConstants.spacingSm),
          decoration: BoxDecoration(
            color: notification.iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
          ),
          child: Icon(
            notification.icon,
            color: notification.iconColor,
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(left: AppConstants.spacingSm),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppConstants.spacingXs),
            Text(
              notification.message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  notification.timestamp,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          SnackBarUtils.showInfo(
            context,
            'Taarifa: ${notification.title}',
          );
        },
      ),
    );
  }
}
