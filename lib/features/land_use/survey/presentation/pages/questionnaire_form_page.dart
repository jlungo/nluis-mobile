import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nluis_app/shared/widgets/form/form_completion_state.dart';
import 'package:nluis_app/shared/widgets/form/form_section_card.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/models/questionnaire.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/utils/snackbar_utils.dart';
import '../providers/questionnaire_providers.dart';
import '../../../../../data/local/draft_provider.dart';

class QuestionnaireFormPage extends ConsumerStatefulWidget {
  final String questionnaireSlug;
  final String projectId;
  final String projectName;
  final String? surveyId; // if provided, load existing survey data

  const QuestionnaireFormPage({
    super.key,
    required this.questionnaireSlug,
    required this.projectId,
    required this.projectName,
    this.surveyId,
  });

  @override
  ConsumerState<QuestionnaireFormPage> createState() =>
      _QuestionnaireFormPageState();
}

class _SurveyProgress {
  final Map<String, FormCompletionState> formStatuses;
  final Map<String, FormCompletionState> sectionStatuses;
  final List<String> incompleteFormNames;
  final List<String> incompleteSectionNames;
  final bool hasAnyData;

  const _SurveyProgress({
    required this.formStatuses,
    required this.sectionStatuses,
    required this.incompleteFormNames,
    required this.incompleteSectionNames,
    required this.hasAnyData,
  });

  bool get isComplete =>
      incompleteFormNames.isEmpty && incompleteSectionNames.isEmpty;
}

class _QuestionnaireFormPageState extends ConsumerState<QuestionnaireFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Form data organized by form slug
  final Map<String, Map<String, dynamic>> _formDataByFormSlug = {};
  final Map<String, bool> _expandedSections = {};
  final Map<String, bool> _expandedForms = {};
  final Map<String, DateTime?> _formLastSavedAt = {};

  // Current survey ID (empty means new survey)
  String? _currentSurveyId;

  @override
  void initState() {
    super.initState();
    _currentSurveyId = widget.surveyId; // Set if opening existing survey
    _cleanupExpiredDrafts();
    if (widget.surveyId != null) {
      _loadExistingSurvey();
    }
  }

  // Clean up drafts older than 30 days
  Future<void> _cleanupExpiredDrafts() async {
    final draftService = ref.read(draftServiceProvider);
    await draftService.deleteExpiredDrafts();
  }

  // Load existing survey data
  Future<void> _loadExistingSurvey() async {
    if (widget.surveyId == null) return;

    try {
      final database = ref.read(databaseProvider);

      // Get all forms for this survey
      final responses = await (database.select(database.surveyResponses)
            ..where((tbl) => tbl.surveyId.equals(widget.surveyId!)))
          .get();

      if (responses.isEmpty || !mounted) return;

      // Load form data into state
      for (final response in responses) {
        try {
          final formData = jsonDecode(response.answersJson);
          if (formData is Map<String, dynamic>) {
            setState(() {
              _formDataByFormSlug[response.formSlug ?? ''] = Map<String, dynamic>.from(formData);
            });
          }
        } catch (e) {
          debugPrint('Error parsing form data: $e');
        }
      }
    } catch (e) {
      debugPrint('Error loading survey: $e');
    }
  }

  void _onFieldChanged(String formSlug, String fieldId, dynamic value) {
    setState(() {
      final formData =
          _formDataByFormSlug.putIfAbsent(formSlug, () => <String, dynamic>{});
      if (_isMeaningfulValue(value)) {
        formData[fieldId] = value;
      } else {
        formData.remove(fieldId);
      }

      if (formData.isEmpty) {
        _formDataByFormSlug.remove(formSlug);
      }
    });
  }

  bool _isMeaningfulValue(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) return value.trim().isNotEmpty;
    if (value is num) return true;
    if (value is DateTime) return true;
    if (value is List) return value.any(_isMeaningfulValue);
    if (value is Map<String, dynamic>) {
      if (value.containsKey('rows') && value['rows'] is List) {
        return (value['rows'] as List).isNotEmpty;
      }
      return value.values.any(_isMeaningfulValue);
    }
    return true;
  }

  bool _hasAnyValue(Map<String, dynamic>? formData) {
    if (formData == null || formData.isEmpty) return false;
    return formData.values.any(_isMeaningfulValue);
  }

  Map<String, dynamic> _prepareFormDataForStorage(
    Map<String, dynamic> formData,
  ) {
    return formData.map(
      (key, value) => MapEntry(key, _serializeValueForStorage(value)),
    );
  }

  dynamic _serializeValueForStorage(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value.toIso8601String();
    if (value is List) {
      return value.map(_serializeValueForStorage).toList();
    }
    if (value is Map) {
      return value.map(
        (key, item) => MapEntry(
          key,
          _serializeValueForStorage(item),
        ),
      );
    }
    return value;
  }

  bool _formHasRequiredFields(QuestionnaireForm form) {
    return form.customFormFields.any((field) => field.required);
  }

  bool _isRequiredFieldFilled(
    CustomFormField field,
    Map<String, dynamic>? formData,
  ) {
    final value = formData?[field.id];

    switch (field.type.toLowerCase()) {
      case 'text':
      case 'textarea':
      case 'email':
      case 'number':
        return value != null && value.toString().trim().isNotEmpty;
      case 'select':
        return value != null && value.toString().trim().isNotEmpty;
      case 'multiselect':
        return value is List && value.isNotEmpty;
      case 'checkbox':
        return value == true;
      case 'date':
        if (value is DateTime) return true;
        if (value is String) return value.trim().isNotEmpty;
        return false;
      case 'file':
        return value != null;
      case 'table':
        if (value is Map<String, dynamic>) {
          final rows = value['rows'];
          return rows is List && rows.isNotEmpty;
        }
        return false;
      case 'zoning':
        return value is Map && value.isNotEmpty;
      default:
        return value != null && value.toString().trim().isNotEmpty;
    }
  }

  _SurveyProgress _computeSurveyProgress(QuestionnaireDetail questionnaire) {
    final formStatuses = <String, FormCompletionState>{};
    final sectionStatuses = <String, FormCompletionState>{};
    final incompleteForms = <String>[];
    final incompleteSections = <String>[];
    var hasAnyData = false;

    for (final section in questionnaire.sections) {
      for (final form in section.forms) {
        final formData = _formDataByFormSlug[form.slug];
        final formHasData = _hasAnyValue(formData);
        hasAnyData = hasAnyData || formHasData;

        final requiredFields =
            form.customFormFields.where((field) => field.required).toList();
        final hasRequired = requiredFields.isNotEmpty;
        final allRequiredFilled =
            hasRequired
                ? requiredFields.every(
                    (field) => _isRequiredFieldFilled(field, formData),
                  )
                : true;

        FormCompletionState status;
        if (!hasRequired && !formHasData) {
          status = FormCompletionState.notStarted;
        } else if (allRequiredFilled) {
          status = FormCompletionState.complete;
        } else if (formHasData) {
          status = FormCompletionState.inProgress;
        } else {
          status = FormCompletionState.notStarted;
        }

        formStatuses[form.slug] = status;

        if (hasRequired && status != FormCompletionState.complete) {
          incompleteForms.add(form.name);
        }
      }

      final requiredForms =
          section.forms.where(_formHasRequiredFields).toList();
      if (requiredForms.isEmpty) {
        final sectionHasData = section.forms.any(
          (form) => _hasAnyValue(_formDataByFormSlug[form.slug]),
        );
        sectionStatuses[section.slug] =
            sectionHasData
                ? FormCompletionState.inProgress
                : FormCompletionState.complete;
      } else {
        final statuses = requiredForms
            .map(
              (form) =>
                  formStatuses[form.slug] ?? FormCompletionState.notStarted,
            )
            .toList();

        if (statuses.every((status) => status == FormCompletionState.complete)) {
          sectionStatuses[section.slug] = FormCompletionState.complete;
        } else if (statuses
            .every((status) => status == FormCompletionState.notStarted)) {
          sectionStatuses[section.slug] = FormCompletionState.notStarted;
        } else {
          sectionStatuses[section.slug] = FormCompletionState.inProgress;
        }

        if (sectionStatuses[section.slug] != FormCompletionState.complete) {
          incompleteSections.add(section.name);
        }
      }
    }

    return _SurveyProgress(
      formStatuses: formStatuses,
      sectionStatuses: sectionStatuses,
      incompleteFormNames: incompleteForms,
      incompleteSectionNames: incompleteSections,
      hasAnyData: hasAnyData,
    );
  }

  Future<void> _persistAllForms(QuestionnaireDetail questionnaire) async {
    final draftService = ref.read(draftServiceProvider);
    String? latestSurveyId = _currentSurveyId;
    final Map<String, DateTime> savedTimestamps = {};

    for (final section in questionnaire.sections) {
      for (final form in section.forms) {
        final formData = _formDataByFormSlug[form.slug];
        if (!_hasAnyValue(formData)) continue;

        final preparedData =
            _prepareFormDataForStorage(Map<String, dynamic>.from(formData!));
        latestSurveyId = await draftService.saveDraft(
          projectId: widget.projectId,
          questionnaireSlug: widget.questionnaireSlug,
          formSlug: form.slug,
          formData: preparedData,
          surveyId: latestSurveyId,
        );
        savedTimestamps[form.slug] = DateTime.now();
      }
    }

    if (!mounted) return;
    setState(() {
      _currentSurveyId = latestSurveyId;
      for (final entry in savedTimestamps.entries) {
        _formLastSavedAt[entry.key] = entry.value;
      }
    });
  }

  void _showSnackBar(
    String message, {
    Color? backgroundColor,
  }) {
    if (!mounted) return;
    if (backgroundColor == AppColors.success) {
      SnackBarUtils.showSuccess(context, message);
    } else if (backgroundColor == AppColors.error) {
      SnackBarUtils.showError(context, message);
    } else if (backgroundColor == AppColors.warning) {
      SnackBarUtils.showWarning(context, message);
    } else {
      SnackBarUtils.showInfo(context, message);
    }
  }

  String _extractErrorMessage(Object error) {
    final errorString = error.toString();

    // Try to extract message from Exception: ServerFailure(message)
    final serverFailurePattern = RegExp(r'ServerFailure\(([^)]+)\)');
    final match = serverFailurePattern.firstMatch(errorString);
    if (match != null) {
      return match.group(1) ?? errorString;
    }

    // Try to extract from Exception: message format
    if (errorString.startsWith('Exception: ')) {
      final message = errorString.substring('Exception: '.length);
      // If it's still a ServerFailure, extract the inner message
      final innerMatch = serverFailurePattern.firstMatch(message);
      if (innerMatch != null) {
        return innerMatch.group(1) ?? message;
      }
      return message;
    }

    return errorString;
  }

  Future<void> _saveFormDraft(String formSlug) async {
    final formData = _formDataByFormSlug[formSlug];
    if (!_hasAnyValue(formData)) {
      _showSnackBar(
        'Jaza angalau sehemu moja kabla ya kuhifadhi.',
        backgroundColor: AppColors.warning,
      );
      return;
    }

    try {
      final draftService = ref.read(draftServiceProvider);
      final preparedData = _prepareFormDataForStorage(formData!);

      // Save the form and get the surveyId back
      final surveyId = await draftService.saveDraft(
        projectId: widget.projectId,
        questionnaireSlug: widget.questionnaireSlug,
        formSlug: formSlug,
        formData: preparedData,
        surveyId: _currentSurveyId,
      );

      // Store the survey ID for subsequent saves
      setState(() {
        _currentSurveyId = surveyId;
        _formLastSavedAt[formSlug] = DateTime.now();
      });

      _showSnackBar(
        'Fomu imehifadhiwa',
        backgroundColor: AppColors.success,
      );
    } catch (e) {
      _showSnackBar(
        'Hitilafu: $e',
        backgroundColor: AppColors.error,
      );
    }
  }

  Future<void> _saveSurvey(
    QuestionnaireDetail questionnaire,
    _SurveyProgress progress,
  ) async {
    if (!progress.isComplete) {
      final incompleteFormsPreview = progress.incompleteFormNames.take(3).toList();
      final moreHidden =
          progress.incompleteFormNames.length > incompleteFormsPreview.length
              ? ' ...'
              : '';
      final details =
          incompleteFormsPreview.isNotEmpty
              ? '\n• ${incompleteFormsPreview.join('\n• ')}$moreHidden'
              : '';

      _showSnackBar(
        'Huwezi kukamilisha dodoso. Kuna sehemu za lazima ambazo hazijajazwa kikamilifu.$details',
        backgroundColor: AppColors.error,
      );
      return;
    }

    try {
      await _persistAllForms(questionnaire);

      if (_currentSurveyId == null) {
        _showSnackBar(
          'Hakuna fomu za kuhifadhi. Hifadhi data katika sehemu husika kwanza.',
          backgroundColor: AppColors.warning,
        );
        return;
      }

      final draftService = ref.read(draftServiceProvider);
      final saved = await draftService.saveSurvey(
        surveyId: _currentSurveyId!,
      );

      if (!saved) {
        _showSnackBar(
          'Hakuna fomu za kuhifadhi.',
          backgroundColor: AppColors.warning,
        );
        return;
      }

      _showSnackBar(
        'Dodoso limekamilika!',
        backgroundColor: AppColors.success,
      );

      Navigator.pop(context);
    } catch (e) {
      _showSnackBar(
        'Hitilafu: $e',
        backgroundColor: AppColors.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final questionnaireAsync = ref.watch(
      questionnaireDetailProvider(widget.questionnaireSlug),
    );
    final questionnaire = questionnaireAsync.asData?.value;
    final surveyProgress =
        questionnaire != null ? _computeSurveyProgress(questionnaire) : null;
    final isSurveyComplete = surveyProgress?.isComplete ?? false;
    final saveButtonColor =
        questionnaire == null
            ? (isDark ? AppColors.darkDivider : AppColors.divider)
            : (isSurveyComplete ? AppColors.success : AppColors.warning);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text(
          'Dodoso',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        surfaceTintColor: isDark ? AppColors.darkSurface : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Save Survey Button
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ElevatedButton.icon(
              onPressed:
                  questionnaire == null
                      ? null
                      : () => _saveSurvey(
                        questionnaire,
                        surveyProgress ?? _computeSurveyProgress(questionnaire),
                      ),
              style: ElevatedButton.styleFrom(
                backgroundColor: saveButtonColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingMd,
                  vertical: 8,
                ),
              ),
              icon: const Icon(Icons.save_outlined, size: 20),
              label: const Text('Hifadhi Kamili'),
            ),
          ),
        ],
      ),
      body: questionnaireAsync.when(
          data: (questionnaire) {
            final progressForBuild =
                surveyProgress ?? _computeSurveyProgress(questionnaire);
            // Sort sections by position
            final sortedSections = List<QuestionnaireSection>.from(
              questionnaire.sections,
            )..sort((a, b) => a.position.compareTo(b.position));

            return Form(
              key: _formKey,
              child: ListView.builder(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                itemCount: sortedSections.length + 1, // +1 for header
                itemBuilder: (context, index) {
                  // Header as first item
                  if (index == 0) {
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
                      padding: const EdgeInsets.all(AppConstants.spacingLg),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                        border: Border.all(
                          color: isDark ? AppColors.darkDivider : AppColors.divider,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            questionnaire.name,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color:
                                  isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.textPrimary,
                            ),
                          ),
                          if (questionnaire.description.isNotEmpty) ...[
                            const SizedBox(height: AppConstants.spacingSm),
                            Text(
                              questionnaire.description,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color:
                                    isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.textSecondary,
                              ),
                            ),
                          ],
                          const SizedBox(height: AppConstants.spacingMd),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color:
                                    isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  widget.projectName,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color:
                                        isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }

                  // Sections
                  final sectionIndex = index - 1;
                  final section = sortedSections[sectionIndex];
                  return FormSectionCard(
                    section: section,
                    sectionIndex: sectionIndex,
                    isDark: isDark,
                    formDataByFormSlug: _formDataByFormSlug,
                    formLastSavedAt: _formLastSavedAt,
                    expandedSections: _expandedSections,
                    expandedForms: _expandedForms,
                    formStatuses: progressForBuild.formStatuses,
                    sectionStatuses: progressForBuild.sectionStatuses,
                    onFieldChanged: _onFieldChanged,
                    onSaveForm: _saveFormDraft,
                    onSectionExpandChanged: (sectionSlug, isExpanded) {
                      setState(() {
                        _expandedSections[sectionSlug] = isExpanded;
                      });
                    },
                    onFormExpandChanged: (formSlug, isExpanded) {
                      setState(() {
                        _expandedForms[formSlug] = isExpanded;
                      });
                    },
                  );
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error:
              (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.spacing2xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: isDark ? AppColors.errorDark : AppColors.error,
                      ),
                      const SizedBox(height: AppConstants.spacingMd),
                      Text(
                        '${_extractErrorMessage(error)}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: isDark ? AppColors.errorDark : AppColors.error,
                        ),
                      ),
                      // const SizedBox(height: AppConstants.spacingSm),
                      // Text(
                      //   error.toString(),
                      //   style: theme.textTheme.bodyMedium?.copyWith(
                      //     color:
                      //         isDark
                      //             ? AppColors.darkTextSecondary
                      //             : AppColors.textSecondary,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                    ],
                  ),
                ),
              ),
        ),
    );
  }
}
