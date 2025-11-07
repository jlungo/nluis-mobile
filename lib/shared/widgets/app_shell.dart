import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/madodoso/presentation/providers/madodoso_providers.dart';
import '../theme/app_colors.dart';

class AppShell extends ConsumerStatefulWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  static const int _draftsIndex = 2;

  static const List<_BottomNavDestination> _destinations = [
    _BottomNavDestination(
      icon: Icons.grid_view_outlined,
      label: 'Dashibodi',
      routeName: 'luDashboard',
      locationMatchers: ['/dashboard'],
    ),
    _BottomNavDestination(
      icon: Icons.folder_copy_outlined,
      label: 'Miradi',
      routeName: 'luProjects',
      locationMatchers: ['/projects', '/survey'],
    ),
    _BottomNavDestination(
      icon: Icons.library_books_outlined,
      label: 'Madodoso',
      routeName: 'madodoso',
      locationMatchers: ['/madodoso'],
    ),
    _BottomNavDestination(
      icon: Icons.map_outlined,
      label: 'Zoning',
      routeName: 'zoningManager',
      locationMatchers: ['/zoning-manager', '/zoning'],
    ),
    _BottomNavDestination(
      icon: Icons.person_outline_rounded,
      label: 'Mipangilio',
      routeName: 'settings',
      locationMatchers: ['/settings'],
    ),
  ];

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final index = _destinations.indexWhere(
      (destination) => destination.matches(location),
    );
    return index == -1 ? 0 : index;
  }

  bool _shouldShowBottomBar(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    
    // Only show bottom bar on these specific routes
    return location == '/module/land-use/dashboard' ||
        location == '/module/land-use/projects' ||
        location == '/madodoso' ||
        location == '/zoning-manager' ||
        location == '/settings';
  }

  void _onDestinationSelected(BuildContext context, int index) {
    final destination = _destinations[index];
    context.goNamed(destination.routeName);
  }

  List<TabItem> _buildTabItems(ThemeData theme, String? draftsBadge) {
    final bool isDark = theme.brightness == Brightness.dark;
    final Widget? badge = _buildDraftBadge(draftsBadge, isDark);

    return List<TabItem>.generate(_destinations.length, (index) {
      final destination = _destinations[index];
      return TabItem(
        icon: destination.icon,
        title: destination.label,
        count: index == _draftsIndex ? badge : null,
      );
    });
  }

  Widget? _buildDraftBadge(String? value, bool isDark) {
    if (value == null) return null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? AppColors.successDark : AppColors.success,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentIndex = _getCurrentIndex(context);
    final madodosoState = ref.watch(madodosoStateProvider);
    final draftsBadge = madodosoState.maybeWhen(
      data:
          (state) => state.draftCount > 0 ? state.draftCount.toString() : null,
      orElse: () => null,
    );

    final bool isDark = theme.brightness == Brightness.dark;
    final Color backgroundColor =
        isDark ? AppColors.darkSurface : theme.colorScheme.surface;
    final Color selectedColor =
        isDark ? AppColors.darkPrimary : AppColors.primary;
    final Color unselectedColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final Color shadowColor =
        isDark ? AppColors.darkShadow : Colors.black.withValues(alpha: 0.08);

    final shouldShowBottomBar = _shouldShowBottomBar(context);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: shouldShowBottomBar
          ? Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: SafeArea(
                top: false,
                child: BottomBarDefault(
                  items: _buildTabItems(theme, draftsBadge),
                  indexSelected: currentIndex,
                  onTap: (index) => _onDestinationSelected(context, index),
                  backgroundColor: backgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                  color: unselectedColor,
                  colorSelected: selectedColor,
                  iconSize: 20,
                  titleStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                  top: 16,
                  countStyle: const CountStyle(size: 16),
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  enableShadow: false,
                ),
              ),
            )
          : null,
    );
  }
}

class _BottomNavDestination {
  final IconData icon;
  final String label;
  final String routeName;
  final List<String> locationMatchers;

  const _BottomNavDestination({
    required this.icon,
    required this.label,
    required this.routeName,
    required this.locationMatchers,
  });

  bool matches(String location) =>
      locationMatchers.any((matcher) => location.contains(matcher));
}
