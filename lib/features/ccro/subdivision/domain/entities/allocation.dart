import 'package:equatable/equatable.dart';

enum AllocationStatus {
  proposed,
  approved,
  registered,
}

class Allocation extends Equatable {
  final String clientId; // Local UUID
  final int? serverId; // Server ID after upload
  final String parcelId; // Parcel client ID
  final String partyId; // Party client ID
  final double proposedShare; // Percentage (0-100)
  final String proposedRightType;
  final AllocationStatus status;
  final String? notes;
  final bool uploaded;
  final DateTime? uploadedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Allocation({
    required this.clientId,
    this.serverId,
    required this.parcelId,
    required this.partyId,
    required this.proposedShare,
    this.proposedRightType = 'customary',
    this.status = AllocationStatus.proposed,
    this.notes,
    this.uploaded = false,
    this.uploadedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isProposed => status == AllocationStatus.proposed;
  bool get isApproved => status == AllocationStatus.approved;
  bool get isRegistered => status == AllocationStatus.registered;

  String get statusLabel {
    switch (status) {
      case AllocationStatus.proposed:
        return 'Imependekezwa';
      case AllocationStatus.approved:
        return 'Imeidhinishwa';
      case AllocationStatus.registered:
        return 'Imesajiliwa';
    }
  }

  String get shareFormatted => '${proposedShare.toStringAsFixed(1)}%';

  bool get isValidShare => proposedShare > 0 && proposedShare <= 100;

  Allocation copyWith({
    String? clientId,
    int? serverId,
    String? parcelId,
    String? partyId,
    double? proposedShare,
    String? proposedRightType,
    AllocationStatus? status,
    String? notes,
    bool? uploaded,
    DateTime? uploadedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Allocation(
      clientId: clientId ?? this.clientId,
      serverId: serverId ?? this.serverId,
      parcelId: parcelId ?? this.parcelId,
      partyId: partyId ?? this.partyId,
      proposedShare: proposedShare ?? this.proposedShare,
      proposedRightType: proposedRightType ?? this.proposedRightType,
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
        parcelId,
        partyId,
        proposedShare,
        proposedRightType,
        status,
        notes,
        uploaded,
        uploadedAt,
        createdAt,
        updatedAt,
      ];
}
