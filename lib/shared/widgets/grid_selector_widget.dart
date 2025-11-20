import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';

class GridSelectorItem<T> {
  final T value;
  final String title;
  final String? subtitle;
  final Color? color;
  final IconData? icon;

  const GridSelectorItem({
    required this.value,
    required this.title,
    this.subtitle,
    this.color,
    this.icon,
  });
}

class GridSelectorWidget<T> extends StatelessWidget {
  final List<GridSelectorItem<T>> items;
  final T? selectedValue;
  final ValueChanged<T> onSelected;
  final int crossAxisCount;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const GridSelectorWidget({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onSelected,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.5,
    this.crossAxisSpacing = AppConstants.spacingSm,
    this.mainAxisSpacing = AppConstants.spacingSm,
    this.shrinkWrap = true,
    this.physics = const NeverScrollableScrollPhysics(),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = selectedValue == item.value;
        final color = item.color ?? Colors.grey;

        return InkWell(
          onTap: () => onSelected(item.value),
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                      .withValues(alpha: 0.1)
                  : isDark
                      ? AppColors.darkSurface
                      : Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(
                color: isSelected
                    ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                    : (isDark ? AppColors.darkDivider : AppColors.divider),
                width: isSelected ? 2 : 1,
              ),
            ),
            padding: const EdgeInsets.all(AppConstants.spacingSm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    if (item.icon != null)
                      Icon(
                        item.icon,
                        color: color,
                        size: 24,
                      )
                    else
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    const Spacer(),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color:
                            isDark ? AppColors.darkPrimary : AppColors.primary,
                        size: 20,
                      ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingXs),
                Text(
                  item.title,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    fontSize: 13,
                    color:
                        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.subtitle != null && item.subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle!,
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
