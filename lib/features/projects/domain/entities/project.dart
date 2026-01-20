import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String id;
  final String localityId;
  final String name;
  final String localityName;
  final String parentProjectName;
  final String organization;
  final String authorizationDate;
  final int projectStatus;
  final String createdAt;
  final double progress;
  final String? remarks;
  final bool hasSurvey;
  final bool hasZoning;

  const Project({
    required this.id,
    required this.name,
    required this.localityId,
    required this.localityName,
    required this.parentProjectName,
    required this.organization,
    required this.authorizationDate,
    required this.projectStatus,
    required this.createdAt,
    required this.progress,
    this.remarks,
    this.hasSurvey = false,
    this.hasZoning = false,
  });

  String get status {
    switch (projectStatus) {
      case 1:
        return 'Inasubiri';
      case 2:
        return 'Inaendelea';
      case 3:
        return 'Imekamilika';
      case 4:
        return 'Imesimamishwa';
      case 0:
      default:
        return 'Haijulikani';
    }
  }

  @override
  List<Object?> get props => [
        id,
        name,
        localityName,
        parentProjectName,
        organization,
        authorizationDate,
        projectStatus,
        createdAt,
        progress,
        remarks,
        hasSurvey,
        hasZoning,
      ];
}
