import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_constants.dart';
import '../../../theme/app_colors.dart';

class DateFormFieldWidget extends StatelessWidget {
  final String label;
  final String? placeholder;
  final bool required;
  final DateTime? value;
  final void Function(DateTime?) onChanged;
  final String? Function(DateTime?)? validator;

  const DateFormFieldWidget({
    super.key,
    required this.label,
    this.placeholder,
    this.required = false,
    this.value,
    required this.onChanged,
    this.validator,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ),
            if (required) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(
                  color: isDark ? AppColors.errorDark : AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppConstants.spacingSm),
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingMd,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(
                color: isDark ? AppColors.darkDivider : AppColors.divider,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: AppConstants.spacingMd),
                Text(
                  value != null
                      ? DateFormat('dd/MM/yyyy').format(value!)
                      : placeholder ?? 'Chagua tarehe...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: value != null
                        ? (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary)
                        : (isDark ? AppColors.darkTextHint : AppColors.textHint),
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
