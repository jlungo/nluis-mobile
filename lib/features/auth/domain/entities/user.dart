import 'package:equatable/equatable.dart';

class UserOrganization extends Equatable {
  final String id;
  final String name;

  const UserOrganization({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}

class UserRole extends Equatable {
  final String id;
  final String name;

  const UserRole({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}

class UserModule extends Equatable {
  final int id;
  final String module;

  const UserModule({
    required this.id,
    required this.module,
  });

  @override
  List<Object?> get props => [id, module];
}

class User extends Equatable {
  final String id;
  final int userType;
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final UserRole? role;
  final UserOrganization? organization;
  final List<UserModule> modules;

  const User({
    required this.id,
    required this.userType,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.role,
    this.organization,
    required this.modules,
  });

  String get fullName => '$firstName $lastName';

  bool get isMobileUser => userType == 5;

  @override
  List<Object?> get props => [
        id,
        userType,
        email,
        firstName,
        lastName,
        phoneNumber,
        role,
        organization,
        modules,
      ];
}
