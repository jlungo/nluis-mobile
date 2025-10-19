import 'package:flutter/material.dart';
import 'dart:io';
import '../../models/questionnaire.dart';
import 'form_fields/text_form_field_widget.dart';
import 'form_fields/textarea_form_field_widget.dart';
import 'form_fields/select_form_field_widget.dart';
import 'form_fields/checkbox_form_field_widget.dart';
import 'form_fields/date_form_field_widget.dart';
import 'form_fields/file_form_field_widget.dart';
import 'form_fields/multiselect_form_field_widget.dart';
import 'form_fields/table_form_field_widget.dart' as table;
import 'form_fields/zoning_form_field_widget.dart';

class FormFieldBuilder extends StatefulWidget {
  final CustomFormField field;
  final dynamic value;
  final Function(dynamic)? onChanged;
  final bool isReadOnly;

  const FormFieldBuilder({
    super.key,
    required this.field,
    this.value,
    required this.onChanged,
    this.isReadOnly = false,
  });

  @override
  State<FormFieldBuilder> createState() => _FormFieldBuilderState();
}

class _FormFieldBuilderState extends State<FormFieldBuilder> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.value?.toString() ?? '',
    );
    if (!widget.isReadOnly) {
      _textController.addListener(_onTextChanged);
    }
  }

  void _onTextChanged() {
    if (widget.onChanged != null) {
      widget.onChanged!(_textController.text);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.field.type.toLowerCase()) {
      case 'text':
        return TextFormFieldWidget(
          label: widget.field.label,
          placeholder: widget.field.placeholder,
          required: widget.field.required,
          controller: _textController,
          enabled: !widget.isReadOnly,
          validator:
              widget.field.required
                  ? (value) =>
                      value?.isEmpty ?? true ? 'Hii sehemu inahitajika' : null
                  : null,
        );

      case 'email':
        return TextFormFieldWidget(
          label: widget.field.label,
          placeholder: widget.field.placeholder,
          required: widget.field.required,
          controller: _textController,
          keyboardType: TextInputType.emailAddress,
          enabled: !widget.isReadOnly,
          validator:
              widget.field.required
                  ? (value) {
                    if (value?.isEmpty ?? true) return 'Hii sehemu inahitajika';
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value!)) {
                      return 'Weka barua pepe sahihi';
                    }
                    return null;
                  }
                  : null,
        );

      case 'number':
        return TextFormFieldWidget(
          label: widget.field.label,
          placeholder: widget.field.placeholder,
          required: widget.field.required,
          controller: _textController,
          keyboardType: TextInputType.number,
          enabled: !widget.isReadOnly,
          validator:
              widget.field.required
                  ? (value) {
                    if (value?.isEmpty ?? true) return 'Hii sehemu inahitajika';
                    if (double.tryParse(value!) == null) {
                      return 'Weka namba sahihi';
                    }
                    return null;
                  }
                  : null,
        );

      case 'textarea':
        return TextareaFormFieldWidget(
          label: widget.field.label,
          placeholder: widget.field.placeholder,
          required: widget.field.required,
          controller: _textController,
          enabled: !widget.isReadOnly,
          validator:
              widget.field.required
                  ? (value) =>
                      value?.isEmpty ?? true ? 'Hii sehemu inahitajika' : null
                  : null,
        );

      case 'select':
        return SelectFormFieldWidget(
          label: widget.field.label,
          placeholder: widget.field.placeholder,
          required: widget.field.required,
          options: widget.field.selectOptions,
          value: widget.value as String?,
          enabled: !widget.isReadOnly,
          onChanged: widget.isReadOnly ? null : (value) {
            widget.onChanged?.call(value);
          },
          validator:
              widget.field.required
                  ? (value) => value == null ? 'Hii sehemu inahitajika' : null
                  : null,
        );

      case 'checkbox':
        return CheckboxFormFieldWidget(
          label: widget.field.label,
          required: widget.field.required,
          value: widget.value as bool? ?? false,
          enabled: !widget.isReadOnly,
          onChanged: widget.isReadOnly ? null : (value) {
            widget.onChanged?.call(value ?? false);
          },
        );

      case 'date':
        return DateFormFieldWidget(
          label: widget.field.label,
          placeholder: widget.field.placeholder,
          required: widget.field.required,
          value: widget.value as DateTime?,
          enabled: !widget.isReadOnly,
          onChanged: widget.isReadOnly ? null : (value) {
            widget.onChanged?.call(value);
          },
          validator:
              widget.field.required
                  ? (value) => value == null ? 'Hii sehemu inahitajika' : null
                  : null,
        );

      case 'file':
        return FileFormFieldWidget(
          label: widget.field.label,
          required: widget.field.required,
          value: widget.value as File?,
          enabled: !widget.isReadOnly,
          onPickFile: widget.isReadOnly ? null : () async {
            // TODO: Implement file picker
            // final file = await FilePicker.pickFile();
            // widget.onChanged(file);
          },
          onRemove: widget.isReadOnly ? null : () {
            widget.onChanged?.call(null);
          },
        );

      case 'multiselect':
        return MultiselectFormFieldWidget(
          label: widget.field.label,
          placeholder: widget.field.placeholder,
          required: widget.field.required,
          options: widget.field.selectOptions,
          values: widget.value as List<String>? ?? [],
          enabled: !widget.isReadOnly,
          onChanged: widget.isReadOnly ? null : (values) {
            widget.onChanged?.call(values);
          },
        );

      case 'table':
        // Parse existing rows from saved value
        final existingData = widget.value as Map<String, dynamic>?;
        final existingRows = existingData?['rows'] as List<dynamic>?;

        // Create table from field's select options (columns)
        final tableData = table.DynamicTable.fromField(
          label: widget.field.label,
          required: widget.field.required,
          selectOptions: widget.field.selectOptions.map((opt) => {
            'position': opt.position,
            'value': opt.value,
            'text_label': opt.textLabel,
          }).toList(),
          existingRows: existingRows,
        );

        return table.DynamicFillableTable(
          tableData: tableData,
          readOnly: widget.isReadOnly,
          onChanged: widget.isReadOnly ? null : (rows) {
            // Save table data when changed
            widget.onChanged?.call({
              'rows': rows.map((r) => r.toJson()).toList(),
            });
          },
        );

      case 'zoning':
        return ZoningFormFieldWidget(
          label: widget.field.label,
          required: widget.field.required,
          value: widget.value as Map<String, dynamic>?,
          enabled: !widget.isReadOnly,
          onChanged: widget.isReadOnly ? null : (value) {
            widget.onChanged?.call(value);
          },
        );

      default:
        return TextFormFieldWidget(
          label: widget.field.label,
          placeholder: widget.field.placeholder,
          required: widget.field.required,
          controller: _textController,
          enabled: !widget.isReadOnly,
          validator:
              widget.field.required
                  ? (value) =>
                      value?.isEmpty ?? true ? 'Hii sehemu inahitajika' : null
                  : null,
        );
    }
  }
}
