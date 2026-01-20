import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/page_empty_state.dart';
import '../../../../core/network/network_info.dart';
import '../../../../data/local/draft_provider.dart';
import '../../../../data/local/database.dart';
import '../../../../data/services/survey_upload_provider.dart';
import '../../../constants/app_constants.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/snackbar_utils.dart';
import '../../../widgets/app_drawer.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/questionnaire_list_bottom_sheet.dart';
// import '../../../widgets/offline_banner.dart';
import '../models/survey_item.dart';
import '../widgets/survey_card.dart';

/// Configuration for module-specific behavior
class SurveyModuleConfig {
  final String moduleSlug;
  final String moduleDisplayName;
  final String questionnaireRoutePath;
  final Widget Function({
    required String questionnaireSlug,
    required String projectId,
    String? projectName,
    String? surveyId,
    bool isReadOnly,
  }) questionnaireFormPageBuilder;

  const SurveyModuleConfig({
    required this.moduleSlug,
    required this.moduleDisplayName,
    required this.questionnaireRoutePath,
    required this.questionnaireFormPageBuilder,
  });
}

class SharedSurveyListPage extends ConsumerStatefulWidget {
  final String projectId;
  final String? projectName;
  final SurveyModuleConfig moduleConfig;

  const SharedSurveyListPage({
    super.key,
    required this.projectId,
    this.projectName,
    required this.moduleConfig,
  });

  @override
  ConsumerState<SharedSurveyListPage> createState() => _SharedSurveyListPageState();
}

enum SurveyFilter { all, draft, failed, completed, uploaded }

class _SharedSurveyListPageState extends ConsumerState<SharedSurveyListPage> {
  List<SurveyItem> _surveys = [];
  bool _isLoading = true;
  bool _isUploading = false;
  final Set<String> _selectedSurveyIds = {};
  final Map<String, UploadStatus> _statusOverrides = {};
  final Map<String, String?> _statusErrors = {};
  SurveyFilter _currentFilter = SurveyFilter.all;

  List<SurveyItem> get _filteredSurveys {
    switch (_currentFilter) {
      case SurveyFilter.all:
        return _surveys;
      case SurveyFilter.draft:
        return _surveys.where((s) => s.isDraft).toList();
      case SurveyFilter.failed:
        return _surveys.where((s) => s.uploadStatus == UploadStatus.failure).toList();
      case SurveyFilter.completed:
        return _surveys.where((s) => !s.isDraft && s.isDirty && s.uploadStatus == UploadStatus.idle).toList();
      case SurveyFilter.uploaded:
        return _surveys.where((s) => s.uploadStatus == UploadStatus.success || (!s.isDraft && !s.isDirty)).toList();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSurveys();
  }

  Future<String?> _resolveQuestionnaireName(
    AppDatabase database,
    String slug,
    Map<String, String> cache,
  ) async {
    if (cache.containsKey(slug)) {
      return cache[slug];
    }

    final questionnaire =
        await (database.select(database.questionnaires)
          ..where((tbl) => tbl.slug.equals(slug))).getSingleOrNull();

    final name = questionnaire?.name;
    cache[slug] = name ?? 'Dodoso';
    return name;
  }

  Future<void> _loadSurveys() async {
    setState(() => _isLoading = true);

    try {
      final database = ref.read(databaseProvider);

      final responses =
          await (database.select(database.surveyResponses)
                ..where((tbl) => tbl.projectId.equals(widget.projectId) & tbl.moduleSlug.equals(widget.moduleConfig.moduleSlug))
                ..orderBy([(tbl) => drift.OrderingTerm.desc(tbl.updatedAt)]))
              .get();

      if (responses.isEmpty) {
        if (mounted) {
          setState(() {
            _surveys = [];
            _isLoading = false;
          });
        }
        return;
      }

      final Map<String, List<SurveyResponse>> grouped = {};
      for (final response in responses) {
        grouped.putIfAbsent(response.surveyId, () => []).add(response);
      }

      final Map<String, String> questionnaireNameCache = {};
      final List<SurveyItem> surveys = [];

      for (final entry in grouped.entries) {
        final surveyId = entry.key;
        final surveyResponses = entry.value;
        surveyResponses.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

        final firstResponse = surveyResponses.first;
        final questionnaireSlug = firstResponse.questionnaireSlug ?? '';

        String questionnaireName = 'Dodoso';
        if (questionnaireSlug.isNotEmpty) {
          final cachedName = await _resolveQuestionnaireName(
            database,
            questionnaireSlug,
            questionnaireNameCache,
          );
          questionnaireName = cachedName ?? questionnaireName;
        }

        final latestUpdatedAt = surveyResponses
            .map((r) => r.updatedAt)
            .reduce((value, element) => element > value ? element : value);

        final isDraft = surveyResponses.any((r) => r.isDraft);
        final isDirty = surveyResponses.any((r) => r.dirty);

        final defaultStatus =
            !isDirty && !isDraft ? UploadStatus.success : UploadStatus.idle;
        final overrideStatus = _statusOverrides[surveyId];
        final status = overrideStatus ?? defaultStatus;
        final lastError =
            overrideStatus == null ? null : _statusErrors[surveyId];

        surveys.add(
          SurveyItem(
            surveyId: surveyId,
            projectId: firstResponse.projectId,
            questionnaireSlug: questionnaireSlug,
            questionnaireName: questionnaireName,
            isDraft: isDraft,
            isDirty: isDirty,
            formsCount: surveyResponses.length,
            savedDate: _formatDate(
              DateTime.fromMillisecondsSinceEpoch(latestUpdatedAt * 1000),
            ),
            updatedAt: latestUpdatedAt,
            uploadStatus: status,
            lastError: lastError,
          ),
        );
      }

      surveys.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      if (mounted) {
        setState(() {
          _surveys = surveys;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar('Hitilafu: $e', AppColors.error);
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
      projectName: widget.projectName,
      module: widget.moduleConfig.moduleSlug,
      onQuestionnaireSelected: (questionnaireSlug) {
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (_) => widget.moduleConfig.questionnaireFormPageBuilder(
                  questionnaireSlug: questionnaireSlug,
                  projectId: widget.projectId,
                  projectName: widget.projectName,
                ),
              ),
            )
            .then((_) => _loadSurveys());
      },
    );
  }

  Future<void> _uploadSelectedSurveys() async {
    if (_isUploading) {
      _showSnackBar('Upakiaji unaendelea, tafadhali subiri', AppColors.info);
      return;
    }

    if (_selectedSurveyIds.isEmpty) {
      _showSnackBar('Tafadhali chagua dodoso za kupakia', AppColors.warning);
      return;
    }

    await _uploadSurveys(_selectedSurveyIds.toList());
  }

  Future<void> _uploadSurveys(List<String> surveyIds) async {
    if (surveyIds.isEmpty) return;

    final uploadService = ref.read(surveyUploadServiceProvider);
    final idsSet = surveyIds.toSet();

    if (mounted) {
      setState(() {
        _isUploading = true;
        _surveys =
            _surveys
                .map(
                  (survey) =>
                      idsSet.contains(survey.surveyId)
                          ? survey.copyWith(
                            uploadStatus: UploadStatus.uploading,
                            lastError: () => null,
                          )
                          : survey,
                )
                .toList();

        for (final id in idsSet) {
          _statusOverrides[id] = UploadStatus.uploading;
          _statusErrors.remove(id);
        }
      });
    }

    final successes = <String>[];
    final failures = <String, String>{};
    final idsToUnselect = <String>[];

    try {
      for (final surveyId in surveyIds) {
        try {
          final result = await uploadService.uploadSurvey(
            surveyId: surveyId,
            onProgress: (questionnaireSlug, progress) {
              debugPrint('Upload progress for $questionnaireSlug: ${(progress * 100).toStringAsFixed(1)}%');
            },
            onStatusChange: (questionnaireSlug, status) {
              debugPrint('Upload status for $questionnaireSlug: $status');
            },
          );

          if (result.allSucceeded) {
            successes.add(surveyId);
            idsToUnselect.add(surveyId);
            _statusOverrides.remove(surveyId);
            _statusErrors.remove(surveyId);
          } else if (result.hasFailures) {
            final errorMessage = result.failures.values.first;
            failures[surveyId] = errorMessage;
            _statusOverrides[surveyId] = UploadStatus.failure;
            _statusErrors[surveyId] = errorMessage;
            _updateSurveyInState(
              surveyId,
              uploadStatus: UploadStatus.failure,
              lastError: () => errorMessage,
            );
          }
        } catch (error) {
          final errorMessage = _mapUploadError(error);
          failures[surveyId] = errorMessage;
          _statusOverrides[surveyId] = UploadStatus.failure;
          _statusErrors[surveyId] = errorMessage;
          _updateSurveyInState(
            surveyId,
            uploadStatus: UploadStatus.failure,
            lastError: () => errorMessage,
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }

    if (successes.isNotEmpty && mounted) {
      setState(() {
        _surveys.removeWhere((survey) => successes.contains(survey.surveyId));
      });
    }

    if (idsToUnselect.isNotEmpty && mounted) {
      setState(() {
        _selectedSurveyIds.removeAll(idsToUnselect);
      });
    }

    if (successes.isNotEmpty) {
      _showSnackBar(
        '${successes.length} dodoso zimepakiwa kikamilifu',
        AppColors.success,
      );
    }

    if (failures.isNotEmpty) {
      final message = failures.values.first;
      _showSnackBar('Baadhi ya dodoso hazikupakiwa: $message', AppColors.error);
    }
  }

  Future<void> _retryUpload(String surveyId) async {
    if (_isUploading) {
      _showSnackBar('Upakiaji unaendelea, tafadhali subiri', AppColors.info);
      return;
    }
    await _uploadSurveys([surveyId]);
  }

  void _updateSurveyInState(
    String surveyId, {
    UploadStatus? uploadStatus,
    bool? isDirty,
    bool? isDraft,
    String? Function()? lastError,
  }) {
    if (!mounted) return;
    setState(() {
      _surveys =
          _surveys
              .map(
                (survey) =>
                    survey.surveyId == surveyId
                        ? survey.copyWith(
                          uploadStatus: uploadStatus,
                          isDirty: isDirty,
                          isDraft: isDraft,
                          lastError: lastError,
                        )
                        : survey,
              )
              .toList();
    });
  }

  Future<void> _handleRefresh(bool isOnline) async {
    if (!isOnline) {
      _showSnackBar(
        'Uko offline. Washa mtandao ili kusasisha kutoka seva.',
        AppColors.info,
      );
      return;
    }
    await _loadSurveys();
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

  void _selectAllEligible() {
    setState(() {
      for (final survey in _filteredSurveys) {
        if (_canSelectSurvey(survey)) {
          _selectedSurveyIds.add(survey.surveyId);
        }
      }
    });
  }

  Widget _buildSurveyList(bool isDark) {
    final surveys = _filteredSurveys;
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
              final isUploaded = survey.uploadStatus == UploadStatus.success ||
                  (!survey.isDraft && !survey.isDirty);
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (_) => widget.moduleConfig.questionnaireFormPageBuilder(
                        questionnaireSlug: survey.questionnaireSlug,
                        projectId: widget.projectId,
                        projectName: widget.projectName,
                        surveyId: survey.surveyId,
                        isReadOnly: isUploaded,
                      ),
                    ),
                  )
                  .then((_) => _loadSurveys());
            }
          },
          onLongPress: () => _toggleSelection(survey),
          onRetry:
              survey.uploadStatus == UploadStatus.failure
                  ? () => _retryUpload(survey.surveyId)
                  : null,
        );
      },
    );
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    if (color == AppColors.success) {
      SnackBarUtils.showSuccess(context, message);
    } else if (color == AppColors.error) {
      SnackBarUtils.showError(context, message);
    } else if (color == AppColors.warning) {
      SnackBarUtils.showWarning(context, message);
    } else {
      SnackBarUtils.showInfo(context, message);
    }
  }

  String _mapUploadError(Object error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      if (statusCode != null) {
        if (statusCode >= 500) {
          return 'Hitilafu ya seva ($statusCode)';
        }
        if (statusCode == 400) {
          final data = error.response?.data;
          if (data is Map && data['message'] is String) {
            return data['message'] as String;
          }
        }
        return 'Hitilafu ya seva ($statusCode)';
      }
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return 'Muda wa muunganisho umeisha';
      }
      if (error.type == DioExceptionType.connectionError) {
        return 'Mtandao haupatikani';
      }
      return error.message ?? 'Hitilafu ya mtandao';
    }
    return error.toString();
  }

  PreferredSizeWidget _buildAppBar(bool isDark, ThemeData theme) {
    if (_isSelectionMode) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _clearSelection,
        ),
        title: Text(
          '${_selectedSurveyIds.length} zimechaguliwa',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        elevation: 1,
        actions: [
          TextButton.icon(
            onPressed: _isUploading ? null : _uploadSelectedSurveys,
            icon: _isUploading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.cloud_upload_outlined),
            label: Text(_isUploading ? 'Inapakia...' : 'Pakia'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'select_all') _selectAllEligible();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'select_all',
                child: Text('Chagua Zote'),
              ),
            ],
          ),
        ],
      );
    }
    return const CustomAppBar(
      title: 'Dodoso Zilizojazwa',
      showBackButton: true,
      showNotifications: false,
      showProfile: false,
    );
  }

  Widget _buildFilterChips(bool isDark) {
    final filters = [
      (SurveyFilter.all, 'Zote'),
      (SurveyFilter.draft, 'Rasimu'),
      (SurveyFilter.failed, 'Zilizoshindwa'),
      (SurveyFilter.completed, 'Zimekamilika'),
      (SurveyFilter.uploaded, 'Zimepakiwa'),
    ];

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd,
          vertical: AppConstants.spacingSm,
        ),
        itemCount: filters.length,
        separatorBuilder: (_, i) => const SizedBox(width: AppConstants.spacingSm),
        itemBuilder: (context, index) {
          final (filter, label) = filters[index];
          final isActive = _currentFilter == filter;
          return FilterChip(
            label: Text(label),
            selected: isActive,
            onSelected: (_) => setState(() => _currentFilter = filter),
            selectedColor: AppColors.primary.withValues(alpha: 0.2),
            checkmarkColor: AppColors.primary,
            labelStyle: TextStyle(
              color: isActive
                  ? AppColors.primary
                  : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
            backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
            side: BorderSide(
              color: isActive
                  ? AppColors.primary
                  : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onlineStatus = ref.watch(onlineStatusProvider);
    final isOnline = onlineStatus.maybeWhen(
      data: (value) => value,
      orElse: () => true,
    );

    return Scaffold(
      appBar: _buildAppBar(isDark, theme),
      drawer: _isSelectionMode ? null : const AppDrawer(),
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // if (!isOnline) const OfflineBanner(),
                  if (_surveys.isEmpty)
                    Expanded(
                      child:
                          isOnline
                              ? RefreshIndicator(
                                onRefresh: () => _handleRefresh(isOnline),
                                child: EmptyPageState(
                                  context: context,
                                  isDark: isDark,
                                  heading: 'Hakuna Dodoso Lililojazwa',
                                  description: 'Dodoso zitaonyeshwa hapa',
                                ),
                              )
                              : EmptyPageState(
                                context: context,
                                isDark: isDark,
                                heading: 'Hakuna Dodoso Lililojazwa',
                                description: 'Dodoso zitaonyeshwa hapa',
                              ),
                    )
                  else ...[
                    if (!_isSelectionMode) _buildFilterChips(isDark),
                    Expanded(
                      child:
                          isOnline
                              ? RefreshIndicator(
                                onRefresh: () => _handleRefresh(isOnline),
                                child: _buildSurveyList(isDark),
                              )
                              : _buildSurveyList(isDark),
                    ),
                  ],
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
