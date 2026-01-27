import '../../shared/models/questionnaire.dart';

class FormProgressCalculator {
  /// Calculate the completion percentage of a survey
  static double calculateProgress({
    required QuestionnaireDetail questionnaireDetail,
    required Map<String, Map<String, dynamic>> formDataByFormSlug,
  }) {
    int totalRequiredFields = 0;
    int completedRequiredFields = 0;
    int totalOptionalFields = 0;
    int completedOptionalFields = 0;

    for (final section in questionnaireDetail.sections) {
      for (final form in section.forms) {
        final formData = formDataByFormSlug[form.slug] ?? {};

        for (final field in form.customFormFields) {
          if (field.required) {
            totalRequiredFields++;
            if (_isFieldCompleted(field, formData[field.name])) {
              completedRequiredFields++;
            }
          } else {
            totalOptionalFields++;
            if (_isFieldCompleted(field, formData[field.name])) {
              completedOptionalFields++;
            }
          }
        }
      }
    }

    // Required fields are weighted more heavily (70%)
    // Optional fields contribute 30%
    final totalFields = totalRequiredFields + totalOptionalFields;
    if (totalFields == 0) return 0.0;

    final requiredWeight = 0.7;
    final optionalWeight = 0.3;

    final requiredProgress =
        totalRequiredFields > 0
            ? (completedRequiredFields / totalRequiredFields) * requiredWeight
            : 0.0;

    final optionalProgress =
        totalOptionalFields > 0
            ? (completedOptionalFields / totalOptionalFields) * optionalWeight
            : 0.0;

    return (requiredProgress + optionalProgress) * 100;
  }

  /// Check if all required fields are completed
  static bool areRequiredFieldsComplete({
    required QuestionnaireDetail questionnaireDetail,
    required Map<String, Map<String, dynamic>> formDataByFormSlug,
  }) {
    for (final section in questionnaireDetail.sections) {
      for (final form in section.forms) {
        final formData = formDataByFormSlug[form.slug] ?? {};

        for (final field in form.customFormFields) {
          if (field.required &&
              !_isFieldCompleted(field, formData[field.name])) {
            return false;
          }
        }
      }
    }
    return true;
  }

  /// Get list of incomplete required fields
  static List<String> getIncompleteRequiredFields({
    required QuestionnaireDetail questionnaireDetail,
    required Map<String, Map<String, dynamic>> formDataByFormSlug,
  }) {
    final incompleteFields = <String>[];

    for (final section in questionnaireDetail.sections) {
      for (final form in section.forms) {
        final formData = formDataByFormSlug[form.slug] ?? {};

        for (final field in form.customFormFields) {
          if (field.required &&
              !_isFieldCompleted(field, formData[field.name])) {
            incompleteFields.add('${form.name}: ${field.label}');
          }
        }
      }
    }

    return incompleteFields;
  }

  static bool _isFieldCompleted(CustomFormField field, dynamic value) {
    if (value == null) return false;

    switch (field.type.toLowerCase()) {
      case 'text':
      case 'email':
      case 'number':
      case 'textarea':
      case 'date':
      case 'select':
      case 'file':
      case 'camera':
      case 'image':
        return value.toString().trim().isNotEmpty;

      case 'multiselect':
        return value is List && value.isNotEmpty;

      case 'table':
        return value is List && value.isNotEmpty;

      default:
        return value.toString().trim().isNotEmpty;
    }
  }
}
