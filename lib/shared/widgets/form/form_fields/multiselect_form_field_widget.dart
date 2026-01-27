import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import '../../../theme/app_colors.dart';
import '../../../models/questionnaire.dart';
import 'form_field_label.dart';

class MultiselectFormFieldWidget extends StatelessWidget {
  final String label;
  final bool required;
  final List<SelectOption> options;
  final List<String> values;
  final void Function(List<String>)? onChanged;
  final bool enabled;

  const MultiselectFormFieldWidget({
    super.key,
    required this.label,
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

    showDialog<void>(
      context: context,
      builder:
          (dialogContext) => StatefulBuilder(
            builder: (context, setState) {
              final filteredOptions =
                  searchQuery.isEmpty
                      ? options
                      : options
                          .where(
                            (option) =>
                                option.textLabel.toLowerCase().contains(
                                  searchQuery.toLowerCase(),
                                ) ||
                                option.value.toLowerCase().contains(
                                  searchQuery.toLowerCase(),
                                ),
                          )
                          .toList();

              final sortedOptions = List<SelectOption>.from(filteredOptions)
                ..sort((a, b) => a.position.compareTo(b.position));

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
                      if (options.length > 5) ...[
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Tafuta...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppConstants.radiusMd,
                              ),
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
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                selectedValues.clear();
                                selectedValues.addAll(
                                  sortedOptions.map((o) => o.value),
                                );
                              });
                            },
                            icon: const Icon(Icons.select_all, size: 16),
                            label: const Text('Chagua vyote'),
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  isDark
                                      ? AppColors.darkPrimary
                                      : AppColors.primary,
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
                              foregroundColor:
                                  isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color:
                            isDark ? AppColors.darkDivider : AppColors.divider,
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            children:
                                sortedOptions.map((option) {
                                  final isSelected = selectedValues.contains(
                                    option.value,
                                  );
                                  return CheckboxListTile(
                                    title: Text(
                                      option.textLabel,
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                    value: isSelected,
                                    onChanged: (bool? checked) {
                                      setState(() {
                                        if (checked == true) {
                                          if (!selectedValues.contains(
                                            option.value,
                                          )) {
                                            selectedValues.add(option.value);
                                          }
                                        } else {
                                          selectedValues.remove(option.value);
                                        }
                                      });
                                    },
                                    activeColor:
                                        isDark
                                            ? AppColors.darkPrimary
                                            : AppColors.primary,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 0,
                                    ),
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
                        color:
                            isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      onChanged!(selectedValues);
                      Navigator.of(dialogContext).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDark ? AppColors.darkPrimary : AppColors.primary,
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
        FormFieldLabel(label: label, required: required),
        const SizedBox(height: AppConstants.spacingSm),
        Opacity(
          opacity: enabled ? 1.0 : 0.6,
          child: InkWell(
            onTap: enabled ? () => _showMultiselectDialog(context) : null,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingMd,
                vertical: AppConstants.spacingMd,
              ),
              decoration: BoxDecoration(
                color:
                    isDark
                        ? AppColors.darkSurfaceVariant
                        : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                border: Border.all(
                  color: isDark ? AppColors.darkDivider : AppColors.divider,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedLabels.isEmpty
                          ? 'Chagua chaguo...'
                          : selectedLabels,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            selectedLabels.isEmpty
                                ? (isDark
                                    ? AppColors.darkTextHint
                                    : AppColors.textHint)
                                : (isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingSm),
                  if (values.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingSm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isDark ? AppColors.darkPrimary : AppColors.primary,
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusSm,
                        ),
                      ),
                      child: Text(
                        '${values.length}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Icon(
                    Icons.arrow_drop_down,
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
