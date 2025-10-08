import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import '../../../theme/app_colors.dart';
import '../../../models/questionnaire.dart';

class MultiselectFormFieldWidget extends StatelessWidget {
  final String label;
  final String? placeholder;
  final bool required;
  final List<SelectOption> options;
  final List<String> values;
  final void Function(List<String>) onChanged;

  const MultiselectFormFieldWidget({
    super.key,
    required this.label,
    this.placeholder,
    this.required = false,
    required this.options,
    required this.values,
    required this.onChanged,
  });

  void _showMultiselectDialog(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedValues = List<String>.from(values);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(label),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: options.map((option) {
                final isSelected = selectedValues.contains(option.value);
                return CheckboxListTile(
                  title: Text(option.textLabel),
                  value: isSelected,
                  onChanged: (bool? checked) {
                    setState(() {
                      if (checked == true) {
                        selectedValues.add(option.value);
                      } else {
                        selectedValues.remove(option.value);
                      }
                    });
                  },
                  activeColor: isDark ? AppColors.darkPrimary : AppColors.primary,
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Ghairi',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                onChanged(selectedValues);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppColors.darkPrimary : AppColors.primary,
              ),
              child: const Text('Hifadhi'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final selectedLabels = values
        .map((v) => options.firstWhere((o) => o.value == v, orElse: () => SelectOption(textLabel: v, value: v, position: 0)).textLabel)
        .join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
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
          onTap: () => _showMultiselectDialog(context),
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
                Expanded(
                  child: Text(
                    values.isEmpty ? (placeholder ?? 'Chagua...') : selectedLabels,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: values.isEmpty
                          ? (isDark ? AppColors.darkTextHint : AppColors.textHint)
                          : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
        if (values.isNotEmpty) ...[
          const SizedBox(height: AppConstants.spacingSm),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: values.map((value) {
              final option = options.firstWhere(
                (o) => o.value == value,
                orElse: () => SelectOption(textLabel: value, value: value, position: 0),
              );
              return Chip(
                label: Text(option.textLabel),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () {
                  final newValues = List<String>.from(values);
                  newValues.remove(value);
                  onChanged(newValues);
                },
                backgroundColor: isDark
                    ? AppColors.darkPrimary.withValues(alpha: 0.2)
                    : AppColors.primary.withValues(alpha: 0.1),
                labelStyle: TextStyle(
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
