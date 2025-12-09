import 'package:equatable/equatable.dart';

enum ApplicationStatus {
  draft,
  submitted,
  approved,
  rejected,
}

class SubdivisionApplication extends Equatable {
  final String clientId; // Local UUID
  final int? serverId; // Server ID after upload
  final String? applicationNumber;
  final int zoneId;
  final int localityId;
  final String applicantId; // Party client ID
  final ApplicationStatus status;
  final String? notes;
  final bool uploaded;
  final DateTime? uploadedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SubdivisionApplication({
    required this.clientId,
    this.serverId,
    this.applicationNumber,
    required this.zoneId,
    required this.localityId,
    required this.applicantId,
    this.status = ApplicationStatus.draft,
    this.notes,
    this.uploaded = false,
    this.uploadedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isDraft => status == ApplicationStatus.draft;
  bool get isSubmitted => status == ApplicationStatus.submitted;
  bool get isApproved => status == ApplicationStatus.approved;
  bool get isRejected => status == ApplicationStatus.rejected;

  String get statusLabel {
    switch (status) {
      case ApplicationStatus.draft:
        return 'Rasimu';
      case ApplicationStatus.submitted:
        return 'Imewasilishwa';
      case ApplicationStatus.approved:
        return 'Imeidhinishwa';
      case ApplicationStatus.rejected:
        return 'Imekataliwa';
    }
  }

  SubdivisionApplication copyWith({
    String? clientId,
    int? serverId,
    String? applicationNumber,
    int? zoneId,
    int? localityId,
    String? applicantId,
    ApplicationStatus? status,
    String? notes,
    bool? uploaded,
    DateTime? uploadedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubdivisionApplication(
      clientId: clientId ?? this.clientId,
      serverId: serverId ?? this.serverId,
      applicationNumber: applicationNumber ?? this.applicationNumber,
      zoneId: zoneId ?? this.zoneId,
      localityId: localityId ?? this.localityId,
      applicantId: applicantId ?? this.applicantId,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      uploaded: uploaded ?? this.uploaded,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        clientId,
        serverId,
        applicationNumber,
        zoneId,
        localityId,
        applicantId,
        status,
        notes,
        uploaded,
        uploadedAt,
        createdAt,
        updatedAt,
      ];
}
