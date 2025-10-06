import 'package:flutter/material.dart';

class CustomSliverAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool floating;
  final bool pinned;
  final bool snap;
  final double expandedHeight;
  final Widget? flexibleSpace;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const CustomSliverAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.floating = false,
    this.pinned = true,
    this.snap = false,
    this.expandedHeight = 120.0,
    this.flexibleSpace,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      title: Text(title),
      actions: actions,
      leading: leading,
      floating: floating,
      pinned: pinned,
      snap: snap,
      expandedHeight: expandedHeight,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      flexibleSpace: flexibleSpace,
      elevation: 0,
      centerTitle: true,
    );
  }
}

/// Reusable regular AppBar with consistent styling
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(title),
      titleTextStyle: theme.textTheme.bodySmall,
      actions: actions,
      leading: leading,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      centerTitle: centerTitle,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
