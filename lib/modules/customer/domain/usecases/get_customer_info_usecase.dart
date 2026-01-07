import '../entities/customer_info.dart';
import '../repositories/customer_repository.dart';

class GetCustomerInfoUsecase {
  final CustomerRepository _repo;

  const GetCustomerInfoUsecase(this._repo);

  Future<CustomerInfo> call() {
    return _repo.getCustomerInfo();
  }
}
