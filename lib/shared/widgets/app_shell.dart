import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class AppShell extends StatefulWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.contains('/dashboard')) return 0;
    if (location.contains('/projects') ||
        location.contains('/survey') ||
        location.contains('/zoning')) {
      return 1;
    }
    if (location.contains('/drafts')) return 2;
    if (location.contains('/settings')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              // theme.brightness == Brightness.dark
              //     ? AppColors.darkShadow
              //     : Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.dashboard_outlined,
                  label: 'Dashibodi',
                  isSelected: currentIndex == 0,
                  onTap: () => context.goNamed('luDashboard'),
                  theme: theme,
                ),
                _NavItem(
                  icon: Icons.folder_outlined,
                  label: 'Miradi',
                  isSelected: currentIndex == 1,
                  onTap: () => context.goNamed('luProjects'),
                  theme: theme,
                ),
                _NavItem(
                  icon: Icons.description_outlined,
                  label: 'Dodoso',
                  badge: '2',
                  isSelected: currentIndex == 2,
                  onTap: () => context.goNamed('drafts'),
                  theme: theme,
                ),
                _NavItem(
                  icon: Icons.map_outlined,
                  label: 'Ramani',
                  isSelected: currentIndex == 3,
                  onTap: () {
                    // Will navigate to zoning when project selected
                  },
                  theme: theme,
                ),
                _NavItem(
                  icon: Icons.person_outline,
                  label: 'Account',
                  isSelected: currentIndex == 4,
                  onTap: () => context.goNamed('settings'),
                  theme: theme,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;
  final String? badge;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.theme,
    this.badge,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              gradient:
                  widget.isSelected
                      ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors:
                            widget.theme.brightness == Brightness.dark
                                ? [
                                  AppColors.darkPrimary,
                                  AppColors.darkPrimaryDark,
                                ]
                                : [AppColors.primary, AppColors.primaryDark],
                      )
                      : null,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      widget.icon,
                      color:
                          widget.isSelected
                              ? (widget.theme.brightness == Brightness.dark
                                  ? AppColors.darkTextInverse
                                  : Colors.white)
                              : (widget.theme.brightness == Brightness.dark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary),
                      size: 26,
                    ),
                    if (widget.badge != null)
                      Positioned(
                        right: -8,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors:
                                  widget.theme.brightness == Brightness.dark
                                      ? [
                                        AppColors.successDark,
                                        AppColors.successDark,
                                      ]
                                      : [AppColors.success, AppColors.success],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            widget.badge!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  widget.label,
                  style: TextStyle(
                    color:
                        widget.isSelected
                            ? (widget.theme.brightness == Brightness.dark
                                ? AppColors.darkTextInverse
                                : Colors.white)
                            : (widget.theme.brightness == Brightness.dark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary),
                    fontSize: 11,
                    fontWeight:
                        widget.isSelected ? FontWeight.w700 : FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
