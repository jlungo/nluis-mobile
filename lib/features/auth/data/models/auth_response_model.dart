import 'user_model.dart';

class AuthResponseModel {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final UserModel user;

  const AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    // API returns user data at root level, not nested
    return AuthResponseModel(
      accessToken: json['access'] as String,
      refreshToken: json['refresh'] as String,
      expiresIn: json['expires_in'] as int? ?? 3600,
      user: UserModel.fromJson(json), // Pass entire response since user data is at root
    );
  }
}
