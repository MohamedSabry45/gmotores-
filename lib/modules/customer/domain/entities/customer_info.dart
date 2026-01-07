import 'customer_car.dart';

class CustomerInfo {
  final int id;
  final String name;
  final String mobile;
  final List<CustomerCar> cars;

  const CustomerInfo({
    required this.id,
    required this.name,
    required this.mobile,
    required this.cars,
  });
}
