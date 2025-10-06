import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String id; // locality id from the API
  final String name; // locality__name - parent project name format
  final String localityName; // just the locality name
  final String parentProjectName; // parent project name
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

  // Helper getter for status
  String get status {
    switch (projectStatus) {
      case 1:
        return 'Pending';
      case 2:
        return 'In Process';
      case 3:
        return 'Completed';
      case 4:
        return 'On Hold';
      case 0:
      default:
        return 'Unknown';
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

class ProjectModel extends Project {
  const ProjectModel({
    required super.id,
    required super.name,
    required super.localityName,
    required super.parentProjectName,
    required super.organization,
    required super.authorizationDate,
    required super.projectStatus,
    required super.createdAt,
    required super.progress,
    super.remarks,
    super.hasSurvey,
    super.hasZoning,
  });

  // Factory to create from locality data within a parent project
  factory ProjectModel.fromLocalityJson(
    Map<String, dynamic> localityJson,
    Map<String, dynamic> parentProjectJson,
  ) {
    final localityName = localityJson['locality__name'] as String;
    final parentName = parentProjectJson['name'] as String;

    return ProjectModel(
      id: localityJson['id'].toString(),
      name: '$localityName - $parentName',
      localityName: localityName,
      parentProjectName: parentName,
      organization: parentProjectJson['organization'] as String? ?? '',
      authorizationDate: parentProjectJson['authorization_date'] as String? ?? '',
      projectStatus: parentProjectJson['project_status'] as int? ?? 0,
      createdAt: parentProjectJson['created_at'] as String? ?? '',
      progress: (localityJson['progress'] as num?)?.toDouble() ?? 0.0,
      remarks: localityJson['remarks'] as String?,
      hasSurvey: true,
      hasZoning: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'locality_name': localityName,
      'parent_project_name': parentProjectName,
      'organization': organization,
      'authorization_date': authorizationDate,
      'project_status': projectStatus,
      'created_at': createdAt,
      'progress': progress,
      'remarks': remarks,
      'has_survey': hasSurvey,
      'has_zoning': hasZoning,
    };
  }
}
