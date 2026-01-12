import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/utils/snackbar_utils.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/page_empty_state.dart';
import '../../../../../shared/widgets/questionnaire_list_bottom_sheet.dart';
import '../../../../../shared/widgets/survey_card.dart';
import '../../../../../core/services/export_service.dart';
import '../../../../../../shared/models/survey_item.dart';
import '../bloc/survey_list_bloc.dart';
import '../bloc/survey_list_event.dart';
import '../bloc/survey_list_state.dart';
import '../bloc/survey_upload_bloc.dart';
import '../bloc/survey_upload_event.dart';
import '../widgets/survey_filter_sheet.dart';

class SurveyListPage extends StatefulWidget {
  final String projectId;
  final String? projectName;

  const SurveyListPage({super.key, required this.projectId, this.projectName});

  @override
  State<SurveyListPage> createState() => _SurveyListPageState();
}

class _SurveyListPageState extends State<SurveyListPage> {
  final Set<String> _selectedSurveyIds = {};

  @override
  void initState() {
    super.initState();
    context.read<SurveyListBloc>().add(
      LoadSurveys(projectId: widget.projectId, moduleSlug: 'compliance'),
    );
  }

  bool get _isSelectionMode => _selectedSurveyIds.isNotEmpty;

  bool _canSelectSurvey(SurveyItem survey) {
    if (survey.isDraft) return false;
    return survey.uploadStatus == UploadStatus.failure ||
        (survey.isDirty && survey.uploadStatus == UploadStatus.idle);
  }

  void _toggleSelection(SurveyItem survey) {
    if (!_canSelectSurvey(survey)) return;
    setState(() {
      if (_selectedSurveyIds.contains(survey.surveyId)) {
        _selectedSurveyIds.remove(survey.surveyId);
      } else {
        _selectedSurveyIds.add(survey.surveyId);
      }
    });
  }

  void _clearSelection() {
    setState(() => _selectedSurveyIds.clear());
  }

  void _uploadSelectedSurveys() {
    if (_selectedSurveyIds.isEmpty) return;
    context.read<SurveyUploadBloc>().add(
      UploadMultipleSurveys(_selectedSurveyIds.toList()),
    );
  }

  void _showQuestionnaireListSheet() {
    QuestionnaireListBottomSheet.show(
      context,
      projectId: widget.projectId,
      projectName: widget.projectName,
      module: 'compliance',
      onQuestionnaireSelected: (questionnaireSlug) {
        context.go(
          '/land-use/projects/${widget.projectId}/surveys/new?questionnaireSlug=$questionnaireSlug&projectName=${widget.projectName ?? ''}',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: _buildAppBar(isDark, theme),
      body: BlocBuilder<SurveyListBloc, SurveyListState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null) {
            return PageEmptyState(
              icon: Icons.error_outline,
              title: 'Hitilafu',
              message: state.errorMessage!,
              isDark: isDark,
            );
          }

          final surveys = state.filteredSurveys;

          if (surveys.isEmpty) {
            return PageEmptyState(
              icon: Icons.description_outlined,
              title: 'Hakuna Dodoso',
              message: 'Bonyeza kitufe cha chini kuanza dodoso mpya',
              isDark: isDark,
            );
          }

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            itemCount: surveys.length,
            itemBuilder: (context, index) {
              final survey = surveys[index];
              final isSelected = _selectedSurveyIds.contains(survey.surveyId);

              return SurveyCard(
                survey: survey,
                projectName: widget.projectName,
                isDark: isDark,
                isSelected: isSelected,
                isSelectionMode: _isSelectionMode,
                onTap: () {
                  if (_isSelectionMode) {
                    _toggleSelection(survey);
                  } else {
                    // Navigate to edit survey
                    if (survey.isDraft) {
                      context.go(
                        '/land-use/projects/${widget.projectId}/surveys/new'
                        '?questionnaireSlug=${survey.questionnaireSlug}'
                        '&projectName=${widget.projectName ?? ''}'
                        '&surveyId=${survey.surveyId}',
                      );
                    } else {
                      SnackBarUtils.showInfo(
                        context,
                        'Dodoso limeshakamilika. Haliwezi kubadilishwa.',
                      );
                    }
                  }
                },
                onLongPress: () => _toggleSelection(survey),
                onRetry:
                    survey.uploadStatus == UploadStatus.failure
                        ? () {
                          context.read<SurveyUploadBloc>().add(
                            UploadMultipleSurveys([survey.surveyId]),
                          );
                        }
                        : null,
                uploadProgress: null, // TODO: Get from upload bloc state
              );
            },
          );
        },
      ),
      floatingActionButton:
          _isSelectionMode
              ? null
              : FloatingActionButton.extended(
                onPressed: _showQuestionnaireListSheet,
                icon: const Icon(Icons.add),
                label: const Text('Dodoso Mpya'),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDark, ThemeData theme) {
    if (_isSelectionMode) {
      return CustomAppBar(
        title: '${_selectedSurveyIds.length} Zimechaguliwa',
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _clearSelection,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload),
            onPressed: _uploadSelectedSurveys,
            tooltip: 'Pakia',
          ),
        ],
      );
    }

    return CustomAppBar(
      title: widget.projectName ?? 'Dodoso',
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        BlocBuilder<SurveyListBloc, SurveyListState>(
          builder: (context, state) {
            return IconButton(
              icon: Badge(
                isLabelVisible:
                    state.filter != SurveyFilterType.all ||
                    state.searchQuery.isNotEmpty,
                child: const Icon(Icons.filter_list),
              ),
              onPressed: () => _showFilterSheet(context, state),
              tooltip: 'Chuja',
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.file_download),
          onPressed: _showExportDialog,
          tooltip: 'Hamidisha',
        ),
      ],
    );
  }

  void _showFilterSheet(BuildContext context, SurveyListState state) {
    SurveyFilterSheet.show(
      context,
      currentFilter: state.filter,
      onFilterChanged: (filter) {
        context.read<SurveyListBloc>().add(FilterSurveys(filter));
      },
      searchQuery: state.searchQuery,
      onSearchChanged: (query) {
        context.read<SurveyListBloc>().add(SearchSurveys(query));
      },
      dateRange: state.dateRange,
      onDateRangeChanged: (dateRange) {
        context.read<SurveyListBloc>().add(FilterByDateRange(dateRange));
      },
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Hamidisha Dodoso'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.table_chart),
                  title: const Text('CSV'),
                  onTap: () {
                    Navigator.pop(context);
                    _exportToCSV();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf),
                  title: const Text('PDF'),
                  onTap: () {
                    Navigator.pop(context);
                    _exportToPDF();
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _exportToCSV() async {
    final state = context.read<SurveyListBloc>().state;
    final surveys = state.filteredSurveys;

    if (surveys.isEmpty) {
      SnackBarUtils.showError(context, 'Hakuna dodoso za kuhamidisha');
      return;
    }

    try {
      SnackBarUtils.showInfo(context, 'Inahamisha kwa CSV...');

      final exportService = context.read<ExportService>();
      final filePath = await exportService.exportToCSV(
        surveys: surveys,
        projectName: widget.projectName,
      );
      await exportService.shareFile(filePath);

      SnackBarUtils.showSuccess(
        context,
        'Dodoso ${surveys.length} zimehamishwa kwa CSV',
      );
    } catch (e) {
      SnackBarUtils.showError(context, 'Imeshindikana kuhamisha: $e');
    }
  }

  void _exportToPDF() async {
    final state = context.read<SurveyListBloc>().state;
    final surveys = state.filteredSurveys;

    if (surveys.isEmpty) {
      SnackBarUtils.showError(context, 'Hakuna dodoso za kuhamidisha');
      return;
    }

    try {
      SnackBarUtils.showInfo(context, 'Inahamisha kwa PDF...');

      final exportService = context.read<ExportService>();
      final filePath = await exportService.exportToPDF(
        surveys: surveys,
        projectName: widget.projectName,
      );
      await exportService.shareFile(filePath);

      SnackBarUtils.showSuccess(
        context,
        'Dodoso ${surveys.length} zimehamishwa kwa PDF',
      );
    } catch (e) {
      SnackBarUtils.showError(context, 'Imeshindikana kuhamisha: $e');
    }
  }
}
