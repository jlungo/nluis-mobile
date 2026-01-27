import 'package:flutter/material.dart';
import '../../models/questionnaire.dart';
import 'form_fields/text_form_field_widget.dart';
import 'form_fields/select_form_field_widget.dart';
import 'form_fields/date_form_field_widget.dart';
import 'form_fields/multiselect_form_field_widget.dart';
import 'form_fields/file_form_field_widget.dart';
import 'form_fields/camera_form_field_widget.dart';
import 'form_fields/table_form_field_widget.dart';

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
    if (!widget.isReadOnly && widget.onChanged != null) {
      _textController.addListener(_onTextChanged);
    }
  }

  void _onTextChanged() {
    if (widget.onChanged != null) {
      widget.onChanged!(_textController.text);
    }
  }

  @override
  void didUpdateWidget(FormFieldBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value &&
        widget.value != _textController.text) {
      _textController.text = widget.value?.toString() ?? '';
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
      case 'email':
        return TextFormFieldWidget(
          label: widget.field.label,
          placeholder: widget.field.placeholder,
          required: widget.field.required,
          controller: _textController,
          enabled: !widget.isReadOnly,
          keyboardType:
              widget.field.type.toLowerCase() == 'email'
                  ? TextInputType.emailAddress
                  : TextInputType.text,
          validator:
              widget.field.required
                  ? (value) =>
                      value?.isEmpty ?? true ? 'Hii sehemu inahitajika' : null
                  : null,
        );

      case 'number':
        return TextFormFieldWidget(
          label: widget.field.label,
          placeholder: widget.field.placeholder,
          required: widget.field.required,
          controller: _textController,
          enabled: !widget.isReadOnly,
          keyboardType: TextInputType.number,
          validator:
              widget.field.required
                  ? (value) =>
                      value?.isEmpty ?? true ? 'Hii sehemu inahitajika' : null
                  : null,
        );

      case 'textarea':
        return TextFormFieldWidget(
          label: widget.field.label,
          placeholder: widget.field.placeholder,
          required: widget.field.required,
          controller: _textController,
          enabled: !widget.isReadOnly,
          maxLines: 4,
          validator:
              widget.field.required
                  ? (value) =>
                      value?.isEmpty ?? true ? 'Hii sehemu inahitajika' : null
                  : null,
        );

      case 'select':
        return SelectFormFieldWidget(
          label: widget.field.label,
          required: widget.field.required,
          options: widget.field.selectOptions,
          value: widget.value?.toString(),
          onChanged:
              widget.isReadOnly
                  ? (_) {}
                  : (value) {
                    if (widget.onChanged != null) {
                      widget.onChanged!(value);
                    }
                  },
          enabled: !widget.isReadOnly,
        );

      case 'date':
        return DateFormFieldWidget(
          label: widget.field.label,
          required: widget.field.required,
          value:
              widget.value is DateTime
                  ? widget.value as DateTime
                  : (widget.value is String &&
                          widget.value.toString().isNotEmpty
                      ? DateTime.tryParse(widget.value.toString())
                      : null),
          onChanged:
              widget.isReadOnly
                  ? (_) {}
                  : (value) {
                    if (widget.onChanged != null) {
                      widget.onChanged!(value);
                    }
                  },
          enabled: !widget.isReadOnly,
        );

      case 'multiselect':
        final valueList =
            widget.value is List
                ? (widget.value as List).map((e) => e.toString()).toList()
                : (widget.value is String && widget.value.toString().isNotEmpty
                    ? [widget.value.toString()]
                    : <String>[]);
        return MultiselectFormFieldWidget(
          label: widget.field.label,
          required: widget.field.required,
          options: widget.field.selectOptions,
          values: valueList,
          onChanged:
              widget.isReadOnly
                  ? null
                  : (value) {
                    if (widget.onChanged != null) {
                      widget.onChanged!(value);
                    }
                  },
          enabled: !widget.isReadOnly,
        );

      case 'file':
        return FileFormFieldWidget(
          label: widget.field.label,
          required: widget.field.required,
          value: widget.value?.toString(),
          onChanged:
              widget.isReadOnly
                  ? null
                  : (value) {
                    if (widget.onChanged != null) {
                      widget.onChanged!(value);
                    }
                  },
          enabled: !widget.isReadOnly,
        );

      case 'camera':
      case 'image':
        return CameraFormFieldWidget(
          label: widget.field.label,
          required: widget.field.required,
          value: widget.value?.toString(),
          onChanged:
              widget.isReadOnly
                  ? null
                  : (value) {
                    if (widget.onChanged != null) {
                      widget.onChanged!(value);
                    }
                  },
          enabled: !widget.isReadOnly,
        );

      case 'table':
        final tableValue =
            widget.value is List
                ? (widget.value as List)
                    .map(
                      (e) =>
                          e is Map<String, dynamic> ? e : <String, dynamic>{},
                    )
                    .toList()
                : <Map<String, dynamic>>[];
        return TableFormFieldWidget(
          label: widget.field.label,
          required: widget.field.required,
          value: tableValue,
          onChanged:
              widget.isReadOnly
                  ? null
                  : (value) {
                    if (widget.onChanged != null) {
                      widget.onChanged!(value);
                    }
                  },
          enabled: !widget.isReadOnly,
          columns: ['column1', 'column2'],
          columnLabels: ['Jina', 'Thamani'],
        );

      default:
        return TextFormFieldWidget(
          label: widget.field.label,
          placeholder: 'Aina ya sehemu hii bado haijatekelezwa',
          required: widget.field.required,
          controller: _textController,
          enabled: false,
        );
    }
  }
}
