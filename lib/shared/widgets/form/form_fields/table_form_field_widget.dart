import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import '../../../theme/app_colors.dart';

class TableColumn {
  final int position;
  final String value; // key/name
  final String textLabel; // display label

  TableColumn({
    required this.position,
    required this.value,
    required this.textLabel,
  });

  factory TableColumn.fromJson(Map<String, dynamic> json) {
    return TableColumn(
      position: json['position'] as int? ?? 0,
      value: json['value'] as String,
      textLabel: json['text_label'] as String,
    );
  }
}

class TableRow {
  final String id; // Unique identifier for the row
  final Map<String, String> data;

  TableRow({
    required this.id,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data,
    };
  }

  factory TableRow.fromJson(Map<String, dynamic> json) {
    return TableRow(
      id: json['id'] as String,
      data: Map<String, String>.from(json['data'] ?? {}),
    );
  }
}

/// Dynamic table for forms
class DynamicTable {
  final String label;
  final bool required;
  final List<TableColumn> columns;
  final List<TableRow> rows;

  DynamicTable({
    required this.label,
    required this.required,
    required this.columns,
    required this.rows,
  });

  factory DynamicTable.fromField({
    required String label,
    required bool required,
    required List<dynamic> selectOptions,
    List<dynamic>? existingRows,
  }) {
    // Parse columns from questionnaire_select_options
    final columns = (selectOptions)
        .map((opt) => TableColumn.fromJson(opt as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.position.compareTo(b.position));

    // Parse existing rows or start with one empty row
    List<TableRow> rows;
    if (existingRows != null && existingRows.isNotEmpty) {
      rows = existingRows
          .map((row) => TableRow.fromJson(row as Map<String, dynamic>))
          .toList();
    } else {
      // Start with one empty row
      rows = [
        TableRow(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          data: {},
        ),
      ];
    }

    return DynamicTable(
      label: label,
      required: required,
      columns: columns,
      rows: rows,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'required': required,
      'columns': columns.map((c) => {
        'position': c.position,
        'value': c.value,
        'text_label': c.textLabel,
      }).toList(),
      'rows': rows.map((r) => r.toJson()).toList(),
    };
  }
}

class DynamicFillableTable extends StatefulWidget {
  final DynamicTable tableData;
  final bool readOnly;
  final Function(List<TableRow>)? onChanged;

  const DynamicFillableTable({
    super.key,
    required this.tableData,
    this.readOnly = false,
    this.onChanged,
  });

  @override
  State<DynamicFillableTable> createState() => _DynamicFillableTableState();
}

class _DynamicFillableTableState extends State<DynamicFillableTable> {
  late List<TableRow> rows;
  final Map<String, Map<String, TextEditingController>> _controllers = {};

  @override
  void initState() {
    super.initState();
    rows = List.from(widget.tableData.rows);

    // Initialize controllers for each cell
    for (final row in rows) {
      _controllers[row.id] = {};
      for (final column in widget.tableData.columns) {
        _controllers[row.id]![column.value] = TextEditingController(
          text: row.data[column.value] ?? '',
        );
      }
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (final rowControllers in _controllers.values) {
      for (final controller in rowControllers.values) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void _addRow() {
    final newRow = TableRow(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      data: {},
    );

    setState(() {
      rows.add(newRow);
      _controllers[newRow.id] = {};
      for (final column in widget.tableData.columns) {
        _controllers[newRow.id]![column.value] = TextEditingController();
      }
    });

    _notifyChanged();
  }

  void _deleteRow(String rowId) {
    setState(() {
      // Dispose controllers for this row
      _controllers[rowId]?.forEach((_, controller) => controller.dispose());
      _controllers.remove(rowId);

      rows.removeWhere((row) => row.id == rowId);
    });

    _notifyChanged();
  }

  void _onCellChanged(String rowId, String columnValue, String value) {
    final row = rows.firstWhere((r) => r.id == rowId);
    row.data[columnValue] = value;
    _notifyChanged();
  }

  void _notifyChanged() {
    if (widget.onChanged != null) {
      widget.onChanged!(rows);
    }
  }

  Widget _buildCell(TableColumn column, TableRow row) {
    if (widget.readOnly) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.data[column.value] ?? '',
          style: const TextStyle(fontSize: 14),
        ),
      );
    }

    final controller = _controllers[row.id]?[column.value];

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: column.textLabel,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            borderSide: BorderSide(color: AppColors.primary),
          ),
        ),
        onChanged: (value) => _onCellChanged(row.id, column.value, value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final columns = widget.tableData.columns;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Table label
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                widget.tableData.label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
            if (widget.tableData.required)
              Text(
                ' *',
                style: TextStyle(
                  color: isDark ? AppColors.errorDark : AppColors.error,
                  fontSize: 16,
                ),
              ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingSm),

        // Table container
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark ? AppColors.darkDivider : AppColors.divider,
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
          ),
          child: Column(
            children: [
              // Scrollable table
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(
                    isDark
                        ? AppColors.darkSurface.withValues(alpha: 0.5)
                        : Colors.grey.shade100,
                  ),
                  dataRowColor: WidgetStateProperty.all(
                    isDark ? AppColors.darkBackground : Colors.white,
                  ),
                  columnSpacing: 16,
                  horizontalMargin: 16,
                  columns: [
                    DataColumn(
                      label: Text(
                        'Na.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    ...columns.map(
                      (column) => DataColumn(
                        label: Flexible(
                          child: Text(
                            column.textLabel,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            maxLines: 3,
                          ),
                        ),
                      ),
                    ),
                    if (!widget.readOnly)
                      DataColumn(
                        label: Text(
                          'Futa',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                  ],
                  rows: rows.asMap().entries.map((entry) {
                    final index = entry.key;
                    final row = entry.value;

                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                        ...columns.map(
                          (column) => DataCell(
                            SizedBox(
                              width: 150,
                              child: _buildCell(column, row),
                            ),
                          ),
                        ),
                        if (!widget.readOnly)
                          DataCell(
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: rows.length > 1
                                    ? (isDark ? AppColors.errorDark : AppColors.error)
                                    : (isDark
                                        ? AppColors.darkTextSecondary.withValues(alpha: 0.3)
                                        : AppColors.textSecondary.withValues(alpha: 0.3)),
                                size: 20,
                              ),
                              onPressed: rows.length > 1
                                  ? () => _deleteRow(row.id)
                                  : null,
                              tooltip: rows.length > 1 ? 'Futa mstari' : 'Lazima uwe na mstari mmoja',
                            ),
                          ),
                      ],
                    );
                  }).toList(),
                ),
              ),

              // Add row button
              if (!widget.readOnly)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppConstants.spacingSm),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: isDark ? AppColors.darkDivider : AppColors.divider,
                      ),
                    ),
                  ),
                  child: TextButton.icon(
                    onPressed: _addRow,
                    icon: const Icon(Icons.add_circle_outline, size: 20),
                    label: const Text('Ongeza Mstari'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
