import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nluis_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:path/path.dart' as p;

import '../../../../../core/network/network_info.dart';
import '../../../../../data/local/draft_provider.dart';
import '../../../../../data/local/database.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/widgets/app_drawer.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/questionnaire_list_bottom_sheet.dart';
import '../../../../../shared/widgets/offline_banner.dart';
import 'questionnaire_form_page.dart';

class SurveyListPage extends ConsumerStatefulWidget {
  final String projectId;
  final String? projectName;

  const SurveyListPage({super.key, required this.projectId, this.projectName});

  @override
  ConsumerState<SurveyListPage> createState() => _SurveyListPageState();
}

enum UploadStatus { idle, uploading, success, failure }

class _SurveyListPageState extends ConsumerState<SurveyListPage> {
  List<_SurveyItem> _surveys = [];
  bool _isLoading = true;
  bool _isUploading = false;
  final Set<String> _selectedSurveyIds = {};
  final Map<String, UploadStatus> _statusOverrides = {};
  final Map<String, String?> _statusErrors = {};
  int _uploadedCount = 0;

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

      // Get all survey responses for this project
      final responses =
          await (database.select(database.surveyResponses)
                ..where((tbl) => tbl.projectId.equals(widget.projectId))
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
      final List<_SurveyItem> surveys = [];

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
          _SurveyItem(
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

    final database = ref.read(databaseProvider);
    final dio = ref.read(dioClientProvider).dio;

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

    final fieldTypesCache = <String, Map<String, String>>{};
    final successes = <String>[];
    final failures = <String, String>{};
    final idsToUnselect = <String>[];

    try {
      for (final surveyId in surveyIds) {
        try {
          final responses =
              await (database.select(database.surveyResponses)
                ..where((tbl) => tbl.surveyId.equals(surveyId))).get();

          if (responses.isEmpty) {
            throw Exception('Hakuna dodoso lililohifadhiwa kwa kupakia');
          }

          final projectLocalityId = responses.first.projectId;

          for (final response in responses) {
            final formSlug = response.formSlug;
            if (formSlug == null || formSlug.isEmpty) {
              continue;
            }

            final answers = _decodeAnswers(response.answersJson);
            if (answers.isEmpty) {
              continue;
            }

            final fieldTypes = await _getFieldTypesCached(
              database,
              formSlug,
              fieldTypesCache,
            );

            final formData = await _buildFormData(
              surveyId: surveyId,
              questionnaireSlug: response.questionnaireSlug,
              formSlug: formSlug,
              projectLocalityId: projectLocalityId,
              answers: answers,
              fieldTypes: fieldTypes,
            );

            await dio.post(
              '/collect/questionnaire/submit-form-data/',
              data: formData,
              options: Options(contentType: 'multipart/form-data'),
            );
          }

          await (database.delete(database.surveyResponses)
                ..where((tbl) => tbl.surveyId.equals(surveyId)))
              .go();

          successes.add(surveyId);
          idsToUnselect.add(surveyId);
          _statusOverrides.remove(surveyId);
          _statusErrors.remove(surveyId);
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
        _uploadedCount += successes.length;
        _surveys.removeWhere(
          (survey) => successes.contains(survey.surveyId),
        );
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

  Map<String, dynamic> _decodeAnswers(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {
      // ignore parsing errors, handled by returning empty map
    }
    return {};
  }

  Future<Map<String, String>> _getFieldTypesCached(
    AppDatabase database,
    String formSlug,
    Map<String, Map<String, String>> cache,
  ) async {
    if (cache.containsKey(formSlug)) {
      return cache[formSlug]!;
    }

    final fields =
        await (database.select(database.formFields)
          ..where((tbl) => tbl.formSlug.equals(formSlug))).get();

    final fieldTypes = <String, String>{
      for (final field in fields) field.id.toString(): field.type.toLowerCase(),
    };

    cache[formSlug] = fieldTypes;
    return fieldTypes;
  }

  Future<FormData> _buildFormData({
    required String surveyId,
    required String? questionnaireSlug,
    required String formSlug,
    required String projectLocalityId,
    required Map<String, dynamic> answers,
    required Map<String, String> fieldTypes,
  }) async {
    final formData = FormData();

    formData.fields.add(MapEntry('project_locality_id', projectLocalityId));
    formData.fields.add(MapEntry('form_slug', formSlug));
    formData.fields.add(MapEntry('survey_id', surveyId));

    if (questionnaireSlug != null && questionnaireSlug.isNotEmpty) {
      formData.fields.add(MapEntry('questionnaire_slug', questionnaireSlug));
    }

    for (final entry in answers.entries) {
      final fieldId = entry.key;
      final value = entry.value;
      final fieldType = fieldTypes[fieldId]?.toLowerCase() ?? '';
      final dataKey = 'data-$fieldId';

      if (value == null) {
        continue;
      }

      var handled = false;

      if (fieldType == 'file') {
        final filePath =
            value is List
                ? _extractFilePathFromList(value)
                : _extractFilePath(value);

        if (filePath != null) {
          final file = File(filePath);
          if (await file.exists()) {
            formData.files.add(
              MapEntry(
                dataKey,
                await MultipartFile.fromFile(
                  file.path,
                  filename: p.basename(file.path),
                ),
              ),
            );
            handled = true;
          }
        }
      }

      if (!handled) {
        final serialized = _serializeForUpload(value);
        if (serialized != null) {
          formData.fields.add(MapEntry(dataKey, serialized));
        } else {
          continue;
        }
      }

      formData.fields.add(MapEntry(fieldId, projectLocalityId));
    }

    return formData;
  }

  String? _extractFilePathFromList(List<dynamic> values) {
    for (final item in values) {
      final path = _extractFilePath(item);
      if (path != null && path.isNotEmpty) {
        return path;
      }
    }
    return null;
  }

  String? _extractFilePath(dynamic value) {
    if (value == null) return null;
    if (value is String && value.isNotEmpty) {
      return _sanitizeFilePath(value);
    }
    if (value is File) {
      return value.path;
    }
    if (value is Map) {
      for (final key in ['path', 'filePath', 'filepath', 'value', 'url']) {
        final candidate = value[key];
        if (candidate is String && candidate.isNotEmpty) {
          return _sanitizeFilePath(candidate);
        }
      }
    }
    return null;
  }

  String? _sanitizeFilePath(String path) {
    if (path.isEmpty) return null;
    if (path.startsWith('http')) return null;
    return path.startsWith('file://') ? path.replaceFirst('file://', '') : path;
  }

  String? _serializeForUpload(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is num) return value.toString();
    if (value is bool) return value ? 'true' : 'false';
    if (value is List || value is Map) return jsonEncode(value);
    return value.toString();
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

  Widget _buildEmptyState(bool isDark) {
    return ListView(
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
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Dodoso zitaonyeshwa hapa',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
    );
  }

  Widget _buildSurveyList(bool isDark) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      itemCount: _surveys.length,
      itemBuilder: (context, index) {
        final survey = _surveys[index];
        final isSelected = _selectedSurveyIds.contains(survey.surveyId);

        return _SurveyCard(
          survey: survey,
          projectName: widget.projectName ?? 'Project',
          isDark: isDark,
          isSelected: isSelected,
          onSelectionChanged: (selected) {
            setState(() {
              if (selected &&
                  !survey.isDraft &&
                  survey.uploadStatus != UploadStatus.uploading) {
                _selectedSurveyIds.add(survey.surveyId);
              } else {
                _selectedSurveyIds.remove(survey.surveyId);
              }
            });
          },
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => QuestionnaireFormPage(
                      questionnaireSlug: survey.questionnaireSlug,
                      projectId: widget.projectId,
                      projectName: widget.projectName ?? 'Project',
                      surveyId: survey.surveyId,
                    ),
              ),
            ).then((_) => _loadSurveys());
          },
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: color,
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onlineStatus = ref.watch(onlineStatusProvider);
    final isOnline =
        onlineStatus.maybeWhen(data: (value) => value, orElse: () => true);

    return Scaffold(
      appBar: const CustomAppBar(hasNotification: true),
      drawer: const AppDrawer(),
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (!isOnline) const OfflineBanner(),
                if (_surveys.isEmpty)
                  Expanded(
                    child: isOnline
                        ? RefreshIndicator(
                            onRefresh: () => _handleRefresh(isOnline),
                            child: _buildEmptyState(isDark),
                          )
                        : _buildEmptyState(isDark),
                  )
                else ...[
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
                          if (_uploadedCount > 0)
                            Padding(
                              padding: const EdgeInsets.only(
                                right: AppConstants.spacingSm,
                              ),
                              child: _StatusChip(
                                label: 'Zimepakiwa: $_uploadedCount',
                                color: AppColors.success,
                                isDark: isDark,
                              ),
                            ),
                          ElevatedButton(
                            onPressed:
                                _isUploading ? null : _uploadSelectedSurveys,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_isUploading)
                                  const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                else
                                  const Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 20,
                                  ),
                                const SizedBox(width: AppConstants.spacingXs),
                                Text(_isUploading ? 'Inapakia...' : 'Pakia'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: isOnline
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

class _SurveyItem {
  final String surveyId;
  final String projectId;
  final String questionnaireSlug;
  final String questionnaireName;
  final bool isDraft;
  final bool isDirty;
  final int formsCount;
  final String savedDate;
  final int updatedAt;
  final UploadStatus uploadStatus;
  final String? lastError;

  _SurveyItem({
    required this.surveyId,
    required this.projectId,
    required this.questionnaireSlug,
    required this.questionnaireName,
    required this.isDraft,
    required this.isDirty,
    required this.formsCount,
    required this.savedDate,
    required this.updatedAt,
    this.uploadStatus = UploadStatus.idle,
    this.lastError,
  });

  _SurveyItem copyWith({
    String? questionnaireName,
    bool? isDraft,
    bool? isDirty,
    int? formsCount,
    String? savedDate,
    int? updatedAt,
    UploadStatus? uploadStatus,
    String? Function()? lastError,
  }) {
    return _SurveyItem(
      surveyId: surveyId,
      projectId: projectId,
      questionnaireSlug: questionnaireSlug,
      questionnaireName: questionnaireName ?? this.questionnaireName,
      isDraft: isDraft ?? this.isDraft,
      isDirty: isDirty ?? this.isDirty,
      formsCount: formsCount ?? this.formsCount,
      savedDate: savedDate ?? this.savedDate,
      updatedAt: updatedAt ?? this.updatedAt,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      lastError: lastError != null ? lastError() : this.lastError,
    );
  }
}

class _SurveyCard extends StatelessWidget {
  final _SurveyItem survey;
  final String projectName;
  final bool isDark;
  final bool isSelected;
  final Function(bool) onSelectionChanged;
  final VoidCallback onTap;
  final VoidCallback? onRetry;

  const _SurveyCard({
    required this.survey,
    required this.projectName,
    required this.isDark,
    required this.isSelected,
    required this.onSelectionChanged,
    required this.onTap,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUploading = survey.uploadStatus == UploadStatus.uploading;
    final canSelect = !survey.isDraft && !isUploading;

    Color statusColor;
    IconData statusIcon;

    if (survey.isDraft) {
      statusColor = AppColors.warning;
      statusIcon = Icons.drafts;
    } else {
      switch (survey.uploadStatus) {
        case UploadStatus.success:
          statusColor = AppColors.success;
          statusIcon = Icons.cloud_done;
          break;
        case UploadStatus.failure:
          statusColor = AppColors.error;
          statusIcon = Icons.error_outline;
          break;
        case UploadStatus.uploading:
          statusColor = AppColors.info;
          statusIcon = Icons.cloud_upload;
          break;
        case UploadStatus.idle:
          statusColor = survey.isDirty ? AppColors.info : AppColors.success;
          statusIcon =
              survey.isDirty ? Icons.pending_outlined : Icons.check_circle;
      }
    }

    Widget buildStatusIndicator() {
      if (survey.isDraft) {
        return _StatusChip(
          label: 'Rasimu',
          color: AppColors.warning,
          isDark: isDark,
        );
      }

      switch (survey.uploadStatus) {
        case UploadStatus.uploading:
          return const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        case UploadStatus.success:
          return _StatusChip(
            label: 'Imepakiwa',
            color: AppColors.success,
            isDark: isDark,
          );
        case UploadStatus.failure:
          return _StatusChip(
            label: 'Imeshindikana',
            color: AppColors.error,
            isDark: isDark,
          );
        case UploadStatus.idle:
          return _StatusChip(
            label: survey.isDirty ? 'Haijapakiwa' : 'Imehifadhiwa',
            color: survey.isDirty ? AppColors.info : AppColors.success,
            isDark: isDark,
          );
      }
    }

    final statusIndicator = buildStatusIndicator();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppConstants.spacingSm),
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border:
              isSelected
                  ? Border.all(color: AppColors.primary, width: 1.6)
                  : null,
          boxShadow: [
            BoxShadow(
              color:
                  isDark
                      ? Colors.black.withValues(alpha: 0.18)
                      : Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 36,
              child:
                  survey.isDraft
                      ? const SizedBox.shrink()
                      : Checkbox(
                          value: isSelected,
                          onChanged:
                              canSelect
                                  ? (value) =>
                                      onSelectionChanged(value ?? false)
                                  : null,
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          activeColor: AppColors.primary,
                        ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
              child: Icon(statusIcon, color: statusColor, size: 22),
            ),
            const SizedBox(width: AppConstants.spacingSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          survey.questionnaireName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color:
                                isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      statusIndicator,
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingXs),
                  Wrap(
                    spacing: AppConstants.spacingSm,
                    runSpacing: AppConstants.spacingXs,
                    children: [
                      _MetaItem(
                        icon: Icons.folder_outlined,
                        label: projectName,
                        isDark: isDark,
                      ),
                      _MetaItem(
                        icon: Icons.assignment_outlined,
                        label: '${survey.formsCount} fomu',
                        isDark: isDark,
                      ),
                      _MetaItem(
                        icon: Icons.schedule,
                        label: survey.savedDate,
                        isDark: isDark,
                      ),
                    ],
                  ),
                  if (survey.uploadStatus == UploadStatus.failure &&
                      survey.lastError != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppConstants.spacingXs,
                      ),
                      child: Text(
                        survey.lastError!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  if (survey.uploadStatus == UploadStatus.failure &&
                      onRetry != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppConstants.spacingXs,
                      ),
                      child: TextButton(
                        onPressed: onRetry,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Jaribu tena'),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isDark;

  const _StatusChip({
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingSm,
        vertical: AppConstants.spacingXs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.12),
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;

  const _MetaItem({
    required this.icon,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingSm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
