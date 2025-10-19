import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import '../../../theme/app_colors.dart';
import '../../../models/questionnaire.dart';

class SelectFormFieldWidget extends StatelessWidget {
  final String label;
  final String? placeholder;
  final bool required;
  final List<SelectOption> options;
  final String? value;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final bool enabled;

  const SelectFormFieldWidget({
    super.key,
    required this.label,
    this.placeholder,
    this.required = false,
    required this.options,
    this.value,
    required this.onChanged,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color:
                      isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                ),
                softWrap: true,
                overflow: TextOverflow.visible,
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
        DropdownButtonFormField<String>(
          value: value,
          onChanged: enabled ? onChanged : null,
          validator: validator,
          decoration: InputDecoration(
            hintText: placeholder ?? 'Chagua...',
            hintStyle: TextStyle(
              color: isDark ? AppColors.darkTextHint : AppColors.textHint,
            ),
            filled: true,
            fillColor:
                isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkDivider : AppColors.divider,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkPrimary : AppColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              borderSide: BorderSide(
                color: isDark ? AppColors.errorDark : AppColors.error,
              ),
            ),
          ),
          items:
              options.map((option) {
                return DropdownMenuItem<String>(
                  value: option.value,
                  child: Text(option.textLabel),
                );
              }).toList(),
        ),
      ],
    );
  }
}
