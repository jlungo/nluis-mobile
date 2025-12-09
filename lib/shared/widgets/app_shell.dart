import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/madodoso/presentation/providers/madodoso_providers.dart';
import '../../features/land_use/zoning/presentation/providers/zoning_manager_providers.dart';
import '../theme/app_colors.dart';

class AppShell extends ConsumerStatefulWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  // Land Use module destinations
  static const List<_BottomNavDestination> _landUseDestinations = [
    _BottomNavDestination(
      icon: Icons.grid_view_outlined,
      label: 'Dashibodi',
      routeName: 'luDashboard',
      locationMatchers: ['/module/land-use/dashboard'],
    ),
    _BottomNavDestination(
      icon: Icons.folder_copy_outlined,
      label: 'Miradi',
      routeName: 'luProjects',
      locationMatchers: ['/module/land-use/projects', '/module/land-use/survey'],
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
  ];

  // CCRO module destinations
  static const List<_BottomNavDestination> _ccroDestinations = [
    _BottomNavDestination(
      icon: Icons.dashboard_outlined,
      label: 'Dashibodi',
      routeName: 'ccroDashboard',
      locationMatchers: ['/module/ccro/dashboard'],
    ),
    _BottomNavDestination(
      icon: Icons.folder_copy_outlined,
      label: 'Miradi',
      routeName: 'ccroProjects',
      locationMatchers: ['/module/ccro/projects'],
    ),
    _BottomNavDestination(
      icon: Icons.work_outline,
      label: 'Kazi Zangu',
      routeName: 'myApplications',
      locationMatchers: ['/module/ccro/my-applications', '/module/ccro/application'],
    ),
  ];

  List<_BottomNavDestination> _getDestinationsForModule(String location) {
    if (location.startsWith('/module/ccro')) {
      return _ccroDestinations;
    } else if (location.startsWith('/module/land-use') ||
        location.startsWith('/madodoso') ||
        location.startsWith('/zoning-manager')) {
      return _landUseDestinations;
    }
    return [];
  }

  int _getCurrentIndex(BuildContext context, List<_BottomNavDestination> destinations) {
    final location = GoRouterState.of(context).matchedLocation;
    final index = destinations.indexWhere(
      (destination) => destination.matches(location),
    );
    return index == -1 ? 0 : index;
  }

  bool _shouldShowBottomBar(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    // For CCRO module, only show bottom bar on main pages
    if (location.startsWith('/module/ccro')) {
      return location == '/module/ccro/dashboard' ||
          location == '/module/ccro/projects' ||
          location.contains('/module/ccro/my-applications') ||
          location.contains('/module/ccro/application');
    }

    // Show bottom bar for land-use module routes (madodoso, zoning)
    return location.startsWith('/module/land-use') ||
        location.startsWith('/madodoso') ||
        location.startsWith('/zoning-manager');
  }

  void _onDestinationSelected(BuildContext context, int index, List<_BottomNavDestination> destinations) {
    final destination = destinations[index];
    context.goNamed(destination.routeName);
  }

  List<TabItem> _buildTabItems(
    ThemeData theme,
    List<_BottomNavDestination> destinations,
    String? draftsBadge,
    String? zoningBadge,
  ) {
    final bool isDark = theme.brightness == Brightness.dark;
    final Widget? draftBadgeWidget = _buildDraftBadge(draftsBadge, isDark);
    final Widget? zoningBadgeWidget = _buildDraftBadge(zoningBadge, isDark);

    return List<TabItem>.generate(destinations.length, (index) {
      final destination = destinations[index];
      
      // Only show badges for land use module
      Widget? badge;
      if (destinations == _landUseDestinations) {
        // Madodoso is at index 2, Zoning is at index 3 in land use
        if (index == 2) badge = draftBadgeWidget;
        if (index == 3) badge = zoningBadgeWidget;
      }
      
      return TabItem(
        icon: destination.icon,
        title: destination.label,
        count: badge,
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
    final location = GoRouterState.of(context).matchedLocation;
    final destinations = _getDestinationsForModule(location);
    final currentIndex = _getCurrentIndex(context, destinations);
    
    // Only fetch badges for land use module
    String? draftsBadge;
    String? zoningBadge;
    
    if (destinations == _landUseDestinations) {
      final madodosoState = ref.watch(madodosoStateProvider);
      draftsBadge = madodosoState.maybeWhen(
        data:
            (state) => state.draftCount > 0 ? state.draftCount.toString() : null,
        orElse: () => null,
      );

      // Get zoning draft features count
      final zoningDraftsAsync = ref.watch(draftFeaturesProvider);
      zoningBadge = zoningDraftsAsync.when(
        data:
            (features) => features.isNotEmpty ? features.length.toString() : null,
        loading: () => null,
        error: (_, _) => null,
      );
    }

    final bool isDark = theme.brightness == Brightness.dark;
    final Color backgroundColor =
        isDark ? AppColors.darkSurface : theme.colorScheme.surface;
    final Color selectedColor =
        isDark ? AppColors.darkPrimary : AppColors.primary;
    final Color unselectedColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final Color shadowColor =
        isDark ? AppColors.darkShadow : Colors.black.withValues(alpha: 0.08);

    final shouldShowBottomBar = _shouldShowBottomBar(context) && destinations.isNotEmpty;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar:
          shouldShowBottomBar
              ? Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: SafeArea(
                  top: false,
                  child: BottomBarDefault(
                    items: _buildTabItems(theme, destinations, draftsBadge, zoningBadge),
                    indexSelected: currentIndex,
                    onTap: (index) => _onDestinationSelected(context, index, destinations),
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
