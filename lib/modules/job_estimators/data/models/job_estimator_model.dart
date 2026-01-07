import '../../domain/entities/job_estimator.dart';

class JobEstimatorModel extends JobEstimator {
  const JobEstimatorModel({
    required super.id,
    required super.estimateNo,
    required super.contactId,
    required super.customerName,
    required super.deviceId,
    required super.model,
    required super.brand,
    required super.businessId,
    required super.locationId,
    required super.locationName,
    required super.createdBy,
    required super.serviceTypeId,
    required super.estimatorStatus,
    required super.color,
    required super.plateNumber,
    required super.manufacturingYear,
    required super.vehicleDetails,
    required super.sendSms,
    required super.sentToCustomerAt,
    required super.approvedAt,
    required super.createdAt,
    required super.updatedAt,
  });

  factory JobEstimatorModel.fromJson(Map<String, dynamic> json) {
    return JobEstimatorModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      estimateNo: json['estimate_no']?.toString() ?? '-',
      contactId: int.tryParse(json['contact_id']?.toString() ?? '') ?? 0,
      customerName: json['customer_name']?.toString() ?? '-',
      deviceId: int.tryParse(json['device_id']?.toString() ?? '') ?? 0,
      model: json['model']?.toString() ?? '-',
      brand: json['brand']?.toString() ?? '-',
      businessId: int.tryParse(json['business_id']?.toString() ?? '') ?? 0,
      locationId: int.tryParse(json['location_id']?.toString() ?? '') ?? 0,
      locationName: json['location_name']?.toString() ?? '-',
      createdBy: int.tryParse(json['created_by']?.toString() ?? '') ?? 0,
      serviceTypeId: int.tryParse(json['service_type_id']?.toString() ?? '') ?? 0,
      estimatorStatus: json['estimator_status']?.toString() ?? '-',
      color: json['color']?.toString(),
      plateNumber: json['plate_number']?.toString(),
      manufacturingYear: json['manufacturing_year']?.toString(),
      vehicleDetails: json['vehicle_details']?.toString(),
      sendSms: int.tryParse(json['send_sms']?.toString() ?? '') ?? 0,
      sentToCustomerAt: json['sent_to_customer_at']?.toString(),
      approvedAt: json['approved_at']?.toString(),
      createdAt: json['created_at']?.toString() ?? '-',
      updatedAt: json['updated_at']?.toString() ?? '-',
    );
  }
}
