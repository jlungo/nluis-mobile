import 'package:equatable/equatable.dart';
import '../../../../shared/states/page_state.dart';
import '../../domain/entities/project.dart';

class ProjectsState extends Equatable {
  final PageState pageState;
  final List<Project> projects;
  final String? errorMessage;

  const ProjectsState({
    required this.pageState,
    required this.projects,
    this.errorMessage,
  });

  factory ProjectsState.initial() {
    return const ProjectsState(
      pageState: PageState.loading,
      projects: [],
    );
  }

  ProjectsState copyWith({
    PageState? pageState,
    List<Project>? projects,
    String? errorMessage,
  }) {
    return ProjectsState(
      pageState: pageState ?? this.pageState,
      projects: projects ?? this.projects,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [pageState, projects, errorMessage];
}
