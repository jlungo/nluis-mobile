import 'dart:convert';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.userType,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.phoneNumber,
    super.role,
    super.organization,
    required super.modules,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Parse organization
    UserOrganization? organization;
    if (json['organization'] != null && json['organization'] is Map) {
      final orgData = json['organization'] as Map<String, dynamic>;
      organization = UserOrganization(
        id: orgData['id'] as String,
        name: orgData['name'] as String,
      );
    }

    // Parse role
    UserRole? role;
    if (json['role'] != null && json['role'] is Map) {
      final roleData = json['role'] as Map<String, dynamic>;
      role = UserRole(
        id: roleData['id'] as String,
        name: roleData['name'] as String,
      );
    }

    // Parse modules
    List<UserModule> modules = [];
    if (json['modules'] != null && json['modules'] is List) {
      modules = (json['modules'] as List<dynamic>)
          .map((e) => UserModule(
                id: e['id'] as int,
                module: e['module'] as String,
              ))
          .toList();
    }

    return UserModel(
      id: json['id'] as String,
      userType: json['user_type'] as int,
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      phoneNumber: json['phone_number'] as String? ?? '',
      role: role,
      organization: organization,
      modules: modules,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_type': userType,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'role': role != null
          ? {
              'id': role!.id,
              'name': role!.name,
            }
          : null,
      'organization': organization != null
          ? {
              'id': organization!.id,
              'name': organization!.name,
            }
          : null,
      'modules': modules
          .map((m) => {
                'id': m.id,
                'module': m.module,
              })
          .toList(),
    };
  }

  String toJsonString() => json.encode(toJson());

  factory UserModel.fromJsonString(String source) =>
      UserModel.fromJson(json.decode(source) as Map<String, dynamic>);
}
