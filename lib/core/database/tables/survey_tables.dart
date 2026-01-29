import 'package:drift/drift.dart';

class QuestionnaireTypes extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get slug => text()();
  IntColumn get localityId => integer().named('locality_id')();

  @override
  Set<Column> get primaryKey => {id};
}

class Questionnaires extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get slug => text()();
  IntColumn get typeId => integer().named('type_id')();
  TextColumn get version => text()();
  IntColumn get updatedAt => integer().named('updated_at')();
  IntColumn get localityId => integer().named('locality_id')();
  TextColumn get description =>
      text().named('description').withDefault(const Constant(''))();
  TextColumn get moduleSlug =>
      text().named('module_slug').withDefault(const Constant(''))();
  TextColumn get moduleName =>
      text().named('module_name').withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

class Forms extends Table {
  TextColumn get slug => text()();
  IntColumn get questionnaireId =>
      integer().named('questionnaire_id').nullable()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get moduleSlug => text().named('module_slug')();
  TextColumn get workflowSlug => text().named('workflow_slug')();
  IntColumn get position => integer()();
  IntColumn get updatedAt => integer().named('updated_at')();
  TextColumn get sectionSlug =>
      text().named('section_slug').withDefault(const Constant(''))();
  TextColumn get sectionName =>
      text().named('section_name').withDefault(const Constant(''))();
  IntColumn get sectionPosition =>
      integer().named('section_position').withDefault(const Constant(0))();
  TextColumn get sectionDescription =>
      text().named('section_description').nullable()();

  @override
  Set<Column> get primaryKey => {slug};
}

class FormFields extends Table {
  IntColumn get id => integer()();
  TextColumn get formSlug => text().named('form_slug')();
  TextColumn get label => text()();
  TextColumn get type => text()();
  TextColumn get name => text()();
  BoolColumn get required => boolean().withDefault(const Constant(false))();
  IntColumn get position => integer()();
  TextColumn get optionsJson => text().named('options_json').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SurveyResponses extends Table {
  TextColumn get id => text()();
  TextColumn get surveyId => text().named('survey_id')();
  TextColumn get projectId => text().named('project_id')();
  TextColumn get moduleSlug =>
      text().named('module_slug').withDefault(const Constant(''))();
  IntColumn get questionnaireId => integer().named('questionnaire_id')();
  TextColumn get questionnaireSlug =>
      text().named('questionnaire_slug').nullable()();
  TextColumn get formSlug => text().named('form_slug').nullable()();
  TextColumn get answersJson => text().named('answers_json')();
  BoolColumn get isDraft =>
      boolean().named('is_draft').withDefault(const Constant(true))();
  IntColumn get updatedAt => integer().named('updated_at')();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();
  TextColumn get schemaSnapshotJson =>
      text().named('schema_snapshot_json').nullable()();
  IntColumn get uploadStatus =>
      integer().named('upload_status').withDefault(const Constant(0))();
  RealColumn get uploadProgress =>
      real().named('upload_progress').withDefault(const Constant(0.0))();

  @override
  Set<Column> get primaryKey => {id};
}
