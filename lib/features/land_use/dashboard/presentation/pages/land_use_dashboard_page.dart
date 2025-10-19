import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/network/network_info.dart';
import '../../../../../data/services/download_provider.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/utils/project_action_handler.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/app_drawer.dart';
import '../../../../../features/auth/presentation/providers/auth_providers.dart';
import '../../../../../shared/widgets/badge_chip.dart';
import '../../../../../shared/widgets/project_list_card.dart';
import '../../../../../shared/widgets/stat_card.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/action_menu_item.dart';
import '../../../../../shared/widgets/offline_banner.dart';
import '../../../../../shared/utils/snackbar_utils.dart';
import '../providers/project_providers.dart';
import 'projects_list_page.dart';
import '../../../../../shared/models/project.dart';
import '../../../survey/presentation/pages/survey_list_page.dart';
import '../../../zoning/presentation/pages/zoning_page.dart';

class LandUseDashboardPage extends ConsumerWidget {
  const LandUseDashboardPage({super.key});

  void _showProjectActions(BuildContext context, Project project) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppConstants.radiusXl),
                topRight: Radius.circular(AppConstants.radiusXl),
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: AppConstants.spacingMd),
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color:
                            isDark ? AppColors.darkDivider : AppColors.divider,
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusSm,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingLg),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingLg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color:
                                isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingSm),
                        Text(
                          'Choose an action',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color:
                                isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingLg),
                  if (project.hasSurvey)
                    ActionMenuItem(
                      icon: Icons.assignment_outlined,
                      label: 'Survey',
                      description: 'View and manage surveys',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => SurveyListPage(
                                  projectId: project.id,
                                  projectName: project.name,
                                ),
                          ),
                        );
                      },
                    ),
                  if (project.hasZoning)
                    ActionMenuItem(
                      icon: Icons.map_outlined,
                      label: 'Zoning',
                      description: 'View zoning information',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ZoningPage(projectId: project.id),
                          ),
                        );
                      },
                    ),
                  if (!project.hasSurvey && !project.hasZoning)
                    Padding(
                      padding: const EdgeInsets.all(AppConstants.spacingLg),
                      child: Text(
                        'No actions available for this project',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color:
                              isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  const SizedBox(height: AppConstants.spacingLg),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final projectsAsync = ref.watch(assignedProjectsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final user = authState.valueOrNull;
    final onlineStatus = ref.watch(onlineStatusProvider);
    final isOnline = onlineStatus.maybeWhen(
      data: (value) => value,
      orElse: () => true,
    );
    final surveyStatsAsync = ref.watch(surveyDashboardStatsProvider);

    void showSnackBar(String message, {Color color = AppColors.warning}) {
      if (color == AppColors.success) {
        SnackBarUtils.showSuccess(context, message);
      } else if (color == AppColors.error) {
        SnackBarUtils.showError(context, message);
      } else if (color == AppColors.warning) {
        SnackBarUtils.showWarning(context, message);
      } else {
        SnackBarUtils.showInfo(context, message);
      }
    }

    Future<void> refreshProjects() async {
      if (!isOnline) {
        showSnackBar('Mtandao umezimwa. Washa data ili kusasisha miradi.');
        return;
      }
      ref.invalidate(assignedProjectsProvider);
      await ref.read(assignedProjectsProvider.future);
    }

    Future<void> openProject(Project project) async {
      if (!isOnline) {
        final downloadService = ref.read(downloadServiceProvider);
        final isDownloaded = await downloadService.isProjectDownloaded(
          project.id,
        );

        if (!isDownloaded) {
          showSnackBar(
            'Mradi huu haukupakuliwa. Tafadhali washa mtandao ili kuupakua.',
          );
          return;
        }
      }

      if (!context.mounted) return;
      _showProjectActions(context, project);
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        context.goNamed('moduleSwitch');
      },
      child: Scaffold(
        backgroundColor:
            isDark ? AppColors.darkBackground : AppColors.background,
        drawer: const AppDrawer(),
        appBar: const CustomAppBar(hasNotification: true),
        body: projectsAsync.when(
          data:
              (projects) => surveyStatsAsync.when(
                data:
                    (surveyStats) => _DashboardView(
                      projects: projects,
                      surveyStats: surveyStats,
                      isDark: isDark,
                      isOnline: isOnline,
                      theme: theme,
                      userName: user?.firstName ?? 'User',
                      onShowAllProjects: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProjectsListPage(),
                          ),
                        );
                      },
                      onRefresh: refreshProjects,
                      onProjectActions: openProject,
                    ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error:
                    (error, stack) => Center(
                      child: Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
              ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error:
              (error, stack) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.wifi_off,
                      size: 48,
                      color: AppColors.warning,
                    ),
                    const SizedBox(height: AppConstants.spacingSm),
                    Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppConstants.spacingSm),
                    ElevatedButton.icon(
                      onPressed: refreshProjects,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Jaribu tena'),
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}

class _DashboardView extends ConsumerStatefulWidget {
  final List<Project> projects;
  final SurveyDashboardStats surveyStats;
  final bool isDark;
  final bool isOnline;
  final ThemeData theme;
  final String userName;
  final VoidCallback onShowAllProjects;
  final Future<void> Function() onRefresh;
  final Future<void> Function(Project project) onProjectActions;

  const _DashboardView({
    required this.projects,
    required this.surveyStats,
    required this.isDark,
    required this.isOnline,
    required this.theme,
    required this.userName,
    required this.onShowAllProjects,
    required this.onRefresh,
    required this.onProjectActions,
  });

  @override
  ConsumerState<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<_DashboardView> {
  bool _isStatsExpanded = true;

  @override
  Widget build(BuildContext context) {
    final totalProjects = widget.projects.length;
    const limitDisplay = 10;
    final displayCount =
        totalProjects > limitDisplay ? limitDisplay : totalProjects;
    final showViewAll = totalProjects > limitDisplay;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section - Fixed top
        Container(
          color:
              widget.isDark ? AppColors.darkBackground : AppColors.background,
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
                    color:
                        widget.isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    BadgeChip(
                      color: AppColors.primary,
                      label: 'Miradi ${widget.projects.length}',
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•',
                      style: TextStyle(
                        color:
                            widget.isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Matumizi ya Ardhi',
                      style: widget.theme.textTheme.bodyMedium?.copyWith(
                        color:
                            widget.isDark
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
            child: _SurveyStatsGrid(
              stats: widget.surveyStats,
              isDark: widget.isDark,
            ),
          ),

        if (_isStatsExpanded) const SizedBox(height: AppConstants.spacingLg),

        // Recent Projects Header - Fixed
        Container(
          color:
              widget.isDark ? AppColors.darkBackground : AppColors.background,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Projects',
                style: widget.theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color:
                      widget.isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isStatsExpanded ? Icons.expand_less : Icons.expand_more,
                      color:
                          widget.isDark
                              ? AppColors.darkPrimary
                              : AppColors.primary,
                    ),
                    onPressed: () {
                      setState(() {
                        _isStatsExpanded = !_isStatsExpanded;
                      });
                    },
                    tooltip: _isStatsExpanded ? 'Hide Stats' : 'Show Stats',
                  ),
                  TextButton(
                    onPressed: widget.onShowAllProjects,
                    child: Text(
                      'View All',
                      style: TextStyle(
                        color:
                            widget.isDark
                                ? AppColors.darkPrimary
                                : AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Projects List - Scrollable
        Expanded(
          child:
              widget.isOnline
                  ? RefreshIndicator(
                    onRefresh: widget.onRefresh,
                    child: _buildProjectsList(
                      totalProjects: totalProjects,
                      displayCount: displayCount,
                      showViewAll: showViewAll,
                    ),
                  )
                  : _buildProjectsList(
                    totalProjects: totalProjects,
                    displayCount: displayCount,
                    showViewAll: showViewAll,
                  ),
        ),
      ],
    );
  }

  Widget _buildProjectsList({
    required int totalProjects,
    required int displayCount,
    required bool showViewAll,
  }) {
    if (totalProjects == 0) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: AppConstants.spacing2xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.folder_open_outlined,
                  size: 64,
                  color:
                      widget.isDark
                          ? AppColors.darkTextHint
                          : AppColors.textHint,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                Text(
                  'Hakuna miradi iliyopatikana',
                  style: widget.theme.textTheme.bodyLarge?.copyWith(
                    color:
                        widget.isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppConstants.spacingLg,
        AppConstants.spacingSm,
        AppConstants.spacingLg,
        AppConstants.spacing2xl,
      ),
      itemCount: displayCount + (showViewAll ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < displayCount) {
          final project = widget.projects[index];

          // Check if project is downloaded
          final downloadService = ref.read(downloadServiceProvider);

          return FutureBuilder<bool>(
            future: downloadService.isProjectDownloaded(project.id),
            builder: (context, snapshot) {
              final isDownloaded = snapshot.data ?? false;

              return Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.spacingSm),
                child: ProjectListCard(
                  project: project,
                  isDownloaded: isDownloaded,
                  onTap: () => unawaited(widget.onProjectActions(project)),
                  onDownload: () {
                    final handler = ProjectActionHandler(context, ref);
                    unawaited(handler.downloadProject(project, widget.isOnline));
                  },
                  onMoreTap: () => unawaited(widget.onProjectActions(project)),
                ),
              );
            },
          );
        }

        final totalLabel =
            'View all $totalProjects ${totalProjects == 1 ? 'project' : 'projects'}';

        return Padding(
          padding: const EdgeInsets.only(top: AppConstants.spacingSm),
          child: AppButton(
            label: totalLabel,
            icon: Icons.chevron_right,
            iconOnRight: true,
            gradientColors:
                widget.isDark
                    ? [AppColors.darkPrimary, AppColors.darkPrimaryDark]
                    : [AppColors.primary, AppColors.primaryDark],
            borderRadius: AppConstants.radiusSm.toDouble(),
            textStyle: widget.theme.textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            onPressed: widget.onShowAllProjects,
          ),
        );
      },
    );
  }
}

class _SurveyStatsGrid extends StatelessWidget {
  final SurveyDashboardStats stats;
  final bool isDark;

  const _SurveyStatsGrid({required this.stats, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = AppConstants.spacingMd;
        final isWide = constraints.maxWidth > 640;
        final columns = isWide ? 4 : 2;
        final itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            SizedBox(
              width: itemWidth,
              child: StatCard(
                count: '${stats.total}',
                label: 'Total Surveys',
                color: isDark ? AppColors.darkPrimary : AppColors.primary,
                isDark: isDark,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: StatCard(
                count: '${stats.completed}',
                label: 'Completed Surveys',
                color: isDark ? AppColors.successDark : AppColors.success,
                isDark: isDark,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: StatCard(
                count: '${stats.drafts}',
                label: 'Draft Surveys',
                color: isDark ? AppColors.warningDark : AppColors.warning,
                isDark: isDark,
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: StatCard(
                count: '${stats.uploaded}',
                label: 'Uploaded Surveys',
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
