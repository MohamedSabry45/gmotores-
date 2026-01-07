import '../../domain/entities/customer_info.dart';
import 'customer_car_model.dart';

class CustomerInfoModel extends CustomerInfo {
  const CustomerInfoModel({
    required super.id,
    required super.name,
    required super.mobile,
    required super.cars,
  });

  factory CustomerInfoModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map?)?.cast<String, dynamic>() ?? const <String, dynamic>{};
    final carsJson = data['cars'];

    final cars = <CustomerCarModel>[];
    if (carsJson is List) {
      for (final item in carsJson) {
        if (item is Map<String, dynamic>) {
          cars.add(CustomerCarModel.fromJson(item));
        }
      }
    }

    return CustomerInfoModel(
      id: int.tryParse(data['id']?.toString() ?? '') ?? 0,
      name: data['name']?.toString() ?? '',
      mobile: data['mobile']?.toString() ?? '',
      cars: cars,
    );
  }
}
