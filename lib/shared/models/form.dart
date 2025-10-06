import 'dart:convert';
import 'package:equatable/equatable.dart';

class FormModel extends Equatable {
  final String slug;
  final int? questionnaireId;
  final String name;
  final String description;
  final String moduleSlug;
  final String workflowSlug;
  final int position;
  final int updatedAt;
  final List<FormFieldModel> fields;

  const FormModel({
    required this.slug,
    this.questionnaireId,
    required this.name,
    required this.description,
    required this.moduleSlug,
    required this.workflowSlug,
    required this.position,
    required this.updatedAt,
    this.fields = const [],
  });

  @override
  List<Object?> get props => [
        slug,
        questionnaireId,
        name,
        description,
        moduleSlug,
        workflowSlug,
        position,
        updatedAt,
        fields,
      ];

  factory FormModel.fromJson(Map<String, dynamic> json) {
    return FormModel(
      slug: json['slug'] as String,
      questionnaireId: json['questionnaire_id'] as int?,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      moduleSlug: json['module_slug'] as String? ?? json['moduleSlug'] as String? ?? '',
      workflowSlug: json['workflow_slug'] as String? ?? json['workflowSlug'] as String? ?? '',
      position: json['position'] as int? ?? 0,
      updatedAt: json['updated_at'] as int? ??
                 json['updatedAt'] as int? ??
                 DateTime.now().millisecondsSinceEpoch,
      fields: (json['fields'] as List<dynamic>?)
              ?.map((e) => FormFieldModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'questionnaire_id': questionnaireId,
      'name': name,
      'description': description,
      'module_slug': moduleSlug,
      'workflow_slug': workflowSlug,
      'position': position,
      'updated_at': updatedAt,
      'fields': fields.map((f) => f.toJson()).toList(),
    };
  }
}

class FormFieldModel extends Equatable {
  final int id;
  final String formSlug;
  final String label;
  final String type;
  final String name;
  final bool required;
  final int position;
  final Map<String, dynamic>? options;

  const FormFieldModel({
    required this.id,
    required this.formSlug,
    required this.label,
    required this.type,
    required this.name,
    required this.required,
    required this.position,
    this.options,
  });

  @override
  List<Object?> get props => [
        id,
        formSlug,
        label,
        type,
        name,
        required,
        position,
        options,
      ];

  factory FormFieldModel.fromJson(Map<String, dynamic> json) {
    return FormFieldModel(
      id: json['id'] as int,
      formSlug: json['form_slug'] as String? ?? json['formSlug'] as String? ?? '',
      label: json['label'] as String,
      type: json['type'] as String,
      name: json['name'] as String,
      required: json['required'] as bool? ?? false,
      position: json['position'] as int? ?? 0,
      options: json['options'] != null
          ? (json['options'] is String
              ? jsonDecode(json['options'] as String) as Map<String, dynamic>?
              : json['options'] as Map<String, dynamic>?)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'form_slug': formSlug,
      'label': label,
      'type': type,
      'name': name,
      'required': required,
      'position': position,
      'options': options,
    };
  }
}
