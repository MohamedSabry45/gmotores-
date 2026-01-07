import 'auth_user.dart';

class AuthSession {
  final String token;
  final AuthUser? user;

  const AuthSession({
    required this.token,
    this.user,
  });
}
