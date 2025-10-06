import 'package:equatable/equatable.dart';

class QuestionnaireType extends Equatable {
  final int id;
  final String name;
  final String slug;
  final int localityId;

  const QuestionnaireType({
    required this.id,
    required this.name,
    required this.slug,
    required this.localityId,
  });

  @override
  List<Object?> get props => [id, name, slug, localityId];
}

class Questionnaire extends Equatable {
  final int id;
  final String name;
  final String slug;
  final int typeId;
  final String version;
  final int updatedAt;
  final int localityId;

  const Questionnaire({
    required this.id,
    required this.name,
    required this.slug,
    required this.typeId,
    required this.version,
    required this.updatedAt,
    required this.localityId,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        typeId,
        version,
        updatedAt,
        localityId,
      ];
}

class QuestionnaireModel extends Questionnaire {
  const QuestionnaireModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.typeId,
    required super.version,
    required super.updatedAt,
    required super.localityId,
  });

  factory QuestionnaireModel.fromJson(Map<String, dynamic> json) {
    return QuestionnaireModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      typeId: json['type_id'] as int? ?? json['typeId'] as int,
      version: json['version'] as String,
      updatedAt: json['updated_at'] as int? ??
                 json['updatedAt'] as int? ??
                 DateTime.now().millisecondsSinceEpoch,
      localityId: json['locality_id'] as int? ?? json['localityId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'type_id': typeId,
      'version': version,
      'updated_at': updatedAt,
      'locality_id': localityId,
    };
  }
}
