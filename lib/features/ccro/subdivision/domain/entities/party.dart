import 'package:equatable/equatable.dart';

enum PartyType {
  individual,
  organization,
}

class Party extends Equatable {
  final String clientId; // Local UUID
  final int? serverId; // Server ID after upload
  final PartyType partyType;
  
  // Individual party fields
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? nidaNumber; // 20 digits
  final String? phone;
  final String? email;
  final String? gender; // M, F
  final String? dateOfBirth; // ISO format
  final bool isCitizen;
  final String? maritalStatus;
  final String? occupation;
  
  final bool uploaded;
  final DateTime? uploadedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Party({
    required this.clientId,
    this.serverId,
    required this.partyType,
    this.firstName,
    this.middleName,
    this.lastName,
    this.nidaNumber,
    this.phone,
    this.email,
    this.gender,
    this.dateOfBirth,
    this.isCitizen = true,
    this.maritalStatus,
    this.occupation,
    this.uploaded = false,
    this.uploadedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName {
    if (partyType == PartyType.individual) {
      final parts = [firstName, middleName, lastName]
          .where((p) => p != null && p.isNotEmpty);
      return parts.join(' ');
    }
    return firstName ?? '';
  }

  bool get isNidaValid {
    if (nidaNumber == null) return false;
    return nidaNumber!.length == 20 && RegExp(r'^\d{20}$').hasMatch(nidaNumber!);
  }

  Party copyWith({
    String? clientId,
    int? serverId,
    PartyType? partyType,
    String? firstName,
    String? middleName,
    String? lastName,
    String? nidaNumber,
    String? phone,
    String? email,
    String? gender,
    String? dateOfBirth,
    bool? isCitizen,
    String? maritalStatus,
    String? occupation,
    bool? uploaded,
    DateTime? uploadedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Party(
      clientId: clientId ?? this.clientId,
      serverId: serverId ?? this.serverId,
      partyType: partyType ?? this.partyType,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      nidaNumber: nidaNumber ?? this.nidaNumber,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      isCitizen: isCitizen ?? this.isCitizen,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      occupation: occupation ?? this.occupation,
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
        partyType,
        firstName,
        middleName,
        lastName,
        nidaNumber,
        phone,
        email,
        gender,
        dateOfBirth,
        isCitizen,
        maritalStatus,
        occupation,
        uploaded,
        uploadedAt,
        createdAt,
        updatedAt,
      ];
}
