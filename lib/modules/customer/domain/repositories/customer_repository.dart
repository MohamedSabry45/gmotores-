import '../entities/customer_info.dart';

abstract class CustomerRepository {
  Future<CustomerInfo> getCustomerInfo();
}
