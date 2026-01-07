import '../../domain/entities/auth_session.dart';
import 'auth_user_model.dart';

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({
    required super.token,
    super.user,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    final token = json['token']?.toString() ?? '';
    final userJson = json['user'];
    return AuthSessionModel(
      token: token,
      user: userJson is Map<String, dynamic> ? AuthUserModel.fromJson(userJson) : null,
    );
  }
}
