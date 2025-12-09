import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/network/network_info.dart';
import '../../../../../data/services/download_provider.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/models/project.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/utils/project_action_handler.dart';
import '../../../../../shared/utils/snackbar_utils.dart';
import '../../../../../shared/widgets/app_drawer.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/offline_banner.dart';
import '../../../../../shared/widgets/project_list_card.dart';
import '../providers/ccro_providers.dart';

class CcroProjectsPage extends ConsumerStatefulWidget {
  const CcroProjectsPage({super.key});

  @override
  ConsumerState<CcroProjectsPage> createState() => _CcroProjectsPageState();
}

class _CcroProjectsPageState extends ConsumerState<CcroProjectsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, [Color? backgroundColor]) {
    if (!mounted) return;
    final color = backgroundColor;
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

  Future<void> _refreshProjects(bool isOnline) async {
    if (!isOnline) {
      _showSnackBar('Mtandao umezimwa. Washa data ili kusasisha miradi.');
      return;
    }
    ref.invalidate(ccroProjectsProvider);
    await ref.read(ccroProjectsProvider.future);
  }

  Future<void> _handleProjectTap(Project project, bool isOnline) async {
    if (!mounted) return;

    if (!isOnline) {
      final downloadService = ref.read(downloadServiceProvider);
      final isDownloaded = await downloadService.isProjectDownloaded(
        project.id,
      );

      if (!mounted) return;

      if (!isDownloaded) {
        _showSnackBar(
          'Mradi huu haukupakuliwa. Tafadhali washa mtandao ili kuupakua kwanza.',
        );
        return;
      }
    }

    if (!mounted) return;
    // Navigate to zones page
    final localityId = int.tryParse(project.localityId) ?? 0;
    context.pushNamed(
      'subdivisionZones',
      pathParameters: {
        'projectId': project.id,
        'localityId': localityId.toString(),
      },
      queryParameters: {'projectName': project.name},
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final networkAsync = ref.watch(onlineStatusProvider);
    final isOnline = networkAsync.valueOrNull ?? false;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      drawer: const AppDrawer(),
      appBar: const CustomAppBar(title: 'Chagua Mradi', hasNotification: false),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            color: isDark ? AppColors.darkBackground : AppColors.background,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tafuta mradi...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    _searchQuery.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                        : null,
                filled: true,
                fillColor:
                    isDark
                        ? AppColors.darkSurface
                        : Colors.grey.withValues(alpha: 0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingMd,
                  vertical: AppConstants.spacingSm,
                ),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value.toLowerCase());
              },
            ),
          ),
          if (!isOnline) const OfflineBanner(),

          // Projects List
          Expanded(child: _buildProjectsList(theme, isDark, isOnline)),
        ],
      ),
    );
  }

  Widget _buildProjectsList(ThemeData theme, bool isDark, bool isOnline) {
    final projectsAsync = ref.watch(ccroProjectsProvider);

    return projectsAsync.when(
      data: (projects) {
        final filteredProjects =
            projects.where((project) {
              if (_searchQuery.isEmpty) return true;
              final name = project.name.toLowerCase();
              final org = project.organization.toLowerCase();
              return name.contains(_searchQuery) || org.contains(_searchQuery);
            }).toList();

        if (filteredProjects.isEmpty) {
          final emptyState = ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _searchQuery.isEmpty
                            ? Icons.inbox_outlined
                            : Icons.search_off,
                        size: 64,
                        color:
                            isDark
                                ? AppColors.darkTextHint
                                : AppColors.textHint,
                      ),
                      const SizedBox(height: AppConstants.spacingMd),
                      Text(
                        _searchQuery.isEmpty
                            ? 'Hakuna miradi iliyopo'
                            : 'Hakuna matokeo',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color:
                              isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _searchQuery.isEmpty
                            ? 'Miradi haijapatikana kwa sasa'
                            : 'Hakuna miradi inayolingana na utafutaji wako',
                        style: theme.textTheme.bodySmall?.copyWith(
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
          );

          if (!isOnline) {
            return emptyState;
          }

          return RefreshIndicator(
            onRefresh: () => _refreshProjects(isOnline),
            child: emptyState,
          );
        }

        final listView = ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          itemCount: filteredProjects.length,
          itemBuilder: (context, index) {
            final project = filteredProjects[index];
            final downloadService = ref.read(downloadServiceProvider);

            return FutureBuilder<bool>(
              future: downloadService.isProjectDownloaded(project.id),
              builder: (context, snapshot) {
                final isDownloaded = snapshot.data ?? false;

                return ProjectListCard(
                  project: project,
                  isDownloaded: isDownloaded,
                  icon: Icons.location_city_outlined,
                  onTap: () => unawaited(_handleProjectTap(project, isOnline)),
                  onDownload: () {
                    final handler = ProjectActionHandler(context, ref);
                    unawaited(handler.downloadProject(project, isOnline));
                  },
                  onMoreTap:
                      () => unawaited(_handleProjectTap(project, isOnline)),
                );
              },
            );
          },
        );

        if (!isOnline) {
          return listView;
        }

        return RefreshIndicator(
          onRefresh: () => _refreshProjects(isOnline),
          child: listView,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) {
        final message = error.toString();
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.wifi_off,
                    size: 56,
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                  Text(
                    'Imeshindwa kupakia miradi',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color:
                          isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                  ElevatedButton.icon(
                    onPressed: () => ref.refresh(ccroProjectsProvider),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Jaribu Tena'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
