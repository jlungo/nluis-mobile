import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/app_drawer.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../providers/madodoso_providers.dart';

class MadodosoPage extends ConsumerWidget {
  const MadodosoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(madodosoStateProvider);

    final counts = stateAsync.maybeWhen(
      data:
          (data) => (data.draftCount, data.completedCount, data.uploadedCount),
      orElse: () => (0, 0, 0),
    );

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: const AppDrawer(),
        appBar: CustomAppBar(
          title: 'Madodoso',
          bottom: _MadodosoTabBar(counts: counts),
        ),
        body: stateAsync.when(
          data:
              (data) => TabBarView(
                children: [
                  _MadodosoList(
                    status: MadodosoStatus.draft,
                    entries: data.drafts,
                    emptyMessage: 'Hakuna dodoso za rasimu kwa sasa.',
                  ),
                  _MadodosoList(
                    status: MadodosoStatus.completed,
                    entries: data.completed,
                    emptyMessage:
                        'Hakuna dodoso zilizokamilika zinazosubiri kupakiwa.',
                  ),
                  _MadodosoList(
                    status: MadodosoStatus.uploaded,
                    entries: data.uploaded,
                    emptyMessage: 'Hakuna dodoso zilizopakiwa bado.',
                  ),
                ],
              ),
          loading:
              () => const TabBarView(
                children: [
                  _MadodosoLoading(),
                  _MadodosoLoading(),
                  _MadodosoLoading(),
                ],
              ),
          error:
              (error, stackTrace) => TabBarView(
                children: List.generate(
                  3,
                  (_) => _MadodosoError(message: error.toString()),
                ),
              ),
        ),
      ),
    );
  }
}

class _MadodosoTabBar extends StatelessWidget implements PreferredSizeWidget {
  final (int draft, int completed, int uploaded) counts;

  const _MadodosoTabBar({required this.counts});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget buildTab(String label, int count, Color color) {
      return Tab(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMd,
            vertical: AppConstants.spacingXs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              _ModernBadge(count: count, color: color, isDark: isDark),
            ],
          ),
        ),
      );
    }

    return TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      labelColor: isDark ? AppColors.darkPrimary : AppColors.primaryDark,
      unselectedLabelColor:
          isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
      dividerColor: isDark ? AppColors.darkDivider : AppColors.divider,
      indicatorColor: isDark ? AppColors.darkPrimary : AppColors.primaryDark,
      indicatorWeight: 3,
      indicatorSize: TabBarIndicatorSize.tab,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingSm),
      tabs: [
        buildTab('Draft', counts.$1, AppColors.warning),
        buildTab('Completed', counts.$2, AppColors.info),
        buildTab('Uploaded', counts.$3, AppColors.success),
      ],
    );
  }
}

class _ModernBadge extends StatelessWidget {
  final int count;
  final Color color;
  final bool isDark;

  const _ModernBadge({
    required this.count,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 24),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: isDark ? 0.9 : 1.0),
            color.withValues(alpha: isDark ? 0.7 : 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        count.toString(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          height: 1.2,
        ),
      ),
    );
  }
}

class _MadodosoList extends ConsumerWidget {
  final MadodosoStatus status;
  final List<MadodosoEntry> entries;
  final String emptyMessage;

  const _MadodosoList({
    required this.status,
    required this.entries,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (entries.isEmpty) {
      return _MadodosoEmpty(message: emptyMessage);
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(madodosoStateProvider);
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd,
          vertical: AppConstants.spacingMd,
        ),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return _MadodosoCard(entry: entry, status: status);
        },
      ),
    );
  }
}

class _MadodosoCard extends StatelessWidget {
  final MadodosoEntry entry;
  final MadodosoStatus status;

  const _MadodosoCard({required this.entry, required this.status});

  Color _statusColor(BuildContext context) {
    switch (status) {
      case MadodosoStatus.draft:
        return AppColors.warning;
      case MadodosoStatus.completed:
        return AppColors.info;
      case MadodosoStatus.uploaded:
        return AppColors.success;
    }
  }

  String _statusLabel() {
    switch (status) {
      case MadodosoStatus.draft:
        return 'Draft';
      case MadodosoStatus.completed:
        return 'Completed';
      case MadodosoStatus.uploaded:
        return 'Uploaded';
    }
  }

  String _formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays >= 7) {
      return '${date.day}/${date.month}/${date.year}';
    }
    if (difference.inDays >= 1) {
      return '${difference.inDays}d ago';
    }
    if (difference.inHours >= 1) {
      return '${difference.inHours}h ago';
    }
    if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}m ago';
    }
    return 'Just now';
  }

  double _progress() {
    if (entry.totalForms == 0) return 0;
    return entry.completedForms / entry.totalForms;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color:
              isDark
                  ? AppColors.darkDivider.withValues(alpha: 0.5)
                  : AppColors.divider.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          onTap: () {
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
          },
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.questionnaireName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color:
                                  isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            entry.projectName,
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
                    const SizedBox(width: AppConstants.spacingSm),
                    _StatusChip(
                      label: _statusLabel(),
                      color: _statusColor(context),
                      isDark: isDark,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingMd),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color:
                          isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Updated ${_formatRelative(entry.updatedAt)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                if (entry.totalForms > 0) ...[
                  const SizedBox(height: AppConstants.spacingMd),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: _progress(),
                          minHeight: 8,
                          backgroundColor:
                              isDark
                                  ? AppColors.darkDivider
                                  : AppColors.divider.withValues(alpha: 0.4),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _statusColor(context),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${entry.completedForms}/${entry.totalForms} forms completed',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${(_progress() * 100).toStringAsFixed(0)}%',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: _statusColor(context),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isDark;

  const _StatusChip({
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.15)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.5 : 0.3),
          width: 1.5,
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: color,
          fontSize: 11,
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
                    size: 64,
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLg),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingXl,
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

class _MadodosoLoading extends StatelessWidget {
  const _MadodosoLoading();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: CircularProgressIndicator(
        color: isDark ? AppColors.darkPrimary : AppColors.primary,
      ),
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
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              decoration: BoxDecoration(
                color:
                    isDark
                        ? AppColors.errorDark.withValues(alpha: 0.1)
                        : AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: isDark ? AppColors.errorDark : AppColors.error,
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            Text(
              'Imeshindikana kupakia madodoso',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppConstants.spacingSm),
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
