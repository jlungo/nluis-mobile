import 'package:equatable/equatable.dart';

/// Represents a locality with its projects and feature counts
class LocalityProject extends Equatable {
  final String localityId;
  final String localityName;
  final int draftCount;
  final int savedCount;
  final int uploadedCount;
  final List<String> projectIds;

  const LocalityProject({
    required this.localityId,
    required this.localityName,
    required this.draftCount,
    required this.savedCount,
    required this.uploadedCount,
    required this.projectIds,
  });

  int get totalFeatures => draftCount + savedCount + uploadedCount;

  @override
  List<Object?> get props => [
        localityId,
        localityName,
        draftCount,
        savedCount,
        uploadedCount,
        projectIds,
      ];
}
