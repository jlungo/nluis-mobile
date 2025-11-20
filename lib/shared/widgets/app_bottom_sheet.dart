import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';

class AppBottomSheet extends StatelessWidget {
  final String? title;
  final IconData? titleIcon;
  final Widget child;
  final List<Widget>? actions;
  final bool showDragHandle;
  final Color? iconColor;
  final double? maxHeight;
  final EdgeInsets? padding;

  const AppBottomSheet({
    super.key,
    this.title,
    this.titleIcon,
    required this.child,
    this.actions,
    this.showDragHandle = true,
    this.iconColor,
    this.maxHeight,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final effectiveIconColor =
        iconColor ?? (isDark ? AppColors.darkPrimary : AppColors.primary);

    return Container(
      constraints: maxHeight != null
          ? BoxConstraints(maxHeight: maxHeight!)
          : const BoxConstraints(),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusLg),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showDragHandle) _buildDragHandle(isDark),
            if (title != null) _buildHeader(theme, isDark, effectiveIconColor),
            if (title != null)
              Divider(
                height: 1,
                color: isDark ? AppColors.darkDivider : AppColors.divider,
              ),
            Flexible(
              child: Padding(
                padding:
                    padding ??
                        const EdgeInsets.all(AppConstants.spacingLg),
                child: child,
              ),
            ),
            if (actions != null) _buildActions(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildDragHandle(bool isDark) {
    return Container(
      margin: const EdgeInsets.only(top: AppConstants.spacingSm),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color:
            isDark
                ? AppColors.darkTextSecondary.withValues(alpha: 0.3)
                : AppColors.textSecondary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.spacingLg,
        AppConstants.spacingMd,
        AppConstants.spacingLg,
        AppConstants.spacingMd,
      ),
      child: Row(
        children: [
          if (titleIcon != null) ...[
            Icon(
              titleIcon,
              color: iconColor,
              size: 24,
            ),
            const SizedBox(width: AppConstants.spacingSm),
          ],
          Expanded(
            child: Text(
              title!,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color:
                    isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkDivider : AppColors.divider,
          ),
        ),
      ),
      child: Row(
        children: actions!
            .map((action) => Expanded(child: action))
            .toList()
            .fold<List<Widget>>(
              [],
              (list, widget) {
                if (list.isNotEmpty) {
                  list.add(const SizedBox(width: AppConstants.spacingSm));
                }
                list.add(widget);
                return list;
              },
            ),
      ),
    );
  }

  /// Helper method to show bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    IconData? titleIcon,
    List<Widget>? actions,
    bool showDragHandle = true,
    Color? iconColor,
    double? maxHeight,
    EdgeInsets? padding,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AppBottomSheet(
          title: title,
          titleIcon: titleIcon,
          actions: actions,
          showDragHandle: showDragHandle,
          iconColor: iconColor,
          maxHeight: maxHeight,
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
