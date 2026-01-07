import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository _repo;

  const LoginUsecase(this._repo);

  Future<AuthSession> call({
    required String mobile,
    required String password,
  }) {
    return _repo.login(mobile: mobile, password: password);
  }
}
