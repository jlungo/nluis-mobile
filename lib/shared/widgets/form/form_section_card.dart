import 'package:flutter/material.dart';
import 'package:nluis_app/shared/widgets/form/form_section_tile.dart';
import 'package:nluis_app/shared/constants/app_constants.dart';
import 'package:nluis_app/shared/models/questionnaire.dart';
import 'package:nluis_app/shared/theme/app_colors.dart';
import 'package:nluis_app/shared/widgets/form/form_completion_state.dart';
import 'package:nluis_app/shared/widgets/form/form_status_badge.dart';

class FormSectionCard extends StatelessWidget {
  final QuestionnaireSection section;
  final int sectionIndex;
  final bool isDark;
  final bool isReadOnly;
  final Map<String, Map<String, dynamic>> formDataByFormSlug;
  final Map<String, DateTime?> formLastSavedAt;
  final Map<String, bool> expandedSections;
  final Map<String, bool> expandedForms;
  final Map<String, FormCompletionState> formStatuses;
  final Map<String, FormCompletionState> sectionStatuses;
  final Function(String, String, dynamic) onFieldChanged;
  final Function(String) onSaveForm;
  final Function(String, bool) onSectionExpandChanged;
  final Function(String, bool) onFormExpandChanged;

  const FormSectionCard({
    super.key,
    required this.section,
    required this.sectionIndex,
    required this.isDark,
    this.isReadOnly = false,
    required this.formDataByFormSlug,
    required this.formLastSavedAt,
    required this.expandedSections,
    required this.expandedForms,
    required this.formStatuses,
    required this.sectionStatuses,
    required this.onFieldChanged,
    required this.onSaveForm,
    required this.onSectionExpandChanged,
    required this.onFormExpandChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isExpanded = expandedSections[section.slug] ?? false;
    final sectionStatus =
        sectionStatuses[section.slug] ?? FormCompletionState.notStarted;

    // Sort forms by position
    final sortedForms = List<QuestionnaireForm>.from(section.forms)
      ..sort((a, b) => a.position.compareTo(b.position));

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingSm),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.divider,
        ),
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          onExpansionChanged: (expanded) {
            onSectionExpandChanged(section.slug, expanded);
          },
          // tilePadding: const EdgeInsets.all(AppConstants.spacingMd),
          childrenPadding: EdgeInsets.zero,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    isDark
                        ? [AppColors.darkPrimary, AppColors.darkPrimaryDark]
                        : [AppColors.primary, AppColors.primaryDark],
              ),
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            ),
            child: Text(
              '${sectionIndex + 1}',
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  section.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color:
                        isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingSm),
              FormStatusBadge(
                status: sectionStatus,
                isDark: isDark,
              ),
            ],
          ),
          subtitle:
              section.description.isNotEmpty
                  ? Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      section.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                      ),
                    ),
                  )
                  : null,
          children:
              sortedForms
                  .map(
                    (form) => FormSectionTile(
                      form: form,
                      isDark: isDark,
                      isReadOnly: isReadOnly,
                      formValues: formDataByFormSlug[form.slug] ?? {},
                      lastSavedAt: formLastSavedAt[form.slug],
                      isExpanded: expandedForms[form.slug] ?? false,
                      status:
                          formStatuses[form.slug] ??
                          FormCompletionState.notStarted,
                      onExpansionChanged: (isExpanded) {
                        onFormExpandChanged(form.slug, isExpanded);
                      },
                      onFieldChanged: (fieldId, value) {
                        onFieldChanged(form.slug, fieldId, value);
                      },
                      onSaveForm: () => onSaveForm(form.slug),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
