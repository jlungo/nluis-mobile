import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/utils/dialog_utils.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/app_drawer.dart';
import '../../../../shared/widgets/overlay_loader.dart';
import '../../../../data/local/draft_provider.dart';
import '../../../land_use/survey/presentation/pages/questionnaire_form_page.dart';

class DraftDodososPage extends ConsumerStatefulWidget {
  const DraftDodososPage({super.key});

  @override
  ConsumerState<DraftDodososPage> createState() => _DraftDodososPageState();
}

class _DraftDodososPageState extends ConsumerState<DraftDodososPage> {
  bool _isLoading = true;
  bool _isDeleting = false;
  List<_DraftDodosoItem> _drafts = [];

  @override
  void initState() {
    super.initState();
    _loadDrafts();
  }

  Future<void> _loadDrafts() async {
    setState(() => _isLoading = true);

    try {
      final database = ref.read(databaseProvider);

      // Get all drafts grouped by questionnaire
      final draftsResponse = await (database.select(database.surveyResponses)
            ..where((tbl) => tbl.isDraft.equals(true))
            ..orderBy([(tbl) => drift.OrderingTerm.desc(tbl.updatedAt)]))
          .get();

      // Group by project and questionnaire (not by form)
      final Map<String, _DraftDodosoItem> draftMap = {};

      for (final draft in draftsResponse) {
        final questionnaireSlug = draft.questionnaireSlug ?? '';
        if (questionnaireSlug.isEmpty) continue;

        final key = '${draft.projectId}_$questionnaireSlug';

        if (!draftMap.containsKey(key)) {
          // Get project details
          final project = await (database.select(database.projects)
                ..where((tbl) => tbl.id.equals(draft.projectId)))
              .getSingleOrNull();

          // Get questionnaire details
          final questionnaire = await (database.select(database.questionnaires)
                ..where((tbl) => tbl.slug.equals(questionnaireSlug)))
              .getSingleOrNull();

          // Get all forms for this questionnaire to calculate completion
          final allForms = await (database.select(database.forms)
                ..where((tbl) => tbl.questionnaireId.equals(questionnaire?.id ?? 0)))
              .get();

          // Get all draft forms for this questionnaire
          final questionnaireDrafts = draftsResponse.where(
            (d) => d.projectId == draft.projectId && d.questionnaireSlug == questionnaireSlug,
          ).toList();

          // Calculate completion based on number of forms filled
          int filledForms = 0;
          for (final d in questionnaireDrafts) {
            try {
              final data = jsonDecode(d.answersJson);
              if (data is Map && data.isNotEmpty) {
                filledForms++;
              }
            } catch (e) {
              // Ignore parsing errors
            }
          }

          final totalForms = allForms.length;
          final completionPercentage = totalForms > 0
              ? ((filledForms / totalForms) * 100).round()
              : 0;

          draftMap[key] = _DraftDodosoItem(
            id: key, // Use composite key as ID
            projectId: draft.projectId,
            questionnaireSlug: questionnaireSlug,
            type: questionnaire?.name ?? 'Dodoso',
            projectName: project?.name ?? 'Mradi',
            savedDate: _formatDate(
              DateTime.fromMillisecondsSinceEpoch(draft.updatedAt * 1000),
            ),
            completionPercentage: completionPercentage,
            lastEditedBy: 'Wewe',
            formsCount: totalForms,
            filledFormsCount: filledForms,
          );
        }
      }

      if (mounted) {
        setState(() {
          _drafts = draftMap.values.toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        SnackBarUtils.showError(context, 'Hitilafu: $e');
      }
    }
  }


  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m zilizopita';
      }
      return '${difference.inHours}h zilizopita';
    } else if (difference.inDays == 1) {
      return 'Jana';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} siku zilizopita';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Future<void> _deleteDraft(_DraftDodosoItem draft) async {
    setState(() => _isDeleting = true);

    try {
      final database = ref.read(databaseProvider);

      // Delete all draft forms for this questionnaire
      await (database.delete(database.surveyResponses)
            ..where((tbl) =>
                tbl.projectId.equals(draft.projectId) &
                tbl.questionnaireSlug.equals(draft.questionnaireSlug) &
                tbl.isDraft.equals(true)))
          .go();

      if (mounted) {
        setState(() {
          _drafts.removeWhere((d) => d.id == draft.id);
          _isDeleting = false;
        });

        SnackBarUtils.showSuccess(context, 'Rasimu imefutwa');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isDeleting = false);
        SnackBarUtils.showError(context, 'Hitilafu: $e');
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context, _DraftDodosoItem draft) async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    await DialogUtils.showCustomDialog<void>(
      context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warning,
              size: 28,
            ),
            const SizedBox(width: AppConstants.spacingSm),
            Expanded(
              child: Text(
                'Thibitisha Kufuta',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Je, una uhakika unataka kufuta rasimu hii?',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    draft.type,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    draft.projectName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            Text(
              'Kitendo hiki hakiwezi kutenduliwa nyuma.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Ghairi',
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _deleteDraft(draft);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
            ),
            child: const Text('Futa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(hasNotification: true),
      drawer: const AppDrawer(),
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: OverlayLoader(
        isLoading: _isLoading || _isDeleting,
        child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rasimu za Dodoso',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingXs),
                  Text(
                    'Dodoso zilizohifadhiwa kama rasimu katika miradi yote',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (_drafts.isEmpty)
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadDrafts,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.info.withValues(alpha: 0.1),
                                      AppColors.info.withValues(alpha: 0.05),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.drafts_outlined,
                                  size: 80,
                                  color: AppColors.info,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Hakuna Rasimu',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Rasimu zako zitaonyeshwa hapa',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadDrafts,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingLg,
                      vertical: AppConstants.spacingSm,
                    ),
                    itemCount: _drafts.length,
                    itemBuilder: (context, index) {
                      return _DraftCard(
                        draft: _drafts[index],
                        isDark: isDark,
                        onDelete: () => unawaited(_confirmDelete(context, _drafts[index])),
                        onEdit: () {
                          final draft = _drafts[index];
                          if (draft.questionnaireSlug.isEmpty) {
                            SnackBarUtils.showError(context, 'Dodoso haipo');
                            return;
                          }

                          // Navigate to questionnaire form page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuestionnaireFormPage(
                                questionnaireSlug: draft.questionnaireSlug,
                                projectId: draft.projectId,
                                projectName: draft.projectName,
                              ),
                            ),
                          ).then((_) => _loadDrafts()); // Refresh drafts when returning
                        },
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
        ),
      ),
    );
  }
}

class _DraftDodosoItem {
  final String id;
  final String projectId;
  final String questionnaireSlug;
  final String type;
  final String projectName;
  final String savedDate;
  final int completionPercentage;
  final String lastEditedBy;
  final int formsCount;
  final int filledFormsCount;

  _DraftDodosoItem({
    required this.id,
    required this.projectId,
    required this.questionnaireSlug,
    required this.type,
    required this.projectName,
    required this.savedDate,
    required this.completionPercentage,
    required this.lastEditedBy,
    required this.formsCount,
    required this.filledFormsCount,
  });
}

class _DraftCard extends StatelessWidget {
  final _DraftDodosoItem draft;
  final bool isDark;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _DraftCard({
    required this.draft,
    required this.isDark,
    required this.onDelete,
    required this.onEdit,
  });

  IconData _getIconForType(String type) {
    if (type.contains('Makazi')) return Icons.home_outlined;
    if (type.contains('Kilimo')) return Icons.agriculture_outlined;
    if (type.contains('Biashara')) return Icons.store_mall_directory_outlined;
    return Icons.description_outlined;
  }

  Color _getColorForPercentage(int percentage) {
    if (percentage >= 70) return AppColors.success;
    if (percentage >= 40) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(AppConstants.spacingMd),
            leading: Container(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [AppColors.darkPrimary, AppColors.darkPrimaryDark]
                      : [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
              child: Icon(
                _getIconForType(draft.type),
                color: isDark ? AppColors.darkTextInverse : Colors.white,
                size: 24,
              ),
            ),
            title: Text(
              draft.type,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppConstants.spacingXs),
                Row(
                  children: [
                    Icon(
                      Icons.folder_outlined,
                      size: 14,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        draft.projectName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 14,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${draft.filledFormsCount}/${draft.formsCount} fomu zimejazwa',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      draft.savedDate,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                      const SizedBox(width: AppConstants.spacingSm),
                      Text(
                        'Endelea Kuhariri',
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: AppConstants.spacingSm),
                      Text(
                        'Futa',
                        style: TextStyle(
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingMd,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Umekamilika',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '${draft.completionPercentage}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: _getColorForPercentage(draft.completionPercentage),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingXs),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                  child: LinearProgressIndicator(
                    value: draft.completionPercentage / 100,
                    backgroundColor: isDark
                        ? AppColors.darkDivider
                        : AppColors.divider,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getColorForPercentage(draft.completionPercentage),
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingMd,
              vertical: AppConstants.spacingSm,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.surfaceVariant,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(AppConstants.radiusMd),
                bottomRight: Radius.circular(AppConstants.radiusMd),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 14,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Ilihaririwa na ${draft.lastEditedBy}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
