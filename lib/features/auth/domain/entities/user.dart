import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final List<Map<String, dynamic>> mobileModules;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.mobileModules,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [id, email, firstName, lastName, mobileModules];
}
