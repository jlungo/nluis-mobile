import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_constants.dart';
import '../../../theme/app_colors.dart';
import 'form_field_label.dart';

class DateFormFieldWidget extends StatelessWidget {
  final String label;
  final bool required;
  final DateTime? value;
  final Function(DateTime?) onChanged;
  final bool enabled;

  const DateFormFieldWidget({
    super.key,
    required this.label,
    this.required = false,
    this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldLabel(label: label, required: required),
        const SizedBox(height: AppConstants.spacingSm),
        InkWell(
          onTap: enabled
              ? () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: value ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    onChanged(picked);
                  }
                }
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingMd,
              vertical: AppConstants.spacingMd,
            ),
            decoration: BoxDecoration(
              color:
                  isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(
                color: isDark ? AppColors.darkDivider : AppColors.divider,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value != null ? dateFormat.format(value!) : 'Chagua tarehe',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: value != null
                        ? (isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary)
                        : (isDark
                            ? AppColors.darkTextHint
                            : AppColors.textHint),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
