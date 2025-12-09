import 'package:equatable/equatable.dart';

enum PhotoType {
  site,
  boundary,
  other,
}

class ParcelPhoto extends Equatable {
  final String clientId; // Local UUID
  final int? serverId; // Server ID after upload
  final String parcelId; // Parcel client ID
  final String photoPath; // Local file path
  final String? photoUrl; // Server URL after upload
  final PhotoType photoType;
  final String? caption;
  final DateTime capturedAt;
  final bool uploaded;
  final DateTime? uploadedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ParcelPhoto({
    required this.clientId,
    this.serverId,
    required this.parcelId,
    required this.photoPath,
    this.photoUrl,
    this.photoType = PhotoType.site,
    this.caption,
    required this.capturedAt,
    this.uploaded = false,
    this.uploadedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  String get photoTypeLabel {
    switch (photoType) {
      case PhotoType.site:
        return 'Eneo';
      case PhotoType.boundary:
        return 'Mpaka';
      case PhotoType.other:
        return 'Nyingine';
    }
  }

  bool get hasLocalPhoto => photoPath.isNotEmpty;
  bool get hasServerPhoto => photoUrl != null && photoUrl!.isNotEmpty;

  ParcelPhoto copyWith({
    String? clientId,
    int? serverId,
    String? parcelId,
    String? photoPath,
    String? photoUrl,
    PhotoType? photoType,
    String? caption,
    DateTime? capturedAt,
    bool? uploaded,
    DateTime? uploadedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ParcelPhoto(
      clientId: clientId ?? this.clientId,
      serverId: serverId ?? this.serverId,
      parcelId: parcelId ?? this.parcelId,
      photoPath: photoPath ?? this.photoPath,
      photoUrl: photoUrl ?? this.photoUrl,
      photoType: photoType ?? this.photoType,
      caption: caption ?? this.caption,
      capturedAt: capturedAt ?? this.capturedAt,
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
        photoPath,
        photoUrl,
        photoType,
        caption,
        capturedAt,
        uploaded,
        uploadedAt,
        createdAt,
        updatedAt,
      ];
}
