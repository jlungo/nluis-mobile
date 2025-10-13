import 'package:equatable/equatable.dart';

class Questionnaire extends Equatable {
  final String slug;
  final String name;
  final int category;
  final String description;
  final int version;
  final bool isActive;
  final String moduleSlug;
  final String moduleName;
  final int questionnaireSectionsCount;

  const Questionnaire({
    required this.slug,
    required this.name,
    required this.category,
    required this.description,
    required this.version,
    required this.isActive,
    required this.moduleSlug,
    required this.moduleName,
    required this.questionnaireSectionsCount,
  });

  @override
  List<Object?> get props => [
        slug,
        name,
        category,
        description,
        version,
        isActive,
        moduleSlug,
        moduleName,
        questionnaireSectionsCount,
      ];
}

class QuestionnaireModel extends Questionnaire {
  const QuestionnaireModel({
    required super.slug,
    required super.name,
    required super.category,
    required super.description,
    required super.version,
    required super.isActive,
    required super.moduleSlug,
    required super.moduleName,
    required super.questionnaireSectionsCount,
  });

  factory QuestionnaireModel.fromJson(Map<String, dynamic> json) {
    return QuestionnaireModel(
      slug: json['slug'] as String,
      name: json['name'] as String,
      category: json['category'] as int,
      description: json['description'] as String? ?? '',
      version: json['version'] as int,
      isActive: json['is_active'] as bool? ?? true,
      moduleSlug: json['module_slug'] as String,
      moduleName: json['module_name'] as String,
      questionnaireSectionsCount: json['questionnaire_sections_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'category': category,
      'description': description,
      'version': version,
      'is_active': isActive,
      'module_slug': moduleSlug,
      'module_name': moduleName,
      'questionnaire_sections_count': questionnaireSectionsCount,
    };
  }
}

class CustomFormField extends Equatable {
  final String id;
  final String label;
  final String type;
  final String typeDisplay;
  final String placeholder;
  final String name;
  final bool required;
  final int position;
  final bool isActive;
  final List<SelectOption> selectOptions;

  const CustomFormField({
    required this.id,
    required this.label,
    required this.type,
    required this.typeDisplay,
    required this.placeholder,
    required this.name,
    required this.required,
    required this.position,
    required this.isActive,
    required this.selectOptions,
  });

  @override
  List<Object?> get props => [
        id,
        label,
        type,
        typeDisplay,
        placeholder,
        name,
        required,
        position,
        isActive,
        selectOptions,
      ];
}

class CustomFormFieldModel extends CustomFormField {
  const CustomFormFieldModel({
    required super.id,
    required super.label,
    required super.type,
    required super.typeDisplay,
    required super.placeholder,
    required super.name,
    required super.required,
    required super.position,
    required super.isActive,
    required super.selectOptions,
  });

  factory CustomFormFieldModel.fromJson(Map<String, dynamic> json) {
    final options = (json['questionnaire_select_options'] as List<dynamic>?)
            ?.map((opt) => SelectOptionModel.fromJson(opt as Map<String, dynamic>))
            .toList() ??
        [];

    return CustomFormFieldModel(
      id: json['id'].toString(),
      label: json['label'] as String,
      type: json['type'] as String,
      typeDisplay: json['type_display'] as String? ?? '',
      placeholder: json['placeholder'] as String? ?? '',
      name: json['name'] as String,
      required: json['required'] as bool? ?? false,
      position: json['position'] as int,
      isActive: json['is_active'] as bool? ?? true,
      selectOptions: options,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'type': type,
      'type_display': typeDisplay,
      'placeholder': placeholder,
      'name': name,
      'required': required,
      'position': position,
      'is_active': isActive,
      'questionnaire_select_options': selectOptions.map((opt) => (opt as SelectOptionModel).toJson()).toList(),
    };
  }
}

// Select Option for dropdowns/multiselect
class SelectOption extends Equatable {
  final String textLabel;
  final String value;
  final int position;

  const SelectOption({
    required this.textLabel,
    required this.value,
    required this.position,
  });

  @override
  List<Object?> get props => [textLabel, value, position];
}

class SelectOptionModel extends SelectOption {
  const SelectOptionModel({
    required super.textLabel,
    required super.value,
    required super.position,
  });

  factory SelectOptionModel.fromJson(Map<String, dynamic> json) {
    return SelectOptionModel(
      textLabel: json['text_label'] as String,
      value: json['value'] as String,
      position: json['position'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text_label': textLabel,
      'value': value,
      'position': position,
    };
  }
}

class QuestionnaireForm extends Equatable {
  final String slug;
  final String name;
  final String description;
  final bool isActive;
  final String questionnaireSectionSlug;
  final String questionnaireSectionName;
  final String questionnaireSlug;
  final String questionnaireName;
  final String moduleSlug;
  final String moduleName;
  final int position;
  final List<CustomFormField> customFormFields;

  const QuestionnaireForm({
    required this.slug,
    required this.name,
    required this.description,
    required this.isActive,
    required this.questionnaireSectionSlug,
    required this.questionnaireSectionName,
    required this.questionnaireSlug,
    required this.questionnaireName,
    required this.moduleSlug,
    required this.moduleName,
    required this.position,
    required this.customFormFields,
  });

  @override
  List<Object?> get props => [
        slug,
        name,
        description,
        isActive,
        questionnaireSectionSlug,
        questionnaireSectionName,
        questionnaireSlug,
        questionnaireName,
        moduleSlug,
        moduleName,
        position,
        customFormFields,
      ];
}

class QuestionnaireFormModel extends QuestionnaireForm {
  const QuestionnaireFormModel({
    required super.slug,
    required super.name,
    required super.description,
    required super.isActive,
    required super.questionnaireSectionSlug,
    required super.questionnaireSectionName,
    required super.questionnaireSlug,
    required super.questionnaireName,
    required super.moduleSlug,
    required super.moduleName,
    required super.position,
    required super.customFormFields,
  });

  factory QuestionnaireFormModel.fromJson(Map<String, dynamic> json) {
    final fields = (json['custom_form_fields'] as List<dynamic>?)
            ?.map((field) => CustomFormFieldModel.fromJson(field as Map<String, dynamic>))
            .toList() ??
        [];

    return QuestionnaireFormModel(
      slug: json['slug'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      questionnaireSectionSlug: json['questionnaire_section_slug'] as String,
      questionnaireSectionName: json['questionnaire_section_name'] as String,
      questionnaireSlug: json['questionnaire_slug'] as String,
      questionnaireName: json['questionnaire_name'] as String,
      moduleSlug: json['module_slug'] as String,
      moduleName: json['module_name'] as String,
      position: json['position'] as int,
      customFormFields: fields,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'description': description,
      'is_active': isActive,
      'questionnaire_section_slug': questionnaireSectionSlug,
      'questionnaire_section_name': questionnaireSectionName,
      'questionnaire_slug': questionnaireSlug,
      'questionnaire_name': questionnaireName,
      'module_slug': moduleSlug,
      'module_name': moduleName,
      'position': position,
      'custom_form_fields': customFormFields.map((f) => (f as CustomFormFieldModel).toJson()).toList(),
    };
  }
}

// Questionnaire Section (groups forms together)
class QuestionnaireSection extends Equatable {
  final String slug;
  final String name;
  final String description;
  final int position;
  final bool isActive;
  final String questionnaireSlug;
  final String questionnaireName;
  final String moduleSlug;
  final String moduleName;
  final List<QuestionnaireForm> forms;

  const QuestionnaireSection({
    required this.slug,
    required this.name,
    required this.description,
    required this.position,
    required this.isActive,
    required this.questionnaireSlug,
    required this.questionnaireName,
    required this.moduleSlug,
    required this.moduleName,
    required this.forms,
  });

  @override
  List<Object?> get props => [
        slug,
        name,
        description,
        position,
        isActive,
        questionnaireSlug,
        questionnaireName,
        moduleSlug,
        moduleName,
        forms,
      ];
}

class QuestionnaireSectionModel extends QuestionnaireSection {
  const QuestionnaireSectionModel({
    required super.slug,
    required super.name,
    required super.description,
    required super.position,
    required super.isActive,
    required super.questionnaireSlug,
    required super.questionnaireName,
    required super.moduleSlug,
    required super.moduleName,
    required super.forms,
  });

  factory QuestionnaireSectionModel.fromJson(Map<String, dynamic> json) {
    final forms = (json['questionnaire_section_forms'] as List<dynamic>?)
            ?.map((form) => QuestionnaireFormModel.fromJson(form as Map<String, dynamic>))
            .toList() ??
        [];

    return QuestionnaireSectionModel(
      slug: json['slug'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      position: json['position'] as int,
      isActive: json['is_active'] as bool? ?? true,
      questionnaireSlug: json['questionnaire_slug'] as String,
      questionnaireName: json['questionnaire_name'] as String,
      moduleSlug: json['module_slug'] as String,
      moduleName: json['module_name'] as String,
      forms: forms,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'description': description,
      'position': position,
      'is_active': isActive,
      'questionnaire_slug': questionnaireSlug,
      'questionnaire_name': questionnaireName,
      'module_slug': moduleSlug,
      'module_name': moduleName,
      'questionnaire_section_forms': forms.map((f) => (f as QuestionnaireFormModel).toJson()).toList(),
    };
  }
}

class QuestionnaireDetail extends Equatable {
  final String slug;
  final String name;
  final int category;
  final String description;
  final String moduleSlug;
  final String moduleName;
  final int version;
  final List<QuestionnaireSection> sections;

  const QuestionnaireDetail({
    required this.slug,
    required this.name,
    required this.category,
    required this.description,
    required this.moduleSlug,
    required this.moduleName,
    required this.version,
    required this.sections,
  });

  @override
  List<Object?> get props => [
        slug,
        name,
        category,
        description,
        moduleSlug,
        moduleName,
        version,
        sections,
      ];
}

class QuestionnaireDetailModel extends QuestionnaireDetail {
  const QuestionnaireDetailModel({
    required super.slug,
    required super.name,
    required super.category,
    required super.description,
    required super.moduleSlug,
    required super.moduleName,
    required super.version,
    required super.sections,
  });

  factory QuestionnaireDetailModel.fromJson(Map<String, dynamic> json) {
    final sections = (json['questionnaire_sections'] as List<dynamic>?)
            ?.map((section) => QuestionnaireSectionModel.fromJson(section as Map<String, dynamic>))
            .toList() ??
        [];

    return QuestionnaireDetailModel(
      slug: json['slug'] as String,
      name: json['name'] as String,
      category: json['category'] as int,
      description: json['description'] as String? ?? '',
      moduleSlug: json['module_slug'] as String,
      moduleName: json['module_name'] as String,
      version: json['version'] as int,
      sections: sections,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'category': category,
      'description': description,
      'module_slug': moduleSlug,
      'module_name': moduleName,
      'version': version,
      'questionnaire_sections': sections.map((s) => (s as QuestionnaireSectionModel).toJson()).toList(),
    };
  }
}
