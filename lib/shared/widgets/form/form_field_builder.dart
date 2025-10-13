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
  final Function(dynamic) onChanged;

  const FormFieldBuilder({
    super.key,
    required this.field,
    this.value,
    required this.onChanged,
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
    _textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    widget.onChanged(_textController.text);
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
          onChanged: (value) {
            widget.onChanged(value);
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
          onChanged: (value) {
            widget.onChanged(value ?? false);
          },
        );

      case 'date':
        return DateFormFieldWidget(
          label: widget.field.label,
          placeholder: widget.field.placeholder,
          required: widget.field.required,
          value: widget.value as DateTime?,
          onChanged: (value) {
            widget.onChanged(value);
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
          onPickFile: () async {
            // TODO: Implement file picker
            // final file = await FilePicker.pickFile();
            // widget.onChanged(file);
          },
          onRemove: () {
            widget.onChanged(null);
          },
        );

      case 'multiselect':
        return MultiselectFormFieldWidget(
          label: widget.field.label,
          placeholder: widget.field.placeholder,
          required: widget.field.required,
          options: widget.field.selectOptions,
          values: widget.value as List<String>? ?? [],
          onChanged: (values) {
            widget.onChanged(values);
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
          readOnly: false,
          onChanged: (rows) {
            // Save table data when changed
            widget.onChanged({
              'rows': rows.map((r) => r.toJson()).toList(),
            });
          },
        );

      case 'zoning':
        return ZoningFormFieldWidget(
          label: widget.field.label,
          required: widget.field.required,
          value: widget.value as Map<String, dynamic>?,
          onChanged: (value) {
            widget.onChanged(value);
          },
        );

      default:
        return TextFormFieldWidget(
          label: widget.field.label,
          placeholder: widget.field.placeholder,
          required: widget.field.required,
          controller: _textController,
          validator:
              widget.field.required
                  ? (value) =>
                      value?.isEmpty ?? true ? 'Hii sehemu inahitajika' : null
                  : null,
        );
    }
  }
}
