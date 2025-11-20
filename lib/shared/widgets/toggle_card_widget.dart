import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';

class ToggleCardWidget extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String title;
  final String? activeSubtitle;
  final String? inactiveSubtitle;
  final IconData? activeIcon;
  final IconData? inactiveIcon;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool enabled;

  const ToggleCardWidget({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.activeSubtitle,
    this.inactiveSubtitle,
    this.activeIcon,
    this.inactiveIcon,
    this.activeColor,
    this.inactiveColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final effectiveActiveColor = activeColor ??
        (isDark ? AppColors.darkPrimary : AppColors.primary);
    final effectiveInactiveColor = inactiveColor ??
        (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary);

    final currentIcon = value
        ? (activeIcon ?? Icons.check_circle_outline)
        : (inactiveIcon ?? Icons.circle_outlined);
    final currentIconColor = value ? effectiveActiveColor : effectiveInactiveColor;
    
    final subtitle = value
        ? (activeSubtitle ?? '')
        : (inactiveSubtitle ?? '');

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.divider,
        ),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: enabled ? onChanged : null,
        title: Text(title),
        subtitle: subtitle.isNotEmpty
            ? Text(
                subtitle,
                style: theme.textTheme.bodySmall,
              )
            : null,
        secondary: Icon(
          currentIcon,
          color: currentIconColor,
        ),
      ),
    );
  }
}

/// Compact version without the card wrapper
class ToggleWidget extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final bool enabled;

  const ToggleWidget({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.icon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SwitchListTile(
      value: value,
      onChanged: enabled ? onChanged : null,
      title: Text(title),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: theme.textTheme.bodySmall,
            )
          : null,
      secondary: icon != null ? Icon(icon) : null,
    );
  }
}
