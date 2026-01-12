import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/utils/snackbar_utils.dart';
import '../../../../../shared/utils/form_progress_calculator.dart';
import '../../../../../shared/widgets/form/form_section_card.dart';
import '../../../../../shared/widgets/form_progress_indicator.dart';
import '../bloc/survey_form_bloc.dart';
import '../bloc/survey_form_event.dart';
import '../bloc/survey_form_state.dart';

class SurveyFormPage extends StatefulWidget {
  final String questionnaireSlug;
  final String projectId;
  final String? projectName;
  final String? surveyId;

  const SurveyFormPage({
    super.key,
    required this.questionnaireSlug,
    required this.projectId,
    this.projectName,
    this.surveyId,
  });

  @override
  State<SurveyFormPage> createState() => _SurveyFormPageState();
}

class _SurveyFormPageState extends State<SurveyFormPage> {
  @override
  void initState() {
    super.initState();
    context.read<SurveyFormBloc>().add(
      LoadQuestionnaireDetail(
        widget.questionnaireSlug,
        surveyId: widget.surveyId,
      ),
    );
  }

  void _saveDraft() {
    context.read<SurveyFormBloc>().add(
      SaveFormDraft(
        projectId: widget.projectId,
        questionnaireSlug: widget.questionnaireSlug,
        moduleSlug: 'compliance',
      ),
    );
  }

  void _completeSurvey() {
    context.read<SurveyFormBloc>().add(
      CompleteSurvey(
        projectId: widget.projectId,
        questionnaireSlug: widget.questionnaireSlug,
        moduleSlug: 'compliance',
      ),
    );
  }

  Widget _buildFormBody(SurveyFormState state, bool isDark, ThemeData theme) {
    if (state.questionnaireDetail == null) {
      return Center(
        child: Text('Hakuna data ya dodoso', style: theme.textTheme.bodyLarge),
      );
    }

    final sections = state.questionnaireDetail!.sections;
    final sortedSections = List.from(sections)
      ..sort((a, b) => a.position.compareTo(b.position));

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      itemCount: sortedSections.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildHeader(state, isDark, theme);
        }
        return FormSectionCard(
          section: sortedSections[index - 1],
          sectionIndex: index - 1,
          isDark: isDark,
          formDataByFormSlug: state.formDataByFormSlug,
          expandedSections: const {},
          expandedForms: const {},
          onFieldChanged: (formSlug, fieldId, value) {
            context.read<SurveyFormBloc>().add(
              UpdateFormField(
                formSlug: formSlug,
                fieldId: fieldId,
                value: value,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(SurveyFormState state, bool isDark, ThemeData theme) {
    final isEditing = widget.surveyId != null;

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  state.questionnaireDetail!.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (isEditing)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingSm,
                    vertical: AppConstants.spacingXs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                    border: Border.all(color: AppColors.warning),
                  ),
                  child: Text(
                    'Kuhariri',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          if (widget.projectName != null) ...[
            const SizedBox(height: AppConstants.spacingSm),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color:
                      isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                ),
                const SizedBox(width: AppConstants.spacingXs),
                Expanded(
                  child: Text(
                    widget.projectName!,
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
          ],
          const SizedBox(height: AppConstants.spacingMd),
          FormProgressIndicator(
            progress: FormProgressCalculator.calculateProgress(
              questionnaireDetail: state.questionnaireDetail!,
              formDataByFormSlug: state.formDataByFormSlug,
            ),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocConsumer<SurveyFormBloc, SurveyFormState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          SnackBarUtils.showError(context, state.errorMessage!);
        }
        if (state.successMessage != null) {
          if (state.successMessage == 'complete') {
            SnackBarUtils.showSuccess(context, 'Dodoso limekamilika!');
            Navigator.pop(context);
          } else {
            SnackBarUtils.showSuccess(context, state.successMessage!);
          }
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            backgroundColor:
                isDark ? AppColors.darkBackground : AppColors.background,
            appBar: AppBar(
              title: const Text('Dodoso Mpya'),
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor:
              isDark ? AppColors.darkBackground : AppColors.background,
          appBar: AppBar(
            title: Text(
              'Dodoso Mpya',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              if (state.isSaving)
                const Padding(
                  padding: EdgeInsets.all(AppConstants.spacingMd),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(right: AppConstants.spacingSm),
                  child: TextButton.icon(
                    onPressed: _saveDraft,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                    icon: const Icon(Icons.save_outlined, size: 20),
                    label: const Text('Hifadhi'),
                  ),
                ),
            ],
          ),
          body: _buildFormBody(state, isDark, theme),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.darkDivider : AppColors.divider,
                ),
              ),
            ),
            child: SafeArea(
              child: ElevatedButton.icon(
                onPressed: state.isSaving ? null : _completeSurvey,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.spacingMd,
                  ),
                ),
                icon:
                    state.isSaving
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Icon(Icons.check_circle_outline),
                label: const Text('Hifadhi Kamili'),
              ),
            ),
          ),
        );
      },
    );
  }
}
