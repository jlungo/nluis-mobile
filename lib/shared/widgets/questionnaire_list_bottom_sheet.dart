import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/land_use/survey/presentation/bloc/questionnaire_bloc.dart';
import '../../features/land_use/survey/presentation/bloc/questionnaire_event.dart';
import '../../features/land_use/survey/presentation/bloc/questionnaire_state.dart';
import '../constants/app_constants.dart';
import '../models/questionnaire.dart';
import '../theme/app_colors.dart';

class QuestionnaireListBottomSheet extends StatefulWidget {
  final String projectId;
  final String? projectName;
  final String module;
  final Function(String questionnaireSlug) onQuestionnaireSelected;

  const QuestionnaireListBottomSheet({
    super.key,
    required this.projectId,
    this.projectName,
    required this.module,
    required this.onQuestionnaireSelected,
  });

  @override
  State<QuestionnaireListBottomSheet> createState() =>
      _QuestionnaireListBottomSheetState();

  static void show(
    BuildContext context, {
    required String projectId,
    String? projectName,
    required String module,
    required Function(String questionnaireSlug) onQuestionnaireSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => QuestionnaireListBottomSheet(
          projectId: projectId,
          projectName: projectName,
          module: module,
          onQuestionnaireSelected: onQuestionnaireSelected,
        ),
      ),
    );
  }
}

class _QuestionnaireListBottomSheetState
    extends State<QuestionnaireListBottomSheet> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<QuestionnaireBloc>().add(
          LoadQuestionnaires(module: widget.module),
        );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppConstants.radiusXl),
          topRight: Radius.circular(AppConstants.radiusXl),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: AppConstants.spacingMd),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkDivider : AppColors.divider,
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingLg,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chagua Dodoso',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      if (widget.projectName != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.projectName!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingLg,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                context
                    .read<QuestionnaireBloc>()
                    .add(SearchQuestionnaires(value));
              },
              decoration: InputDecoration(
                hintText: 'Tafuta dodoso...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context
                              .read<QuestionnaireBloc>()
                              .add(const SearchQuestionnaires(''));
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Expanded(
            child: BlocBuilder<QuestionnaireBloc, QuestionnaireState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppConstants.spacing2xl),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (state.errorMessage != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.spacing2xl),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: isDark ? AppColors.errorDark : AppColors.error,
                          ),
                          const SizedBox(height: AppConstants.spacingMd),
                          Text(
                            'Hitilafu imetokea',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppConstants.spacingSm),
                          Text(
                            state.errorMessage!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark ? AppColors.errorDark : AppColors.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppConstants.spacingLg),
                          IconButton.filled(
                            onPressed: () {
                              context.read<QuestionnaireBloc>().add(
                                    LoadQuestionnaires(module: widget.module),
                                  );
                            },
                            icon: const Icon(Icons.refresh),
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final questionnaires = state.filteredQuestionnaires;

                if (questionnaires.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.spacing2xl),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: isDark
                                ? AppColors.darkTextHint
                                : AppColors.textHint,
                          ),
                          const SizedBox(height: AppConstants.spacingMd),
                          Text(
                            'Hakuna madodoso yaliyopatikana',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingLg,
                    vertical: AppConstants.spacingMd,
                  ),
                  itemCount: questionnaires.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppConstants.spacingSm),
                  itemBuilder: (context, index) {
                    final questionnaire = questionnaires[index];
                    return _QuestionnaireListItem(
                      questionnaire: questionnaire,
                      isDark: isDark,
                      onTap: () {
                        Navigator.pop(context);
                        widget.onQuestionnaireSelected(questionnaire.slug);
                      },
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
        ],
      ),
    );
  }
}

class _QuestionnaireListItem extends StatelessWidget {
  final Questionnaire questionnaire;
  final bool isDark;
  final VoidCallback onTap;

  const _QuestionnaireListItem({
    required this.questionnaire,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.divider,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacingMd),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                    ),
                    borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                  ),
                  child: const Icon(
                    Icons.assignment_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppConstants.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        questionnaire.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      if (questionnaire.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          questionnaire.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.folder_outlined,
                            size: 14,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${questionnaire.questionnaireSectionsCount} section${questionnaire.questionnaireSectionsCount == 1 ? '' : 's'}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: AppConstants.spacingMd),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(AppConstants.radiusSm),
                            ),
                            child: Text(
                              'v${questionnaire.version}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color:
                      isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
