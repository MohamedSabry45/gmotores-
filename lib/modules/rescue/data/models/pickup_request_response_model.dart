class PickupRequestResponseModel {
  final bool success;
  final String message;

  const PickupRequestResponseModel({required this.success, required this.message});

  factory PickupRequestResponseModel.fromJson(Map<String, dynamic> json) {
    return PickupRequestResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
    );
  }
}
