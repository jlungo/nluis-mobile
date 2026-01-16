import 'dart:convert';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.mobileModules,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> modules = [];
    if (json['modules'] != null && json['modules'] is List) {
      modules =
          (json['modules'] as List<dynamic>)
              .map((e) => e as Map<String, dynamic>)
              .toList();
    }

    // final userId = json['id'];
    // final int id = userId is int ? userId : int.parse(userId.toString());

    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      mobileModules: modules,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'modules': mobileModules,
    };
  }

  String toJsonString() => json.encode(toJson());

  factory UserModel.fromJsonString(String source) =>
      UserModel.fromJson(json.decode(source) as Map<String, dynamic>);
}
