import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import '../../../theme/app_colors.dart';
import 'form_field_label.dart';

class TableFormFieldWidget extends StatefulWidget {
  final String label;
  final bool required;
  final List<Map<String, dynamic>>? value;
  final void Function(List<Map<String, dynamic>>?)? onChanged;
  final bool enabled;
  final List<String> columns;
  final List<String> columnLabels;

  const TableFormFieldWidget({
    super.key,
    required this.label,
    this.required = false,
    this.value,
    this.onChanged,
    this.enabled = true,
    required this.columns,
    required this.columnLabels,
  });

  @override
  State<TableFormFieldWidget> createState() => _TableFormFieldWidgetState();
}

class _TableFormFieldWidgetState extends State<TableFormFieldWidget> {
  late List<Map<String, dynamic>> _rows;

  @override
  void initState() {
    super.initState();
    _rows = widget.value != null ? List.from(widget.value!) : [];
  }

  @override
  void didUpdateWidget(TableFormFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _rows = widget.value != null ? List.from(widget.value!) : [];
    }
  }

  void _addRow() {
    setState(() {
      final newRow = <String, dynamic>{};
      for (final column in widget.columns) {
        newRow[column] = '';
      }
      _rows.add(newRow);
    });
    widget.onChanged?.call(_rows);
  }

  void _removeRow(int index) {
    setState(() {
      _rows.removeAt(index);
    });
    widget.onChanged?.call(_rows);
  }

  void _updateCell(int rowIndex, String column, String value) {
    setState(() {
      _rows[rowIndex][column] = value;
    });
    widget.onChanged?.call(_rows);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldLabel(label: widget.label, required: widget.required),
        const SizedBox(height: AppConstants.spacingSm),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark ? AppColors.darkDivider : AppColors.divider,
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
          child: Column(
            children: [
              if (_rows.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingXl),
                  child: Column(
                    children: [
                      Icon(
                        Icons.table_chart_outlined,
                        size: 48,
                        color:
                            isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                      ),
                      const SizedBox(height: AppConstants.spacingMd),
                      Text(
                        'Hakuna data bado',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color:
                              isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      ...widget.columnLabels.map(
                        (label) => DataColumn(
                          label: Text(
                            label,
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      if (widget.enabled) const DataColumn(label: Text('')),
                    ],
                    rows:
                        _rows.asMap().entries.map((entry) {
                          final index = entry.key;
                          final row = entry.value;
                          return DataRow(
                            cells: [
                              ...widget.columns.map((column) {
                                return DataCell(
                                  widget.enabled
                                      ? TextFormField(
                                        initialValue:
                                            row[column]?.toString() ?? '',
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: AppConstants.spacingSm,
                                          ),
                                        ),
                                        onChanged: (value) {
                                          _updateCell(index, column, value);
                                        },
                                      )
                                      : Text(row[column]?.toString() ?? ''),
                                );
                              }),
                              if (widget.enabled)
                                DataCell(
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color:
                                          isDark
                                              ? AppColors.errorDark
                                              : AppColors.error,
                                      size: 20,
                                    ),
                                    onPressed: () => _removeRow(index),
                                    tooltip: 'Ondoa safu mlalo',
                                  ),
                                ),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              if (widget.enabled)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppConstants.spacingSm),
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? AppColors.darkSurfaceVariant
                            : AppColors.surfaceVariant,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(AppConstants.radiusMd),
                    ),
                  ),
                  child: TextButton.icon(
                    onPressed: _addRow,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Ongeza safu mlalo'),
                    style: TextButton.styleFrom(
                      foregroundColor:
                          isDark ? AppColors.darkPrimary : AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (_rows.isNotEmpty) ...[
          const SizedBox(height: AppConstants.spacingXs),
          Text(
            'Safu mlalo ${_rows.length}',
            style: theme.textTheme.bodySmall?.copyWith(
              color:
                  isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
