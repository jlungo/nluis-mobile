import 'package:flutter/material.dart';

class BackendColumn {
  final int position;
  final String name;
  final String label;
  final String type; // "text", "number", "select"
  final List<String>? options;

  BackendColumn({
    required this.position,
    required this.name,
    required this.label,
    required this.type,
    this.options,
  });

  factory BackendColumn.fromJson(Map<String, dynamic> json) {
    return BackendColumn(
      position: json['position'],
      name: json['name'],
      label: json['label'],
      type: json['type'] ?? 'text',
      options: (json['options'] as List?)?.cast<String>(),
    );
  }
}

class BackendRow {
  final int position;
  final Map<String, String> data;

  BackendRow({required this.position, required this.data});

  factory BackendRow.fromJson(Map<String, dynamic> json) {
    return BackendRow(
      position: json['position'],
      data: Map<String, String>.from(json['data'] ?? {}),
    );
  }
}

/// Table coming from backend
class BackendTable {
  final String label;
  final bool required;
  final List<BackendColumn> columns;
  final List<BackendRow> rows;

  BackendTable({
    required this.label,
    required this.required,
    required this.columns,
    required this.rows,
  });

  factory BackendTable.fromJson(Map<String, dynamic> json) {
    return BackendTable(
      label: json['label'],
      required: json['required'] ?? false,
      columns: (json['columns'] as List)
          .map((col) => BackendColumn.fromJson(col))
          .toList(),
      rows: (json['rows'] as List)
          .map((row) => BackendRow.fromJson(row))
          .toList(),
    );
  }
}

class DynamicFillableTable extends StatefulWidget {
  final BackendTable tableData;
  final bool readOnly;

  const DynamicFillableTable({
    super.key,
    required this.tableData,
    this.readOnly = false,
  });

  @override
  State<DynamicFillableTable> createState() => _DynamicFillableTableState();
}

class _DynamicFillableTableState extends State<DynamicFillableTable> {
  late List<BackendRow> rows;

  @override
  void initState() {
    super.initState();
    rows = widget.tableData.rows;
  }

  Widget _buildCell(
      BackendColumn column, BackendRow row, String? currentValue) {
    if (widget.readOnly) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Text(currentValue ?? '',
            style: const TextStyle(color: Colors.black87)),
      );
    }

    switch (column.type) {
      case 'number':
        return TextFormField(
          initialValue: currentValue,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
          ),
          onChanged: (v) => row.data[column.name] = v,
        );
      case 'select':
        return DropdownButtonFormField<String>(
          value: currentValue?.isNotEmpty == true ? currentValue : null,
          isExpanded: true,
          items: column.options
              ?.map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
              .toList(),
          decoration: const InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
          ),
          onChanged: (v) => row.data[column.name] = v ?? '',
        );
      default:
        return TextFormField(
          initialValue: currentValue,
          decoration: const InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
          ),
          onChanged: (v) => row.data[column.name] = v,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final columns = widget.tableData.columns;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Table label
        Row(
          children: [
            Text(widget.tableData.label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            if (widget.tableData.required)
              const Text(' *', style: TextStyle(color: Colors.red)),
          ],
        ),
        const SizedBox(height: 8),

        // Scrollable table
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor:
                WidgetStatePropertyAll(Colors.grey.shade200),
            columns: [
              const DataColumn(label: Text('No.')),
              ...columns.map(
                  (c) => DataColumn(label: Text(c.label, softWrap: true))),
            ],
            rows: rows.map((row) {
              return DataRow(
                cells: [
                  DataCell(Text(row.position.toString())),
                  ...columns.map(
                    (col) => DataCell(
                      _buildCell(col, row, row.data[col.name]),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
