import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/network/network_info.dart';
import '../../../../../data/services/survey_upload_provider.dart';
import '../../../../constants/app_constants.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/responsive_utils.dart';
import '../../../../utils/snackbar_utils.dart';
import '../../../../widgets/app_drawer.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/status_card.dart';
import '../providers/madodoso_providers.dart';

enum MadodosoFilter { all, draft, completed, uploaded }

/// Configuration for the shared madodoso page
class MadodosoConfig {
  final String title;
  final String? moduleSlug;

  const MadodosoConfig({required this.title, this.moduleSlug});

  /// Land Use module config
  static final landUse = MadodosoConfig(
    title: 'Madodoso - Land Use',
    moduleSlug: ModuleType.slug[ModuleType.landUse]!,
  );

  /// M&E module config
  static final monitoringEvaluation = MadodosoConfig(
    title: 'Madodoso - M&E',
    moduleSlug: ModuleType.slug[ModuleType.monitoringAndEvaluation]!,
  );

  /// Compliance module config
  static final compliance = MadodosoConfig(
    title: 'Madodoso - Compliance',
    moduleSlug: ModuleType.slug[ModuleType.compliance]!,
  );
}

class MadodosoPage extends ConsumerStatefulWidget {
  final MadodosoConfig config;

  const MadodosoPage({super.key, required this.config});

  @override
  ConsumerState<MadodosoPage> createState() => _MadodosoPageState();
}

class _MadodosoPageState extends ConsumerState<MadodosoPage> {
  MadodosoFilter _currentFilter = MadodosoFilter.all;
  final Set<String> _selectedIds = {};
  bool _isUploading = false;

  List<MadodosoEntry> _getFilteredEntries(MadodosoState state) {
    switch (_currentFilter) {
      case MadodosoFilter.all:
        return [...state.drafts, ...state.completed, ...state.uploaded]
          ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      case MadodosoFilter.draft:
        return state.drafts;
      case MadodosoFilter.completed:
        return state.completed;
      case MadodosoFilter.uploaded:
        return state.uploaded;
    }
  }

  bool get _isSelectionMode => _selectedIds.isNotEmpty;

  bool _canSelectEntry(MadodosoEntry entry) {
    // Can only select completed (waiting for upload) entries
    return entry.status == MadodosoStatus.completed;
  }

  void _toggleSelection(MadodosoEntry entry) {
    if (!_canSelectEntry(entry)) return;
    setState(() {
      if (_selectedIds.contains(entry.surveyId)) {
        _selectedIds.remove(entry.surveyId);
      } else {
        _selectedIds.add(entry.surveyId);
      }
    });
  }

  void _clearSelection() {
    setState(() => _selectedIds.clear());
  }

  void _selectAllEligible(MadodosoState state) {
    final entries = _getFilteredEntries(state);
    setState(() {
      for (final entry in entries) {
        if (_canSelectEntry(entry)) {
          _selectedIds.add(entry.surveyId);
        }
      }
    });
  }

  Future<void> _uploadSelected() async {
    if (_isUploading || _selectedIds.isEmpty) return;

    setState(() => _isUploading = true);

    final uploadService = ref.read(surveyUploadServiceProvider);
    final successes = <String>[];
    final failures = <String, String>{};

    try {
      for (final surveyId in _selectedIds.toList()) {
        try {
          final result = await uploadService.uploadSurvey(
            surveyId: surveyId,
            onProgress: (slug, progress) {},
            onStatusChange: (slug, status) {},
          );

          if (result.allSucceeded) {
            successes.add(surveyId);
          } else if (result.hasFailures) {
            failures[surveyId] = result.failures.values.first;
          }
        } catch (error) {
          failures[surveyId] = _mapUploadError(error);
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _selectedIds.removeAll(successes);
        });
      }
    }

    if (successes.isNotEmpty && mounted) {
      SnackBarUtils.showSuccess(
        context,
        '${successes.length} dodoso zimepakiwa kikamilifu',
      );
    }

    if (failures.isNotEmpty && mounted) {
      SnackBarUtils.showError(
        context,
        'Baadhi ya dodoso hazikupakiwa: ${failures.values.first}',
      );
    }
  }

  String _mapUploadError(Object error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      if (statusCode != null) {
        if (statusCode >= 500) return 'Hitilafu ya seva ($statusCode)';
        return 'Hitilafu ya seva ($statusCode)';
      }
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return 'Muda wa muunganisho umeisha';
      }
      if (error.type == DioExceptionType.connectionError) {
        return 'Mtandao haupatikani';
      }
      return error.message ?? 'Hitilafu ya mtandao';
    }
    return error.toString();
  }

  PreferredSizeWidget _buildAppBar(
    bool isDark,
    ThemeData theme,
    MadodosoState? state,
  ) {
    if (_isSelectionMode) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _clearSelection,
        ),
        title: Text(
          '${_selectedIds.length} zimechaguliwa',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        foregroundColor:
            isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        elevation: 1,
        actions: [
          TextButton.icon(
            onPressed: _isUploading ? null : _uploadSelected,
            icon:
                _isUploading
                    ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Icon(Icons.cloud_upload_outlined),
            label: Text(_isUploading ? 'Inapakia...' : 'Pakia'),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          ),
          if (state != null)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'select_all') _selectAllEligible(state);
              },
              itemBuilder:
                  (context) => [
                    const PopupMenuItem(
                      value: 'select_all',
                      child: Text('Chagua Zote'),
                    ),
                  ],
            ),
        ],
      );
    }
    return CustomAppBar(
      title: widget.config.title,
      showBackButton: false,
      showNotifications: false,
      showProfile: true,
    );
  }

  Widget _buildFilterChips(bool isDark, MadodosoState state) {
    final allCount =
        state.draftCount + state.completedCount + state.uploadedCount;

    final filters = [
      (MadodosoFilter.all, 'Zote', allCount, AppColors.primary),
      (MadodosoFilter.draft, 'Rasimu', state.draftCount, AppColors.warning),
      (
        MadodosoFilter.completed,
        'Zilizohifadhiwa',
        state.completedCount,
        AppColors.info,
      ),
      (
        MadodosoFilter.uploaded,
        'Zimepakiwa',
        state.uploadedCount,
        AppColors.success,
      ),
    ];

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd,
          vertical: AppConstants.spacingSm,
        ),
        itemCount: filters.length,
        separatorBuilder:
            (_, i) => const SizedBox(width: AppConstants.spacingSm),
        itemBuilder: (context, index) {
          final (filter, label, count, color) = filters[index];
          final isActive = _currentFilter == filter;

          return FilterChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label),
                const SizedBox(width: 6),
                Container(
                  constraints: const BoxConstraints(minWidth: 20),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isActive
                            ? color
                            : (isDark
                                ? Colors.grey.shade700
                                : Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    count.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.fontSize(context, 11),
                      fontWeight: FontWeight.w700,
                      color:
                          isActive
                              ? Colors.white
                              : (isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary),
                    ),
                  ),
                ),
              ],
            ),
            selected: isActive,
            onSelected: (_) => setState(() => _currentFilter = filter),
            selectedColor: color.withValues(alpha: 0.2),
            checkmarkColor: color,
            labelStyle: TextStyle(
              color:
                  isActive
                      ? color
                      : (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary),
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
            backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
            side: BorderSide(
              color:
                  isActive
                      ? color
                      : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            ),
            showCheckmark: false,
            padding: const EdgeInsets.symmetric(horizontal: 4),
          );
        },
      ),
    );
  }

  Widget _buildEntryList(
    bool isDark,
    MadodosoState state,
    List<MadodosoEntry> entries,
  ) {
    if (entries.isEmpty) {
      return _MadodosoEmpty(message: _getEmptyMessage());
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: AppConstants.spacingMd,
      ),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final isSelected = _selectedIds.contains(entry.surveyId);
        final canSelect = _canSelectEntry(entry);

        return _MadodosoCard(
          entry: entry,
          isSelected: isSelected,
          isSelectionMode: _isSelectionMode,
          canSelect: canSelect,
          onTap: () {
            if (_isSelectionMode) {
              _toggleSelection(entry);
            } else {
              context.pushNamed(
                'questionnaireForm',
                pathParameters: {
                  'questionnaireSlug': entry.questionnaireSlug,
                  'projectId': entry.projectId,
                  'projectName': entry.projectName,
                },
                queryParameters: {
                  'surveyId': entry.surveyId,
                  'isReadOnly': entry.isReadOnly.toString(),
                },
              );
            }
          },
          onLongPress: () => _toggleSelection(entry),
        );
      },
    );
  }

  String _getEmptyMessage() {
    switch (_currentFilter) {
      case MadodosoFilter.all:
        return 'Hakuna dodoso kwa sasa.';
      case MadodosoFilter.draft:
        return 'Hakuna dodoso za rasimu kwa sasa.';
      case MadodosoFilter.completed:
        return 'Hakuna dodoso zilizokamilika zinazosubiri kupakiwa.';
      case MadodosoFilter.uploaded:
        return 'Hakuna dodoso zilizopakiwa bado.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final stateAsync = ref.watch(
      madodosoStateProviderFamily(widget.config.moduleSlug),
    );
    final onlineStatus = ref.watch(onlineStatusProvider);
    final isOnline = onlineStatus.maybeWhen(
      data: (value) => value,
      orElse: () => true,
    );

    return Scaffold(
      drawer: _isSelectionMode ? null : const AppDrawer(),
      appBar: _buildAppBar(isDark, theme, stateAsync.valueOrNull),
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: stateAsync.when(
        data: (state) {
          final entries = _getFilteredEntries(state);

          return Column(
            children: [
              if (!_isSelectionMode) _buildFilterChips(isDark, state),
              Expanded(
                child:
                    isOnline
                        ? RefreshIndicator(
                          onRefresh: () async {
                            ref.invalidate(
                              madodosoStateProviderFamily(
                                widget.config.moduleSlug,
                              ),
                            );
                          },
                          child: _buildEntryList(isDark, state, entries),
                        )
                        : _buildEntryList(isDark, state, entries),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _MadodosoError(message: error.toString()),
      ),
    );
  }
}

class _MadodosoCard extends StatelessWidget {
  final MadodosoEntry entry;
  final bool isSelected;
  final bool isSelectionMode;
  final bool canSelect;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _MadodosoCard({
    required this.entry,
    required this.isSelected,
    required this.isSelectionMode,
    required this.canSelect,
    required this.onTap,
    required this.onLongPress,
  });

  Color _statusColor() {
    switch (entry.status) {
      case MadodosoStatus.draft:
        return AppColors.warning;
      case MadodosoStatus.completed:
        return AppColors.info;
      case MadodosoStatus.uploaded:
        return AppColors.success;
    }
  }

  String _statusLabel() {
    switch (entry.status) {
      case MadodosoStatus.draft:
        return 'Rasimu';
      case MadodosoStatus.completed:
        return 'Imekamilika';
      case MadodosoStatus.uploaded:
        return 'Imepakiwa';
    }
  }

  String _formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays >= 7) {
      return '${date.day}/${date.month}/${date.year}';
    }
    if (difference.inDays >= 1) {
      return '${difference.inDays}d zilizopita';
    }
    if (difference.inHours >= 1) {
      return '${difference.inHours}h zilizopita';
    }
    if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}m zilizopita';
    }
    return 'Sasa hivi';
  }

  String? _getUploadedAt() {
    if (entry.status == MadodosoStatus.uploaded) {
      return _formatRelative(entry.updatedAt);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final showProgressBar = entry.status == MadodosoStatus.draft;
    final showProgress =
        entry.status == MadodosoStatus.draft ||
        entry.status == MadodosoStatus.completed;

    return GestureDetector(
      onLongPress: canSelect ? onLongPress : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(
          bottom: ResponsiveUtils.spacing(context, AppConstants.spacingSm),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border:
              isSelected
                  ? Border.all(
                    color: isDark ? AppColors.darkPrimary : AppColors.primary,
                    width: 2,
                  )
                  : null,
        ),
        child: Stack(
          children: [
            StatusCard(
              title: entry.questionnaireName,
              subtitle: entry.projectName,
              statusLabel: _statusLabel(),
              statusColor: _statusColor(),
              updatedAt: 'Imesasishwa ${_formatRelative(entry.updatedAt)}',
              uploadedAt: _getUploadedAt(),
              completedCount: entry.completedForms,
              totalCount: entry.totalForms,
              showProgress: showProgress,
              showProgressBar: showProgressBar,
              isDark: isDark,
              onTap: onTap,
            ),
            if (isSelectionMode && canSelect)
              Positioned(
                top: ResponsiveUtils.spacing(context, 8),
                right: ResponsiveUtils.spacing(context, 8),
                child: Container(
                  width: ResponsiveUtils.spacing(context, 24),
                  height: ResponsiveUtils.spacing(context, 24),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? (isDark
                                ? AppColors.darkPrimary
                                : AppColors.primary)
                            : (isDark ? AppColors.darkSurface : Colors.white),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          isSelected
                              ? (isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.primary)
                              : (isDark
                                  ? AppColors.darkDivider
                                  : AppColors.divider),
                      width: 2,
                    ),
                  ),
                  child:
                      isSelected
                          ? Icon(
                            Icons.check,
                            size: ResponsiveUtils.iconSize(context, 16),
                            color: Colors.white,
                          )
                          : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MadodosoEmpty extends StatelessWidget {
  final String message;

  const _MadodosoEmpty({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacingLg),
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? AppColors.darkPrimary.withValues(alpha: 0.1)
                            : AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.assignment_outlined,
                    size: ResponsiveUtils.iconSize(context, 64),
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                  ),
                ),
                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    AppConstants.spacingLg,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.spacing(
                      context,
                      AppConstants.spacingXl,
                    ),
                  ),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MadodosoError extends StatelessWidget {
  final String message;

  const _MadodosoError({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(
          ResponsiveUtils.spacing(context, AppConstants.spacingLg),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(
                ResponsiveUtils.spacing(context, AppConstants.spacingMd),
              ),
              decoration: BoxDecoration(
                color:
                    isDark
                        ? AppColors.errorDark.withValues(alpha: 0.1)
                        : AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: ResponsiveUtils.iconSize(context, 48),
                color: isDark ? AppColors.errorDark : AppColors.error,
              ),
            ),
            SizedBox(
              height: ResponsiveUtils.spacing(context, AppConstants.spacingMd),
            ),
            Text(
              'Imeshindikana kupakia madodoso',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: ResponsiveUtils.spacing(context, AppConstants.spacingSm),
            ),
            Text(
              message,
              textAlign: TextAlign.center,
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
    );
  }
}
