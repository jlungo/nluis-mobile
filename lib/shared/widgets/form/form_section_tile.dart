import 'package:flutter/material.dart';
import 'package:nluis_app/shared/constants/app_constants.dart';
import 'package:nluis_app/shared/models/questionnaire.dart';
import 'package:nluis_app/shared/theme/app_colors.dart';
import 'package:nluis_app/shared/widgets/form/form_field_builder.dart'
    as custom;

class FormSectionTile extends StatelessWidget {
  final QuestionnaireForm form;
  final bool isDark;
  final Map<String, dynamic> formValues;
  final DateTime? lastSavedAt;
  final bool isExpanded;
  final Function(bool) onExpansionChanged;
  final Function(String, dynamic) onFieldChanged;
  final VoidCallback onSaveForm;

  const FormSectionTile({
    super.key,
    required this.form,
    required this.isDark,
    required this.formValues,
    this.lastSavedAt,
    required this.isExpanded,
    required this.onExpansionChanged,
    required this.onFieldChanged,
    required this.onSaveForm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Sort fields by position
    final sortedFields = List<CustomFormField>.from(form.customFormFields)
      ..sort((a, b) => a.position.compareTo(b.position));

    return Theme(
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: isExpanded,
        onExpansionChanged: onExpansionChanged,
        tilePadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd,
          vertical: 8,
        ),
        childrenPadding: const EdgeInsets.all(AppConstants.spacingMd),
        backgroundColor:
            isDark
                ? AppColors.darkSurfaceVariant.withValues(alpha: 0.3)
                : AppColors.surfaceVariant.withValues(alpha: 0.3),
        collapsedBackgroundColor: Colors.transparent,
        title: Text(
          form.name,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        subtitle:
            form.description.isNotEmpty
                ? Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    form.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                    ),
                  ),
                )
                : null,
        children: [
          // Form fields
          ...sortedFields.map(
            (field) => Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
              child: custom.FormFieldBuilder(
                field: field,
                value: formValues[field.id],
                onChanged: (value) => onFieldChanged(field.id, value),
              ),
            ),
          ),

          // Save button
          const SizedBox(height: AppConstants.spacingSm),
          Row(
            children: [
              if (lastSavedAt != null)
                Expanded(
                  child: Text(
                    'Ilihifadhiwa ${_formatTime(lastSavedAt!)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                    ),
                  ),
                )
              else
                const Expanded(child: SizedBox()),
              ElevatedButton.icon(
                onPressed: onSaveForm,
                icon: const Icon(Icons.save_outlined, size: 18),
                label: const Text('Hifadhi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? AppColors.darkPrimary : AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingMd,
                    vertical: AppConstants.spacingSm,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inSeconds < 60) return 'sasa hivi';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m zilizopita';
    if (diff.inHours < 24) return '${diff.inHours}h zilizopita';
    return '${diff.inDays}d zilizopita';
  }
}
