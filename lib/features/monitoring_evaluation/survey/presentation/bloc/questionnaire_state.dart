import 'package:equatable/equatable.dart';
import '../../../../../shared/models/questionnaire.dart';

class QuestionnaireState extends Equatable {
  final List<Questionnaire> questionnaires;
  final bool isLoading;
  final String? errorMessage;
  final String searchQuery;

  const QuestionnaireState({
    required this.questionnaires,
    this.isLoading = false,
    this.errorMessage,
    this.searchQuery = '',
  });

  factory QuestionnaireState.initial() {
    return const QuestionnaireState(
      questionnaires: [],
      isLoading: false,
    );
  }

  List<Questionnaire> get filteredQuestionnaires {
    if (searchQuery.isEmpty) {
      return questionnaires;
    }

    final query = searchQuery.toLowerCase();
    return questionnaires.where((q) {
      return q.name.toLowerCase().contains(query) ||
          q.description.toLowerCase().contains(query);
    }).toList();
  }

  QuestionnaireState copyWith({
    List<Questionnaire>? questionnaires,
    bool? isLoading,
    String? errorMessage,
    String? searchQuery,
  }) {
    return QuestionnaireState(
      questionnaires: questionnaires ?? this.questionnaires,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        questionnaires,
        isLoading,
        errorMessage,
        searchQuery,
      ];
}
