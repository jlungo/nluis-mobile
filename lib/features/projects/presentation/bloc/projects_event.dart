import 'package:equatable/equatable.dart';

abstract class ProjectsEvent extends Equatable {
  const ProjectsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProjects extends ProjectsEvent {
  final String moduleSlug;

  const LoadProjects(this.moduleSlug);

  @override
  List<Object?> get props => [moduleSlug];
}

class RefreshProjects extends ProjectsEvent {
  final String moduleSlug;

  const RefreshProjects(this.moduleSlug);

  @override
  List<Object?> get props => [moduleSlug];
}
