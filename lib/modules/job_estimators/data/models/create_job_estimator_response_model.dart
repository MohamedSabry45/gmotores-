class CreateJobEstimatorResponseModel {
  final bool success;
  final int id;
  final String estimateNo;

  const CreateJobEstimatorResponseModel({
    required this.success,
    required this.id,
    required this.estimateNo,
  });

  factory CreateJobEstimatorResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateJobEstimatorResponseModel(
      success: json['success'] == true,
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      estimateNo: json['estimate_no']?.toString() ?? '-',
    );
  }
}
