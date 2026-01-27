import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../models/questionnaire.dart';
import '../../theme/app_colors.dart';
import 'form_field_builder.dart' as form_builder;

class FormSectionCard extends StatelessWidget {
  final QuestionnaireSection section;
  final int sectionIndex;
  final bool isDark;
  final bool isReadOnly;
  final Map<String, Map<String, dynamic>> formDataByFormSlug;
  final Map<String, bool> expandedSections;
  final Map<String, bool> expandedForms;
  final Function(String, String, dynamic) onFieldChanged;

  const FormSectionCard({
    super.key,
    required this.section,
    required this.sectionIndex,
    required this.isDark,
    this.isReadOnly = false,
    required this.formDataByFormSlug,
    required this.expandedSections,
    required this.expandedForms,
    required this.onFieldChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isExpanded = expandedSections[section.slug] ?? true;

    final sortedForms = List<QuestionnaireForm>.from(section.forms)
      ..sort((a, b) => a.position.compareTo(b.position));

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
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
          tilePadding: const EdgeInsets.all(AppConstants.spacingMd),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMd,
            vertical: AppConstants.spacingSm,
          ),
          leading: Container(
            padding: const EdgeInsets.all(AppConstants.spacingSm),
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
          title: Text(
            section.name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          subtitle:
              section.description.isNotEmpty
                  ? Padding(
                    padding: const EdgeInsets.only(top: AppConstants.spacingXs),
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
                  .map((form) => _buildFormCard(context, theme, form))
                  .toList(),
        ),
      ),
    );
  }

  Widget _buildFormCard(
    BuildContext context,
    ThemeData theme,
    QuestionnaireForm form,
  ) {
    final formData = formDataByFormSlug[form.slug] ?? {};
    final sortedFields = List<CustomFormField>.from(form.customFormFields)
      ..sort((a, b) => a.position.compareTo(b.position));

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.divider,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            form.name,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          if (form.description.isNotEmpty) ...[
            const SizedBox(height: AppConstants.spacingXs),
            Text(
              form.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: AppConstants.spacingMd),
          ...sortedFields.map((field) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
              child: form_builder.FormFieldBuilder(
                field: field,
                value: formData[field.id],
                onChanged: (value) {
                  onFieldChanged(form.slug, field.id, value);
                },
                isReadOnly: isReadOnly,
              ),
            );
          }),
        ],
      ),
    );
  }
}
