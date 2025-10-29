import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import '../../../theme/app_colors.dart';
import '../../../models/questionnaire.dart';
import '../../../utils/dialog_utils.dart';

class MultiselectFormFieldWidget extends StatelessWidget {
  final String label;
  final String? placeholder;
  final bool required;
  final List<SelectOption> options;
  final List<String> values;
  final void Function(List<String>)? onChanged;
  final bool enabled;

  const MultiselectFormFieldWidget({
    super.key,
    required this.label,
    this.placeholder,
    this.required = false,
    required this.options,
    required this.values,
    required this.onChanged,
    this.enabled = true,
  });

  void _showMultiselectDialog(BuildContext context) {
    if (!enabled || onChanged == null) return;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedValues = List<String>.from(values);
    String searchQuery = '';

    DialogUtils.showCustomDialog<void>(
      context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          // Filter options based on search query
          final filteredOptions = searchQuery.isEmpty
              ? options
              : options.where((option) =>
                  option.textLabel.toLowerCase().contains(searchQuery.toLowerCase()) ||
                  option.value.toLowerCase().contains(searchQuery.toLowerCase())
                ).toList();

          return AlertDialog(
            title: Text(
              label,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                // Search functionality for large lists
                if (options.length > 5) ...[
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Tafuta...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingMd,
                        vertical: AppConstants.spacingSm,
                      ),
                    ),
                    onChanged: (query) {
                      setState(() {
                        searchQuery = query;
                      });
                    },
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                ],
                // Select All / Deselect All buttons
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          selectedValues.clear();
                          selectedValues.addAll(filteredOptions.map((o) => o.value));
                        });
                      },
                      icon: const Icon(Icons.select_all, size: 16),
                      label: const Text('Chagua vyote'),
                      style: TextButton.styleFrom(
                        foregroundColor: isDark ? AppColors.darkPrimary : AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          selectedValues.clear();
                        });
                      },
                      icon: const Icon(Icons.clear_all, size: 16),
                      label: const Text('Ondoa vyote'),
                      style: TextButton.styleFrom(
                        foregroundColor: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Divider(color: isDark ? AppColors.darkDivider : AppColors.divider),
                // Options list
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: filteredOptions.map((option) {
                        final isSelected = selectedValues.contains(option.value);
                        return CheckboxListTile(
                          title: Text(
                            option.textLabel,
                            style: theme.textTheme.bodyMedium,
                          ),
                          value: isSelected,
                          onChanged: (bool? checked) {
                            setState(() {
                              if (checked == true) {
                                if (!selectedValues.contains(option.value)) {
                                  selectedValues.add(option.value);
                                }
                              } else {
                                selectedValues.remove(option.value);
                              }
                            });
                          },
                          activeColor: isDark ? AppColors.darkPrimary : AppColors.primary,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
                  'Ghairi',
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  onChanged!(selectedValues);
                  Navigator.of(dialogContext).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? AppColors.darkPrimary : AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text('Hifadhi (${selectedValues.length})'),
              ),
          ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final selectedLabels = values
        .map((v) {
          final option = options.cast<SelectOption?>().firstWhere(
            (o) => o?.value == v, 
            orElse: () => null,
          );
          return option?.textLabel ?? v;
        })
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
        Opacity(
          opacity: enabled ? 1.0 : 0.6,
          child: InkWell(
            onTap: enabled ? () => _showMultiselectDialog(context) : null,
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
        ),
        if (values.isNotEmpty) ...[
          const SizedBox(height: AppConstants.spacingSm),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: values.map((value) {
              final option = options.cast<SelectOption?>().firstWhere(
                (o) => o?.value == value,
                orElse: () => null,
              ) ?? SelectOption(textLabel: value, value: value, position: 0);
              return Chip(
                label: Text(option.textLabel),
                deleteIcon: enabled ? const Icon(Icons.close, size: 16) : null,
                onDeleted: enabled && onChanged != null ? () {
                  final newValues = List<String>.from(values);
                  newValues.remove(value);
                  onChanged!(newValues);
                } : null,
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
