import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;

import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../core/network/dio_client.dart';
import '../../data/local/database.dart' as local_db;
import '../../shared/models/questionnaire.dart';

abstract class QuestionnaireRepository {
  Future<Either<Failure, List<Questionnaire>>> getQuestionnaireList({
    String? keyword,
    String? module,
    String? category,
  });

  Future<Either<Failure, QuestionnaireDetail>> getQuestionnaireDetail(
    String slug,
  );
}

class QuestionnaireRepositoryImpl implements QuestionnaireRepository {
  final DioClient dioClient;
  final local_db.AppDatabase database;
  final NetworkInfo networkInfo;

  const QuestionnaireRepositoryImpl({
    required this.dioClient,
    required this.database,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Questionnaire>>> getQuestionnaireList({
    String? keyword,
    String? module,
    String? category,
  }) async {
    final isOnline = await networkInfo.isConnected;
    if (isOnline) {
      try {
        final queryParameters = <String, dynamic>{};
        if (keyword != null && keyword.isNotEmpty) {
          queryParameters['keyword'] = keyword;
        }
        if (module != null && module.isNotEmpty) {
          queryParameters['module'] = module;
        }
        if (category != null && category.isNotEmpty) {
          queryParameters['category'] = category;
        }

        final response = await dioClient.get(
          '/collect/questionnaire/list/',
          queryParameters: queryParameters,
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = response.data['results'] ?? response.data;
          final questionnaires =
              data
                  .map(
                    (json) => QuestionnaireModel.fromJson(
                      json as Map<String, dynamic>,
                    ),
                  )
                  .toList();
          return Right(questionnaires);
        }
        if (response.statusCode == 401) {
          return const Left(AuthFailure('Unauthorized'));
        }
      } on DioException catch (e) {
        if (e.response?.statusCode == 401) {
          return const Left(AuthFailure('Unauthorized'));
        }
      } catch (_) {
        // Fall back to offline data below
      }
    }

    final local = await _loadQuestionnairesFromDatabase(
      keyword: keyword,
      module: module,
    );

    if (local.isNotEmpty) {
      return Right(local);
    }

    return Left(
      isOnline
          ? const ServerFailure('Imeshindikana kupakia dodoso.')
          : const ServerFailure(
            'Dodoso halijapakuliwa. Tafadhali washa mtandao ili kusasisha.',
          ),
    );
  }

  @override
  Future<Either<Failure, QuestionnaireDetail>> getQuestionnaireDetail(
    String slug,
  ) async {
    final localDetail = await _loadQuestionnaireDetailFromDatabase(slug);
    final isOnline = await networkInfo.isConnected;

    if (!isOnline) {
      if (localDetail != null) {
        return Right(localDetail);
      }
      return const Left(
        ServerFailure('Dodoso halijapakuliwa. Washa mtandao ili kulipakua.'),
      );
    }

    try {
      final response = await dioClient.get(
        '/collect/questionnaire/$slug/detail/',
      );

      if (response.statusCode == 200) {
        final questionnaireDetail = QuestionnaireDetailModel.fromJson(
          response.data,
        );
        await _storeQuestionnaireDetail(questionnaireDetail);
        return Right(questionnaireDetail);
      }
      if (response.statusCode == 404) {
        return const Left(ServerFailure('Questionnaire not found'));
      }
      if (response.statusCode == 401) {
        return const Left(AuthFailure('Unauthorized'));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return const Left(AuthFailure('Unauthorized'));
      }
      if (localDetail != null) {
        return Right(localDetail);
      }

      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      if (localDetail != null) {
        return Right(localDetail);
      }
      return Left(ServerFailure('Unexpected error: $e'));
    }

    if (localDetail != null) {
      return Right(localDetail);
    }

    return const Left(ServerFailure('Imeshindikana kupakia dodoso.'));
  }

  Future<List<QuestionnaireModel>> _loadQuestionnairesFromDatabase({
    String? keyword,
    String? module,
  }) async {
    final records = await database.select(database.questionnaires).get();
    if (records.isEmpty) return [];

    final lowerKeyword = keyword?.toLowerCase().trim();
    final lowerModule = module?.toLowerCase().trim();

    final List<QuestionnaireModel> results = [];

    for (final record in records) {
      final formsQuery =
          database.select(database.forms)
            ..where((tbl) => tbl.questionnaireId.equals(record.id))
            ..orderBy([
              (tbl) => drift.OrderingTerm.asc(tbl.sectionPosition),
              (tbl) => drift.OrderingTerm.asc(tbl.position),
            ]);

      final forms = await formsQuery.get();
      if (forms.isEmpty) continue;

      final moduleSlug =
          record.moduleSlug.isNotEmpty
              ? record.moduleSlug
              : forms.first.moduleSlug;
      final moduleName =
          record.moduleName.isNotEmpty ? record.moduleName : moduleSlug;

      if (lowerModule != null && lowerModule.isNotEmpty) {
        final matchesModule =
            moduleSlug.toLowerCase().contains(lowerModule) ||
            moduleName.toLowerCase().contains(lowerModule);
        if (!matchesModule) {
          continue;
        }
      }

      if (lowerKeyword != null && lowerKeyword.isNotEmpty) {
        if (!record.name.toLowerCase().contains(lowerKeyword)) {
          continue;
        }
      }

      final uniqueSections =
          forms
              .map((form) => form.sectionSlug)
              .where((slug) => slug.isNotEmpty)
              .toSet();

      results.add(
        QuestionnaireModel(
          slug: record.slug,
          name: record.name,
          category: record.typeId,
          description: record.description,
          version: int.tryParse(record.version) ?? 1,
          isActive: true,
          moduleSlug: moduleSlug,
          moduleName: moduleName,
          questionnaireSectionsCount:
              uniqueSections.isNotEmpty ? uniqueSections.length : forms.length,
        ),
      );
    }

    results.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    return results;
  }

  Future<QuestionnaireDetail?> _loadQuestionnaireDetailFromDatabase(
    String slug,
  ) async {
    final questionnaire =
        await (database.select(database.questionnaires)
          ..where((tbl) => tbl.slug.equals(slug))).getSingleOrNull();

    if (questionnaire == null) return null;

    final forms =
        await (database.select(database.forms)
              ..where((tbl) => tbl.questionnaireId.equals(questionnaire.id))
              ..orderBy([
                (tbl) => drift.OrderingTerm.asc(tbl.sectionPosition),
                (tbl) => drift.OrderingTerm.asc(tbl.position),
              ]))
            .get();

    if (forms.isEmpty) return null;

    final moduleSlug =
        questionnaire.moduleSlug.isNotEmpty
            ? questionnaire.moduleSlug
            : forms.first.moduleSlug;
    final moduleName =
        questionnaire.moduleName.isNotEmpty
            ? questionnaire.moduleName
            : moduleSlug;

    final Map<String, _SectionAccumulator> sections = {};

    for (final form in forms) {
      final fields =
          await (database.select(database.formFields)
                ..where((tbl) => tbl.formSlug.equals(form.slug))
                ..orderBy([(tbl) => drift.OrderingTerm.asc(tbl.position)]))
              .get();

      final customFields =
          fields.map((field) {
            final options = _decodeOptions(field.optionsJson);
            final selectOptions =
                options.asMap().entries.map((entry) {
                  final value = entry.value;
                  return SelectOptionModel(
                    textLabel:
                        (value['text_label'] ??
                                value['label'] ??
                                value['value'] ??
                                '')
                            .toString(),
                    value:
                        (value['value'] ?? value['text'] ?? value['id'] ?? '')
                            .toString(),
                    position:
                        value['position'] is num
                            ? (value['position'] as num).toInt()
                            : entry.key,
                  );
                }).toList();

            return CustomFormFieldModel(
              id: field.id.toString(),
              label: field.label,
              type: field.type,
              typeDisplay: field.type,
              placeholder: '',
              name: field.name,
              required: field.required,
              position: field.position,
              isActive: true,
              selectOptions: selectOptions,
            );
          }).toList();

      final sectionSlug =
          form.sectionSlug.isNotEmpty ? form.sectionSlug : '${slug}_section';
      final section = sections.putIfAbsent(
        sectionSlug,
        () => _SectionAccumulator(
          slug: sectionSlug,
          name:
              form.sectionName.isNotEmpty ? form.sectionName : 'Sehemu',
          description: form.sectionDescription ?? '',
          position: form.sectionPosition,
        ),
      );

      section.forms.add(
        QuestionnaireFormModel(
          slug: form.slug,
          name: form.name,
          description: form.description,
          isActive: true,
          questionnaireSectionSlug: section.slug,
          questionnaireSectionName: section.name,
          questionnaireSlug: slug,
          questionnaireName: questionnaire.name,
          moduleSlug: form.moduleSlug,
          moduleName: moduleName,
          position: form.position,
          customFormFields: customFields,
        ),
      );
    }

    final orderedSections =
        sections.values.toList()
          ..sort((a, b) => a.position.compareTo(b.position));

    final sectionModels = orderedSections.map((section) {
      section.forms.sort((a, b) => a.position.compareTo(b.position));
      return QuestionnaireSectionModel(
        slug: section.slug,
        name: section.name,
        description: section.description,
        position: section.position,
        isActive: true,
        questionnaireSlug: slug,
        questionnaireName: questionnaire.name,
        moduleSlug: moduleSlug,
        moduleName: moduleName,
        forms: section.forms,
      );
    }).toList();

    return QuestionnaireDetailModel(
      slug: slug,
      name: questionnaire.name,
      category: questionnaire.typeId,
      description: questionnaire.description,
      moduleSlug: moduleSlug,
      moduleName: moduleName,
      version: int.tryParse(questionnaire.version) ?? 1,
      sections: sectionModels,
    );
  }

  Future<void> _storeQuestionnaireDetail(QuestionnaireDetail detail) async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await database
        .into(database.questionnaires)
        .insertOnConflictUpdate(
          local_db.QuestionnairesCompanion(
            id: drift.Value(detail.category),
            name: drift.Value(detail.name),
            slug: drift.Value(detail.slug),
            typeId: drift.Value(detail.category),
            version: drift.Value(detail.version.toString()),
            updatedAt: drift.Value(now),
            localityId: const drift.Value(0),
            description: drift.Value(detail.description),
            moduleSlug: drift.Value(detail.moduleSlug),
            moduleName: drift.Value(detail.moduleName),
          ),
        );

    for (final section in detail.sections) {
      for (final form in section.forms) {
        await database
            .into(database.forms)
            .insertOnConflictUpdate(
              local_db.FormsCompanion(
                slug: drift.Value(form.slug),
                questionnaireId: drift.Value(detail.category),
                name: drift.Value(form.name),
                description: drift.Value(form.description),
                moduleSlug: drift.Value(form.moduleSlug),
                workflowSlug: drift.Value(form.slug),
                position: drift.Value(form.position),
                updatedAt: drift.Value(now),
                sectionSlug: drift.Value(section.slug),
                sectionName: drift.Value(section.name),
                sectionPosition: drift.Value(section.position),
                sectionDescription: drift.Value(
                  section.description.isEmpty ? null : section.description,
                ),
              ),
            );

        for (final field in form.customFormFields) {
          await database
              .into(database.formFields)
              .insertOnConflictUpdate(
                local_db.FormFieldsCompanion(
                  id: drift.Value(int.tryParse(field.id) ?? field.hashCode),
                  formSlug: drift.Value(form.slug),
                  label: drift.Value(field.label),
                  type: drift.Value(field.type),
                  name: drift.Value(field.name),
                  required: drift.Value(field.required),
                  position: drift.Value(field.position),
                  optionsJson: drift.Value(
                    field.selectOptions.isEmpty
                        ? null
                        : jsonEncode(
                          field.selectOptions
                              .map(
                                (opt) => {
                                  'text_label': opt.textLabel,
                                  'value': opt.value,
                                  'position': opt.position,
                                },
                              )
                              .toList(),
                        ),
                  ),
                ),
              );
        }
      }
    }
  }

  List<Map<String, dynamic>> _decodeOptions(String? raw) {
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .whereType<Map>()
            .map(
              (item) =>
                  item.map((key, value) => MapEntry(key.toString(), value)),
            )
            .toList();
      }
      return const [];
    } catch (_) {
      return const [];
    }
  }
}

class _SectionAccumulator {
  final String slug;
  final String name;
  final String description;
  final int position;
  final List<QuestionnaireForm> forms = [];

  _SectionAccumulator({
    required this.slug,
    required this.name,
    required this.description,
    required this.position,
  });
}
