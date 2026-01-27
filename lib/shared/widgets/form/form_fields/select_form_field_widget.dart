import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import '../../../theme/app_colors.dart';
import '../../../models/questionnaire.dart';
import 'form_field_label.dart';

class SelectFormFieldWidget extends StatelessWidget {
  final String label;
  final bool required;
  final List<SelectOption> options;
  final String? value;
  final Function(String?) onChanged;
  final bool enabled;

  const SelectFormFieldWidget({
    super.key,
    required this.label,
    this.required = false,
    required this.options,
    this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final sortedOptions = List<SelectOption>.from(options)
      ..sort((a, b) => a.position.compareTo(b.position));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldLabel(label: label, required: required),
        const SizedBox(height: AppConstants.spacingSm),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: enabled ? onChanged : null,
          decoration: InputDecoration(
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingMd,
              vertical: AppConstants.spacingMd,
            ),
          ),
          items:
              sortedOptions
                  .map(
                    (option) => DropdownMenuItem<String>(
                      value: option.value,
                      child: Text(option.textLabel),
                    ),
                  )
                  .toList(),
          validator:
              required
                  ? (value) =>
                      value == null || value.isEmpty
                          ? 'Hii sehemu inahitajika'
                          : null
                  : null,
        ),
      ],
    );
  }
}
