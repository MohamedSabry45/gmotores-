class JobOrder {
  final int id;
  final String model;
  final String jobSheetNo;
  final String brand;
  final String color;
  final String? plateNumber;
  final String manufacturingYear;
  final String? workshop;
  final String location;

  const JobOrder({
    required this.id,
    required this.model,
    required this.jobSheetNo,
    required this.brand,
    required this.color,
    required this.plateNumber,
    required this.manufacturingYear,
    required this.workshop,
    required this.location,
  });
}
