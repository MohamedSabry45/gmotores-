import '../../domain/entities/customer_car.dart';

class CustomerCarModel extends CustomerCar {
  const CustomerCarModel({
    required super.id,
    required super.model,
    required super.device,
    required super.color,
    required super.carLogo,
    required super.plateNumber,
    required super.manufacturingYear,
    required super.chassisNumber,
    required super.carType,
  });

  factory CustomerCarModel.fromJson(Map<String, dynamic> json) {
    return CustomerCarModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      model: json['model']?.toString() ?? '',
      device: json['device']?.toString() ?? '',
      color: json['color']?.toString() ?? '',
      carLogo: json['car_logo']?.toString(),
      plateNumber: json['plate_number']?.toString(),
      manufacturingYear: json['manufacturing_year']?.toString() ?? '',
      chassisNumber: json['chassis_number']?.toString() ?? '',
      carType: json['car_type']?.toString() ?? '',
    );
  }
}
