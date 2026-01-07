import '../entities/check_phone_result.dart';
import '../repositories/auth_repository.dart';

class CheckPhoneUsecase {
  final AuthRepository _repo;

  const CheckPhoneUsecase(this._repo);

  Future<CheckPhoneResult> call({required String mobile}) {
    return _repo.checkPhone(mobile: mobile);
  }
}
