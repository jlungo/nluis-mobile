import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../../../shared/states/page_state.dart';
import '../../domain/repositories/project_repository.dart';
import 'projects_event.dart';
import 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final ProjectRepository repository;

  ProjectsBloc({required this.repository}) : super(ProjectsState.initial()) {
    on<LoadProjects>(_onLoadProjects);
    on<RefreshProjects>(_onRefreshProjects);
  }

  Future<void> _onLoadProjects(
    LoadProjects event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(state.copyWith(pageState: PageState.loading));

    final result = await repository.getAssignedProjects(event.moduleSlug);

    result.fold(
      (failure) {
        if (failure is NetworkFailure) {
          emit(
            state.copyWith(
              pageState: PageState.noInternet,
              errorMessage: failure.message,
            ),
          );
        } else {
          emit(
            state.copyWith(
              pageState:
                  state.projects.isEmpty
                      ? PageState.loadFailed
                      : PageState.success,
              errorMessage: failure.message,
            ),
          );
        }
      },
      (projects) {
        emit(
          state.copyWith(
            pageState: projects.isEmpty ? PageState.empty : PageState.success,
            projects: projects,
          ),
        );
      },
    );
  }

  Future<void> _onRefreshProjects(
    RefreshProjects event,
    Emitter<ProjectsState> emit,
  ) async {
    final result = await repository.getAssignedProjects(event.moduleSlug);

    result.fold(
      (failure) {
        emit(state.copyWith(errorMessage: failure.message));
      },
      (projects) {
        emit(
          state.copyWith(
            pageState: projects.isEmpty ? PageState.empty : PageState.success,
            projects: projects,
            errorMessage: null,
          ),
        );
      },
    );
  }
}
