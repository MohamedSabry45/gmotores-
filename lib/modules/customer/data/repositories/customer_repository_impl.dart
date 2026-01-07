import 'package:reservation_workshop/modules/customer/domain/entities/customer_info.dart';
import 'package:reservation_workshop/modules/customer/domain/repositories/customer_repository.dart';

import '../datasources/customer_remote_datasource.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerRemoteDataSource _remote;

  const CustomerRepositoryImpl(this._remote);

  @override
  Future<CustomerInfo> getCustomerInfo() {
    return _remote.getCustomerInfo();
  }
}
