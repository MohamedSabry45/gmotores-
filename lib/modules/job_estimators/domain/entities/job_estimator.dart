class JobEstimator {
  final int id;
  final String estimateNo;
  final int contactId;
  final String customerName;
  final int deviceId;
  final String model;
  final String brand;
  final int businessId;
  final int locationId;
  final String locationName;
  final int createdBy;
  final int serviceTypeId;
  final String estimatorStatus;
  final String? color;
  final String? plateNumber;
  final String? manufacturingYear;
  final String? vehicleDetails;
  final int sendSms;
  final String? sentToCustomerAt;
  final String? approvedAt;
  final String createdAt;
  final String updatedAt;

  const JobEstimator({
    required this.id,
    required this.estimateNo,
    required this.contactId,
    required this.customerName,
    required this.deviceId,
    required this.model,
    required this.brand,
    required this.businessId,
    required this.locationId,
    required this.locationName,
    required this.createdBy,
    required this.serviceTypeId,
    required this.estimatorStatus,
    required this.color,
    required this.plateNumber,
    required this.manufacturingYear,
    required this.vehicleDetails,
    required this.sendSms,
    required this.sentToCustomerAt,
    required this.approvedAt,
    required this.createdAt,
    required this.updatedAt,
  });
}
