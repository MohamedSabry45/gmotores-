import '../../domain/entities/job_order.dart';

class JobOrderModel extends JobOrder {
  const JobOrderModel({
    required super.id,
    required super.model,
    required super.jobSheetNo,
    required super.brand,
    required super.color,
    required super.plateNumber,
    required super.manufacturingYear,
    required super.workshop,
    required super.location,
  });

  factory JobOrderModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    return JobOrderModel(
      id: id is int ? id : int.tryParse(id?.toString() ?? '') ?? 0,
      model: json['model']?.toString() ?? '',
      jobSheetNo: json['job_sheet_no']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      color: json['color']?.toString() ?? '',
      plateNumber: json['plate_number']?.toString(),
      manufacturingYear: json['manufacturing_year']?.toString() ?? '',
      workshop: json['workshop']?.toString(),
      location: json['location']?.toString() ?? '',
    );
  }
}
