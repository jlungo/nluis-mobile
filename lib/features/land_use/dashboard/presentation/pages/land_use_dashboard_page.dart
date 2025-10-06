import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/app_drawer.dart';
import '../../../../../features/auth/presentation/providers/auth_providers.dart';
import '../../../../../shared/widgets/app_input_field.dart';
import '../../../../../shared/widgets/badge_chip.dart';
import '../../../../../shared/widgets/project_list_card.dart';
import '../../../../../shared/widgets/stat_card.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/action_menu_item.dart';
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
                                (_) => SurveyListPage(projectId: project.id),
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
              (projects) => Container(
                padding: const EdgeInsets.all(AppConstants.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      'Karibu ${user != null ? user.firstName : 'User'}',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color:
                            isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        BadgeChip(
                          color: AppColors.primary,
                          label: 'Miradi ${projects.length}',
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '•',
                          style: TextStyle(
                            color:
                                isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Matumizi ya Ardhi',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color:
                                isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingMd),

                    // Search and Filter
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ProjectsListPage(),
                                ),
                              );
                            },
                            child: AbsorbPointer(
                              child: AppInputField(
                                hintText: 'Tafuta mradi...',
                                prefixIcon: Icons.search,
                                onChanged: (value) {},
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingMd),

                        AppButton(
                          icon: Icons.tune,
                          gradientColors:
                              isDark
                                  ? [
                                    AppColors.darkPrimary,
                                    AppColors.darkPrimaryDark,
                                  ]
                                  : [AppColors.primary, AppColors.primaryDark],
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ProjectsListPage(),
                              ),
                            );
                          },
                          borderRadius: AppConstants.radiusMd.toDouble(),
                          iconSize: 20,
                          isDisabled: false,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingMd),

                    // Stats Cards
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            count: '${projects.length}',
                            label: 'Total Projects',
                            color:
                                isDark
                                    ? const Color(0xFF64B5F6)
                                    : const Color(0xFF2196F3),
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingMd),
                        Expanded(
                          child: StatCard(
                            count:
                                '${projects.where((p) => p.status == 'active').length}',
                            label: 'Completed',
                            color:
                                isDark
                                    ? AppColors.successDark
                                    : AppColors.success,
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingMd),
                        Expanded(
                          child: StatCard(
                            count: '0',
                            label: 'Pending',
                            color:
                                isDark
                                    ? AppColors.warningDark
                                    : AppColors.warning,
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Recent Projects header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Projects',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color:
                                isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ProjectsListPage(),
                              ),
                            );
                          },
                          child: Text(
                            'View All',
                            style: TextStyle(
                              color:
                                  isDark
                                      ? AppColors.darkPrimary
                                      : AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingMd),

                    Expanded(
                      child:
                          projects.isEmpty
                              ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                    AppConstants.spacing2xl,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.folder_open_outlined,
                                        size: 64,
                                        color:
                                            isDark
                                                ? AppColors.darkTextHint
                                                : AppColors.textHint,
                                      ),
                                      const SizedBox(
                                        height: AppConstants.spacingMd,
                                      ),
                                      Text(
                                        'Hakuna miradi iliyopatikana',
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(
                                              color:
                                                  isDark
                                                      ? AppColors
                                                          .darkTextSecondary
                                                      : AppColors.textSecondary,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              : Builder(
                                builder: (context) {
                                  final total = projects.length;
                                  final limitDisplay = 10;
                                  final displayCount =
                                      total > limitDisplay
                                          ? limitDisplay
                                          : total;
                                  final showViewAll = total > limitDisplay;

                                  return ListView.separated(
                                    padding: EdgeInsets.zero,
                                    itemCount:
                                        displayCount + (showViewAll ? 1 : 0),
                                    separatorBuilder:
                                        (_, _) => const SizedBox(height: 0),
                                    itemBuilder: (context, index) {
                                      if (index < displayCount) {
                                        final project = projects[index];
                                        return ProjectListCard(
                                          project: project,
                                          onTap: () {
                                            _showProjectActions(
                                              context,
                                              project,
                                            );
                                          },
                                          onMoreTap: () {
                                            _showProjectActions(
                                              context,
                                              project,
                                            );
                                          },
                                        );
                                      }

                                      final totalLabel =
                                          'View all $total ${total == 1 ? 'project' : 'projects'}';

                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: AppConstants.spacingSm,
                                        ),
                                        child: SizedBox(
                                          // height: 40,
                                          child: AppButton(
                                            label: totalLabel,
                                            icon: Icons.chevron_right,
                                            iconOnRight: true,
                                            gradientColors:
                                                isDark
                                                    ? [
                                                      AppColors.darkPrimary,
                                                      AppColors.darkPrimaryDark,
                                                    ]
                                                    : [
                                                      AppColors.primary,
                                                      AppColors.primaryDark,
                                                    ],
                                            borderRadius:
                                                AppConstants.radiusSm
                                                    .toDouble(),
                                            textStyle: theme
                                                .textTheme
                                                .labelLarge
                                                ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                            onPressed: () {
                                              // context.goNamed('allProjects');
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}
