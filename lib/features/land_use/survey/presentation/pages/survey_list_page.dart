import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:path_provider/path_provider.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/app_drawer.dart';
import '../../../../../shared/widgets/questionnaire_list_bottom_sheet.dart';
import '../../../../../data/local/draft_provider.dart';
import 'questionnaire_form_page.dart';

class SurveyListPage extends ConsumerStatefulWidget {
  final String projectId;
  final String? projectName;

  const SurveyListPage({super.key, required this.projectId, this.projectName});

  @override
  ConsumerState<SurveyListPage> createState() => _SurveyListPageState();
}

class _SurveyListPageState extends ConsumerState<SurveyListPage> {
  List<_SurveyItem> _surveys = [];
  bool _isLoading = true;
  final Set<String> _selectedSurveyIds = {};

  @override
  void initState() {
    super.initState();
    _loadSurveys();
  }

  Future<void> _loadSurveys() async {
    setState(() => _isLoading = true);

    try {
      final database = ref.read(databaseProvider);

      // Get all survey responses for this project
      final responses =
          await (database.select(database.surveyResponses)
                ..where((tbl) => tbl.projectId.equals(widget.projectId))
                ..orderBy([(tbl) => drift.OrderingTerm.desc(tbl.updatedAt)]))
              .get();

      // Group by surveyId
      final Map<String, _SurveyItem> surveyMap = {};

      for (final response in responses) {
        final surveyId = response.surveyId;

        if (!surveyMap.containsKey(surveyId)) {
          // Get questionnaire details
          final questionnaireSlug = response.questionnaireSlug ?? '';
          final questionnaire =
              await (database.select(database.questionnaires)..where(
                (tbl) => tbl.slug.equals(questionnaireSlug),
              )).getSingleOrNull();

          // Get all forms for this survey
          final surveyForms =
              responses.where((r) => r.surveyId == surveyId).toList();

          surveyMap[surveyId] = _SurveyItem(
            surveyId: surveyId,
            questionnaireSlug: questionnaireSlug,
            questionnaireName: questionnaire?.name ?? 'Dodoso 2',
            isDraft: response.isDraft,
            formsCount: surveyForms.length,
            savedDate: _formatDate(
              DateTime.fromMillisecondsSinceEpoch(response.updatedAt * 1000),
            ),
          );
        }
      }

      if (mounted) {
        setState(() {
          _surveys = surveyMap.values.toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hitilafu: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m zilizopita';
      }
      return '${difference.inHours}h zilizopita';
    } else if (difference.inDays == 1) {
      return 'Jana';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} siku zilizopita';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showQuestionnaireListSheet(BuildContext context) {
    QuestionnaireListBottomSheet.show(
      context,
      projectId: widget.projectId,
      projectName: widget.projectName ?? 'Project',
      module: 'land-uses',
      onQuestionnaireSelected: (questionnaireSlug) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => QuestionnaireFormPage(
                  questionnaireSlug: questionnaireSlug,
                  projectId: widget.projectId,
                  projectName: widget.projectName ?? 'Project',
                ),
          ),
        ).then((_) => _loadSurveys()); // Refresh when returning
      },
    );
  }

  Future<void> _uploadSelectedSurveys() async {
    if (_selectedSurveyIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tafadhali chagua dodoso za kupakia'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      final database = ref.read(databaseProvider);

      // Prepare payload for each selected survey
      final List<Map<String, dynamic>> surveysPayload = [];

      for (final surveyId in _selectedSurveyIds) {
        // Get all responses for this survey
        final responses =
            await (database.select(database.surveyResponses)
              ..where((tbl) => tbl.surveyId.equals(surveyId))).get();

        if (responses.isEmpty) continue;

        // Build survey payload
        final surveyData = <String, dynamic>{
          'surveyId': surveyId,
          'projectId': responses.first.projectId,
          'questionnaireSlug': responses.first.questionnaireSlug,
          'isDraft': responses.first.isDraft,
          'updatedAt': responses.first.updatedAt,
          'forms': [],
        };

        // Add all form responses
        for (final response in responses) {
          surveyData['forms'].add({
            'formSlug': response.formSlug,
            'questionnaireSlug': response.questionnaireSlug,
            'answersJson': response.answersJson,
            'isDraft': response.isDraft,
            'dirty': response.dirty,
            'updatedAt': response.updatedAt,
          });
        }

        surveysPayload.add(surveyData);
      }

      // TODO: This is temporary
      if (surveysPayload.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Hakuna dodoso zilizopatikana kwa kupakia'),
              duration: Duration(seconds: 2),
              backgroundColor: AppColors.warning,
            ),
          );
        }
        return;
      }

      final payload = <String, dynamic>{
        'projectId': widget.projectId,
        'projectName': widget.projectName,
        'totalSurveys': surveysPayload.length,
        'surveys': surveysPayload,
        'exportedAt': DateTime.now().toIso8601String(),
      };

      final encoder = const JsonEncoder.withIndent('  ');
      final jsonString = encoder.convert(payload);

      Directory documentsDir;
      if (Platform.isAndroid) {
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          final androidIndex = externalDir.path.indexOf('/Android');
          if (androidIndex != -1) {
            final rootPath = externalDir.path.substring(0, androidIndex);
            documentsDir = Directory('$rootPath/Documents');
          } else {
            documentsDir = externalDir;
          }
        } else {
          documentsDir = await getApplicationDocumentsDirectory();
        }
      } else {
        documentsDir = await getApplicationDocumentsDirectory();
      }

      if (!await documentsDir.exists()) {
        await documentsDir.create(recursive: true);
      }

      final fileName =
          'nluis_dodoso_response_${DateTime.now().millisecondsSinceEpoch}.json';
      final file = File('${documentsDir.path}/$fileName');
      print('saved file at: ${file.path}');

      try {
        await file.writeAsString(jsonString);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Faili limehifadhiwa: ${file.path}'),
              duration: const Duration(seconds: 3),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        print('Error saving payload file: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Imeshindikana kuhifadhi faili: $e'),
              duration: const Duration(seconds: 3),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }

      // TODO: Implement actual upload functionality here
      // final response = await http.post(
      //   Uri.parse('YOUR_API_ENDPOINT'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode(surveysPayload),
      // );

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Selected: ${_selectedSurveyIds.length} surveys'),
      //     duration: const Duration(seconds: 3),
      //     backgroundColor: AppColors.success,
      //   ),
      // );
    } catch (e) {
      print('ERROR preparing upload payload: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hitilafu: $e'),
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(hasNotification: true),
      drawer: const AppDrawer(),
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _surveys.isEmpty
              ? RefreshIndicator(
                onRefresh: _loadSurveys,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppConstants.spacingLg),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.info.withValues(alpha: 0.1),
                                  AppColors.info.withValues(alpha: 0.05),
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.info.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.assignment_late_outlined,
                              size: 80,
                              color: AppColors.info,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'Hakuna Dodoso Lililojazwa',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Dodoso zitaonyeshwa hapa',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              color:
                                  isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  // Upload button bar (only show if there are saved surveys)
                  if (_surveys.any((s) => !s.isDraft))
                    Container(
                      padding: const EdgeInsets.all(AppConstants.spacingMd),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedSurveyIds.isEmpty
                                  ? 'Chagua dodoso za kupakia'
                                  : '${_selectedSurveyIds.length} zilizochaguliwa',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color:
                                    isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.textSecondary,
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _uploadSelectedSurveys,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(
                              Icons.cloud_upload_outlined,
                              size: 20,
                            ),
                            label: const Text('Pakia'),
                          ),
                        ],
                      ),
                    ),
                  // Survey list
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _loadSurveys,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(AppConstants.spacingMd),
                        itemCount: _surveys.length,
                        itemBuilder: (context, index) {
                          final survey = _surveys[index];
                          final isSelected = _selectedSurveyIds.contains(
                            survey.surveyId,
                          );

                          return _SurveyCard(
                            survey: survey,
                            projectName: widget.projectName ?? 'Project',
                            isDark: isDark,
                            isSelected: isSelected,
                            onSelectionChanged: (selected) {
                              setState(() {
                                if (selected && !survey.isDraft) {
                                  _selectedSurveyIds.add(survey.surveyId);
                                } else {
                                  _selectedSurveyIds.remove(survey.surveyId);
                                }
                              });
                            },
                            onTap: () {
                              // Open the survey for viewing/editing
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => QuestionnaireFormPage(
                                        questionnaireSlug:
                                            survey.questionnaireSlug,
                                        projectId: widget.projectId,
                                        projectName:
                                            widget.projectName ?? 'Project',
                                        surveyId: survey.surveyId,
                                      ),
                                ),
                              ).then(
                                (_) => _loadSurveys(),
                              ); // Refresh when returning
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                isDark
                    ? [AppColors.darkPrimary, AppColors.darkPrimaryDark]
                    : [AppColors.primary, AppColors.primaryDark],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color:
                  isDark
                      ? AppColors.darkPrimary.withValues(alpha: 0.4)
                      : AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => _showQuestionnaireListSheet(context),
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: Icon(
            Icons.add,
            color: isDark ? AppColors.darkTextInverse : AppColors.textInverse,
          ),
          label: Text(
            'Jaza Dodoso',
            style: TextStyle(
              color: isDark ? AppColors.darkTextInverse : AppColors.textInverse,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _SurveyItem {
  final String surveyId;
  final String questionnaireSlug;
  final String questionnaireName;
  final bool isDraft;
  final int formsCount;
  final String savedDate;

  _SurveyItem({
    required this.surveyId,
    required this.questionnaireSlug,
    required this.questionnaireName,
    required this.isDraft,
    required this.formsCount,
    required this.savedDate,
  });
}

class _SurveyCard extends StatelessWidget {
  final _SurveyItem survey;
  final String projectName;
  final bool isDark;
  final bool isSelected;
  final Function(bool) onSelectionChanged;
  final VoidCallback onTap;

  const _SurveyCard({
    required this.survey,
    required this.projectName,
    required this.isDark,
    required this.isSelected,
    required this.onSelectionChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border:
              isSelected
                  ? Border.all(color: AppColors.primary, width: 2)
                  : null,
          boxShadow: [
            BoxShadow(
              color:
                  isDark
                      ? Colors.black.withValues(alpha: 0.2)
                      : Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(AppConstants.spacingMd),
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Checkbox for selection (only for saved surveys)
              if (!survey.isDraft)
                Checkbox(
                  value: isSelected,
                  onChanged: (value) => onSelectionChanged(value ?? false),
                  activeColor: AppColors.primary,
                )
              else
                const SizedBox(width: 12),
              // Icon
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                decoration: BoxDecoration(
                  color:
                      survey.isDraft
                          ? AppColors.warning.withValues(alpha: 0.1)
                          : AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
                child: Icon(
                  survey.isDraft ? Icons.drafts : Icons.check_circle,
                  color: survey.isDraft ? AppColors.warning : AppColors.success,
                  size: 24,
                ),
              ),
            ],
          ),
          title: Text(
            survey.questionnaireName,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppConstants.spacingXs),
              Row(
                children: [
                  Icon(
                    Icons.folder_outlined,
                    size: 14,
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      projectName,
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
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 14,
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${survey.formsCount} fomu',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    survey.savedDate,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingSm,
              vertical: AppConstants.spacingXs,
            ),
            decoration: BoxDecoration(
              color:
                  survey.isDraft
                      ? AppColors.warning.withValues(alpha: 0.1)
                      : AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            ),
            child: Text(
              survey.isDraft ? 'Rasimu' : 'Imehifadhiwa',
              style: theme.textTheme.bodySmall?.copyWith(
                color: survey.isDraft ? AppColors.warning : AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
