class CustomerCar {
  final int id;
  final String model;
  final String device;
  final String color;
  final String? carLogo;
  final String? plateNumber;
  final String manufacturingYear;
  final String chassisNumber;
  final String carType;

  const CustomerCar({
    required this.id,
    required this.model,
    required this.device,
    required this.color,
    required this.carLogo,
    required this.plateNumber,
    required this.manufacturingYear,
    required this.chassisNumber,
    required this.carType,
  });
}
