import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/network/network_info.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/widgets/badge_chip.dart';
import '../../../../../shared/widgets/stat_card.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/offline_banner.dart';
import '../../../../../shared/widgets/app_drawer.dart';
import '../../../../../shared/utils/snackbar_utils.dart';
import '../../../../../features/auth/presentation/providers/auth_providers.dart';

class CcroDashboardPage extends ConsumerWidget {
  const CcroDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final user = ref.watch(authStateProvider.select((state) => state.valueOrNull));
    final onlineStatus = ref.watch(onlineStatusProvider);
    final isOnline = onlineStatus.maybeWhen(
      data: (value) => value,
      orElse: () => true,
    );

    // TODO: Replace with actual CCRO stats providers
    final totalApplications = 0;
    final draftApplications = 0;
    final completedApplications = 0;
    final pendingUpload = 0;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        context.goNamed('moduleSwitch');
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
        drawer: const AppDrawer(),
        appBar: const CustomAppBar(hasNotification: true),
        body: _DashboardView(
          isDark: isDark,
          isOnline: isOnline,
          theme: theme,
          userName: user?.firstName ?? 'User',
          totalApplications: totalApplications,
          draftApplications: draftApplications,
          completedApplications: completedApplications,
          pendingUpload: pendingUpload,
        ),
      ),
    );
  }
}

class _DashboardView extends StatefulWidget {
  final bool isDark;
  final bool isOnline;
  final ThemeData theme;
  final String userName;
  final int totalApplications;
  final int draftApplications;
  final int completedApplications;
  final int pendingUpload;

  const _DashboardView({
    required this.isDark,
    required this.isOnline,
    required this.theme,
    required this.userName,
    required this.totalApplications,
    required this.draftApplications,
    required this.completedApplications,
    required this.pendingUpload,
  });

  @override
  State<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<_DashboardView> {
  bool _isStatsExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section - Fixed top
        Container(
          color: widget.isDark ? AppColors.darkBackground : AppColors.background,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppConstants.spacingLg,
              AppConstants.spacingLg,
              AppConstants.spacingLg,
              AppConstants.spacingLg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Karibu ${widget.userName}',
                  style: widget.theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: widget.isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    BadgeChip(
                      color: AppColors.primary,
                      label: 'Maombi ${widget.totalApplications}',
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•',
                      style: TextStyle(
                        color: widget.isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'CCRO',
                      style: widget.theme.textTheme.bodyMedium?.copyWith(
                        color: widget.isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        if (!widget.isOnline) const OfflineBanner(),
        if (!widget.isOnline) const SizedBox(height: AppConstants.spacingSm),

        // Stats Section - Collapsible
        if (_isStatsExpanded)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingLg,
            ),
            child: _CcroStatsGrid(
              totalApplications: widget.totalApplications,
              draftApplications: widget.draftApplications,
              completedApplications: widget.completedApplications,
              pendingUpload: widget.pendingUpload,
              isDark: widget.isDark,
            ),
          ),

        if (_isStatsExpanded) const SizedBox(height: AppConstants.spacingLg),

        // Quick Actions Header - Fixed
        Container(
          color: widget.isDark ? AppColors.darkBackground : AppColors.background,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vitendo Vya Haraka',
                style: widget.theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: widget.isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              IconButton(
                icon: Icon(
                  _isStatsExpanded ? Icons.expand_less : Icons.expand_more,
                  color: widget.isDark ? AppColors.darkPrimary : AppColors.primary,
                ),
                onPressed: () {
                  setState(() {
                    _isStatsExpanded = !_isStatsExpanded;
                  });
                },
                tooltip: _isStatsExpanded ? 'Hide Stats' : 'Show Stats',
              ),
            ],
          ),
        ),

        // Quick Actions List - Scrollable
        Expanded(
          child: _buildQuickActionsList(),
        ),
      ],
    );
  }

  Widget _buildQuickActionsList() {
    final actions = [
      _QuickAction(
        icon: Icons.add_location_alt,
        title: 'Anza Ombi Jipya',
        subtitle: 'Chagua eneo na anza mgawanyo wa ardhi',
        color: AppColors.primary,
        onTap: () {
          // TODO: Navigate to zones selection
          context.pushNamed('ccroProjects');
        },
      ),
      _QuickAction(
        icon: Icons.work_history,
        title: 'Kazi Zangu',
        subtitle: 'Angalia maombi yanayoendelea',
        color: AppColors.warning,
        onTap: () {
          // TODO: Navigate to my work
          context.pushNamed('myApplications');
        },
      ),
      _QuickAction(
        icon: Icons.cloud_upload,
        title: 'Maombi Yasubiri Kupakia',
        subtitle: 'Pakia maombi yaliyokamilika',
        color: AppColors.success,
        onTap: () {
          // TODO: Navigate to pending upload
          SnackBarUtils.showInfo(context, 'Kupakia kazi haijatekelezwa bado');
        },
      ),
      _QuickAction(
        icon: Icons.map_outlined,
        title: 'Angalia Maeneo',
        subtitle: 'Ona maeneo yanayoweza kugawanywa',
        color: AppColors.info,
        onTap: () {
          // TODO: Navigate to zones map
          context.pushNamed('ccroProjects');
        },
      ),
    ];

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppConstants.spacingLg,
        AppConstants.spacingSm,
        AppConstants.spacingLg,
        AppConstants.spacing2xl,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
          child: _QuickActionCard(
            action: action,
            isDark: widget.isDark,
            theme: widget.theme,
          ),
        );
      },
    );
  }
}

class _CcroStatsGrid extends StatelessWidget {
  final int totalApplications;
  final int draftApplications;
  final int completedApplications;
  final int pendingUpload;
  final bool isDark;

  const _CcroStatsGrid({
    required this.totalApplications,
    required this.draftApplications,
    required this.completedApplications,
    required this.pendingUpload,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = AppConstants.spacingMd;
        final isWide = constraints.maxWidth > 640;
        final columns = isWide ? 4 : 2;
        final itemWidth = (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            SizedBox(
              width: itemWidth,
              child: StatCard(
                count: '$totalApplications',
                label: 'Jumla ya Maombi',
                color: isDark ? AppColors.darkPrimary : AppColors.primary,
                isDark: isDark,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: StatCard(
                count: '$draftApplications',
                label: 'Rasimu',
                color: isDark ? AppColors.warningDark : AppColors.warning,
                isDark: isDark,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: StatCard(
                count: '$completedApplications',
                label: 'Zimekamilika',
                color: isDark ? AppColors.successDark : AppColors.success,
                isDark: isDark,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: StatCard(
                count: '$pendingUpload',
                label: 'Zinasubiri Kupakia',
                color: isDark ? AppColors.infoDark : AppColors.info,
                isDark: isDark,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}

class _QuickActionCard extends StatelessWidget {
  final _QuickAction action;
  final bool isDark;
  final ThemeData theme;

  const _QuickActionCard({
    required this.action,
    required this.isDark,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark ? AppColors.darkSurface : Colors.white,
      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      elevation: isDark ? 0 : 1,
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark
                  ? AppColors.darkDivider
                  : AppColors.divider.withValues(alpha: 0.2),
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                decoration: BoxDecoration(
                  color: action.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
                child: Icon(
                  action.icon,
                  color: action.color,
                  size: 32,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      action.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      action.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
