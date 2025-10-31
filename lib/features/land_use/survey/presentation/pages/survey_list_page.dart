import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import 'questionnaire_form_page.dart';
import '../../../../../shared/widgets/page_empty_state.dart';
import '../../../../auth/presentation/providers/auth_providers.dart';
import '../../../../../core/network/network_info.dart';
import '../../../../../data/local/draft_provider.dart';
import '../../../../../data/local/database.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/utils/snackbar_utils.dart';
import '../../../../../shared/widgets/app_drawer.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/questionnaire_list_bottom_sheet.dart';
import '../../../../../shared/widgets/offline_banner.dart';
import '../models/survey_item.dart';
import '../widgets/survey_card.dart';

class SurveyListPage extends ConsumerStatefulWidget {
  final String projectId;
  final String? projectName;

  const SurveyListPage({super.key, required this.projectId, this.projectName});

  @override
  ConsumerState<SurveyListPage> createState() => _SurveyListPageState();
}

class _SurveyListPageState extends ConsumerState<SurveyListPage> {
  List<SurveyItem> _surveys = [];
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
      projectName: widget.projectName ?? 'Project',
      module: 'land-uses',
      onQuestionnaireSelected: (questionnaireSlug) {
        // TODO: Remove Using context.push since QuestionnaireFormPage and define goRoute 
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder:
                    (_) => QuestionnaireFormPage(
                      questionnaireSlug: questionnaireSlug,
                      projectId: widget.projectId,
                      projectName: widget.projectName ?? 'Project',
                    ),
              ),
            )
            .then((_) => _loadSurveys()); // Refresh when returning
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
    final dioClient = ref.read(dioClientProvider);

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
              // surveyId: surveyId,
              questionnaireSlug: response.questionnaireSlug,
              formSlug: formSlug,
              projectLocalityId: projectLocalityId,
              answers: answers,
              fieldTypes: fieldTypes,
            );

            // print("===formData: ${jsonEncode(formData)}");

            await dioClient.post(
              '/collect/questionnaire/submit-form-data/',
              data: formData,
              options: Options(contentType: 'multipart/form-data'),
            );
          }

          // Remove from draft & dirty surveys
          final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
          await (database.update(database.surveyResponses)
            ..where((tbl) => tbl.surveyId.equals(surveyId))).write(
            SurveyResponsesCompanion(
              isDraft: const drift.Value(false),
              dirty: const drift.Value(false),
              updatedAt: drift.Value(now),
            ),
          );

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
    // required String surveyId,
    required String? questionnaireSlug,
    required String formSlug,
    required String projectLocalityId,
    required Map<String, dynamic> answers,
    required Map<String, String> fieldTypes,
  }) async {
    final formData = FormData();

    formData.fields.add(MapEntry('project_locality_id', projectLocalityId));
    formData.fields.add(MapEntry('form_slug', formSlug));
    // formData.fields.add(MapEntry('survey_id', surveyId));

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

  Widget _buildSurveyList(bool isDark) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      itemCount: _surveys.length,
      itemBuilder: (context, index) {
        final survey = _surveys[index];
        final isSelected = _selectedSurveyIds.contains(survey.surveyId);

        return SurveyCard(
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
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder:
                        (_) => QuestionnaireFormPage(
                          questionnaireSlug: survey.questionnaireSlug,
                          projectId: widget.projectId,
                          projectName: widget.projectName ?? 'Project',
                          surveyId: survey.surveyId,
                        ),
                  ),
                )
                .then((_) => _loadSurveys());
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
      appBar: const CustomAppBar(
        title: 'Dodoso Zilizojazwa',
        showBackButton: true,
        showNotifications: false,
        showProfile: false,
      ),
      drawer: const AppDrawer(),
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  if (!isOnline) const OfflineBanner(),
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
                                child: StatusChip(
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
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppConstants.spacingMd,
                                  vertical: 8,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_isUploading)
                                    const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
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
