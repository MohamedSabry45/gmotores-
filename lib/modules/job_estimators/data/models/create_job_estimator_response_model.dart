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
    final dynamic data = json['data'];
    final Map<String, dynamic> dataMap = data is Map ? Map<String, dynamic>.from(data) : const <String, dynamic>{};
    return CreateJobEstimatorResponseModel(
      success: json['success'] == true,
      id: int.tryParse(dataMap['id']?.toString() ?? '') ?? 0,
      estimateNo: dataMap['estimate_no']?.toString() ?? '-',
    );
  }
}
