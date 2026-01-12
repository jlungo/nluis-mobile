import 'package:equatable/equatable.dart';

abstract class QuestionnaireEvent extends Equatable {
  const QuestionnaireEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuestionnaires extends QuestionnaireEvent {
  final String? keyword;
  final String module;
  final String? category;

  const LoadQuestionnaires({
    this.keyword,
    required this.module,
    this.category,
  });

  @override
  List<Object?> get props => [keyword, module, category];
}

class SearchQuestionnaires extends QuestionnaireEvent {
  final String query;

  const SearchQuestionnaires(this.query);

  @override
  List<Object?> get props => [query];
}
