import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/widgets/app_drawer.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/app_input_field.dart';
import '../../../../../shared/widgets/action_menu_item.dart';
import '../../../../../shared/widgets/project_list_card.dart';
import '../../../../../shared/models/project.dart';
import '../providers/project_providers.dart';
import '../../../survey/presentation/pages/survey_list_page.dart';
import '../../../zoning/presentation/pages/zoning_page.dart';

class ProjectsListPage extends ConsumerStatefulWidget {
  const ProjectsListPage({super.key});

  @override
  ConsumerState<ProjectsListPage> createState() => _ProjectsListPageState();
}

class _ProjectsListPageState extends ConsumerState<ProjectsListPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      // Kumbuka kuload more items/pagination
    }
  }

  void _showFilterSheet() {
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    child: Text(
                      'Filter Projects',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color:
                            isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingLg),
                  _FilterOption(
                    label: 'All Projects',
                    isSelected: _selectedStatus == null,
                    onTap: () {
                      setState(() => _selectedStatus = null);
                      Navigator.pop(context);
                    },
                  ),
                  _FilterOption(
                    label: 'Active',
                    isSelected: _selectedStatus == 'active',
                    onTap: () {
                      setState(() => _selectedStatus = 'active');
                      Navigator.pop(context);
                    },
                  ),
                  _FilterOption(
                    label: 'Completed',
                    isSelected: _selectedStatus == 'completed',
                    onTap: () {
                      setState(() => _selectedStatus = 'completed');
                      Navigator.pop(context);
                    },
                  ),
                  _FilterOption(
                    label: 'Inactive',
                    isSelected: _selectedStatus == 'inactive',
                    onTap: () {
                      setState(() => _selectedStatus = 'inactive');
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: AppConstants.spacingLg),
                ],
              ),
            ),
          ),
    );
  }

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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final projectsAsync = ref.watch(assignedProjectsProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      drawer: const AppDrawer(),
      appBar: const CustomAppBar(hasNotification: true),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              boxShadow: [
                BoxShadow(
                  color:
                      isDark
                          ? AppColors.darkShadow
                          : Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Projects',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color:
                        isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingMd),
                Row(
                  children: [
                    Expanded(
                      child: AppInputField(
                        controller: _searchController,
                        hintText: 'Search projects...',
                        prefixIcon: Icons.search,
                        suffixIcon:
                            _searchQuery.isNotEmpty ? Icons.clear : null,
                        onSuffixTap:
                            _searchQuery.isNotEmpty
                                ? () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                }
                                : null,
                        fillColor:
                            isDark
                                ? AppColors.darkSurfaceVariant
                                : AppColors.surfaceVariant,
                        borderColor: Colors.transparent,
                        onChanged: (value) {
                          setState(() => _searchQuery = value.toLowerCase());
                        },
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingMd),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors:
                              isDark
                                  ? [
                                    AppColors.darkPrimary,
                                    AppColors.darkPrimaryDark,
                                  ]
                                  : [AppColors.primary, AppColors.primaryDark],
                        ),
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusMd,
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.tune,
                          color:
                              isDark ? AppColors.darkTextInverse : Colors.white,
                        ),
                        onPressed: _showFilterSheet,
                      ),
                    ),
                  ],
                ),
                if (_selectedStatus != null) ...[
                  const SizedBox(height: AppConstants.spacingMd),
                  Wrap(
                    spacing: AppConstants.spacingSm,
                    children: [
                      Chip(
                        label: Text(_selectedStatus!),
                        onDeleted: () => setState(() => _selectedStatus = null),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        backgroundColor:
                            isDark
                                ? AppColors.darkPrimary.withValues(alpha: 0.2)
                                : AppColors.primary.withValues(alpha: 0.1),
                        labelStyle: TextStyle(
                          color:
                              isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Projects List
          Expanded(
            child: projectsAsync.when(
              data: (projects) {
                var filteredProjects =
                    projects.where((p) {
                      final matchesSearch =
                          _searchQuery.isEmpty ||
                          p.name.toLowerCase().contains(_searchQuery);
                      final matchesStatus =
                          _selectedStatus == null ||
                          p.status == _selectedStatus;
                      return matchesSearch && matchesStatus;
                    }).toList();

                if (filteredProjects.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(assignedProjectsProvider);
                      await ref.read(assignedProjectsProvider.future);
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color:
                                      isDark
                                          ? AppColors.darkTextHint
                                          : AppColors.textHint,
                                ),
                                const SizedBox(height: AppConstants.spacingMd),
                                Text(
                                  'No projects found',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color:
                                        isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(assignedProjectsProvider);
                    await ref.read(assignedProjectsProvider.future);
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(AppConstants.spacingMd),
                    itemCount: filteredProjects.length,
                    itemBuilder: (context, index) {
                      final project = filteredProjects[index];
                      return ProjectListCard(
                        project: project,
                        onTap: () => _showProjectActions(context, project),
                        onMoreTap: () => _showProjectActions(context, project),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingLg,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color:
            isSelected
                ? (isDark
                    ? AppColors.darkPrimary.withValues(alpha: 0.15)
                    : AppColors.primary.withValues(alpha: 0.1))
                : Colors.transparent,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: ListTile(
        title: Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color:
                isSelected
                    ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                    : (isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary),
          ),
        ),
        trailing:
            isSelected
                ? Icon(
                  Icons.check_circle,
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                )
                : null,
        onTap: onTap,
      ),
    );
  }
}
