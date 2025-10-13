import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nluis_app/shared/widgets/form/form_section_card.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/models/questionnaire.dart';
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
      if (!_formDataByFormSlug.containsKey(formSlug)) {
        _formDataByFormSlug[formSlug] = {};
      }
      _formDataByFormSlug[formSlug]![fieldId] = value;
    });
  }

  Future<void> _saveFormDraft(String formSlug) async {
    final formData = _formDataByFormSlug[formSlug];
    if (formData == null || formData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hakuna data ya kuhifadhi'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      final draftService = ref.read(draftServiceProvider);

      // Save the form and get the surveyId back
      final surveyId = await draftService.saveDraft(
        projectId: widget.projectId,
        questionnaireSlug: widget.questionnaireSlug,
        formSlug: formSlug,
        formData: formData,
        surveyId: _currentSurveyId,
      );

      // Store the survey ID for subsequent saves
      setState(() {
        _currentSurveyId = surveyId;
        _formLastSavedAt[formSlug] = DateTime.now();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fomu imehifadhiwa'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hitilafu: $e'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveSurvey() async {
    if (_currentSurveyId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tafadhali hifadhi angalau fomu moja kwanza'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    try {
      final draftService = ref.read(draftServiceProvider);

      final saved = await draftService.saveSurvey(
        surveyId: _currentSurveyId!,
      );

      if (!saved) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Hakuna fomu za kuhifadhi'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dodoso limehifadhiwa!'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );

        // Go back to survey list
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hitilafu: $e'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final questionnaireAsync = ref.watch(
      questionnaireDetailProvider(widget.questionnaireSlug),
    );

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
              onPressed: _saveSurvey,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingMd,
                  vertical: 8,
                ),
              ),
              icon: const Icon(Icons.save_outlined, size: 20),
              label: const Text('Hifadhi'),
            ),
          ),
        ],
      ),
      body: questionnaireAsync.when(
          data: (questionnaire) {
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
                        'Hitilafu imetokea',
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
