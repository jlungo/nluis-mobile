import 'package:flutter/material.dart';
import 'package:nluis_app/shared/constants/app_constants.dart';
import 'package:nluis_app/shared/models/questionnaire.dart';
import 'package:nluis_app/shared/theme/app_colors.dart';
import 'package:nluis_app/shared/widgets/form/form_completion_state.dart';
import 'package:nluis_app/shared/widgets/form/form_field_builder.dart' as custom;
import 'package:nluis_app/shared/widgets/form/form_status_badge.dart';

class FormSectionTile extends StatelessWidget {
  final QuestionnaireForm form;
  final bool isDark;
  final bool isReadOnly;
  final Map<String, dynamic> formValues;
  final DateTime? lastSavedAt;
  final bool isExpanded;
  final FormCompletionState status;
  final Function(bool) onExpansionChanged;
  final Function(String, dynamic) onFieldChanged;
  final VoidCallback onSaveForm;

  const FormSectionTile({
    super.key,
    required this.form,
    required this.isDark,
    this.isReadOnly = false,
    required this.formValues,
    this.lastSavedAt,
    required this.isExpanded,
    required this.status,
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
          vertical: AppConstants.spacingXs,
        ),
        childrenPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd,
          vertical: AppConstants.spacingSm,
        ),
        backgroundColor:
            isDark
                ? AppColors.darkSurfaceVariant.withValues(alpha: 0.3)
                : AppColors.surfaceVariant.withValues(alpha: 0.3),
        collapsedBackgroundColor: Colors.transparent,
        title: Row(
          children: [
            Expanded(
              child: Text(
                form.name,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color:
                      isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: AppConstants.spacingSm),
            FormStatusBadge(
              status: status,
              isDark: isDark,
              compact: true,
            ),
          ],
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
              padding: const EdgeInsets.only(bottom: AppConstants.spacingSm),
              child: custom.FormFieldBuilder(
                field: field,
                value: _resolveFieldValue(field, formValues[field.id]),
                onChanged: isReadOnly ? null : (value) => onFieldChanged(field.id, value),
                isReadOnly: isReadOnly,
              ),
            ),
          ),

          // Save button or read-only indicator
          if (!isReadOnly) ...[
            const SizedBox(height: AppConstants.spacingXs),
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
          ] else ...[
            const SizedBox(height: AppConstants.spacingXs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingMd,
                vertical: AppConstants.spacingSm,
              ),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                border: Border.all(
                  color: AppColors.info.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 16,
                    color: AppColors.info,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Fomu hii imeshapakiwa na haiwezi kubadilishwa',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.info,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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

dynamic _resolveFieldValue(CustomFormField field, dynamic rawValue) {
  if (rawValue == null) return null;

  switch (field.type.toLowerCase()) {
    case 'checkbox':
      if (rawValue is bool) return rawValue;
      if (rawValue is String) {
        return rawValue.toLowerCase() == 'true';
      }
      return false;
    case 'select':
      if (rawValue is String) return rawValue;
      return rawValue.toString();
    case 'multiselect':
      if (rawValue is List<String>) return rawValue;
      if (rawValue is List) {
        return rawValue.map((item) => item.toString()).toList();
      }
      return <String>[];
    case 'date':
      if (rawValue is DateTime) return rawValue;
      if (rawValue is String) {
        return DateTime.tryParse(rawValue);
      }
      return null;
    default:
      return rawValue;
  }
}
