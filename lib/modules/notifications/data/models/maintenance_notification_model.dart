class MaintenanceNotificationPayload {
  MaintenanceNotificationPayload({
    required this.noteId,
    required this.jobSheetId,
    required this.jobSheetNo,
    required this.action,
    this.productId,
    this.quantity,
    this.price,
  });

  final int? noteId;
  final int? jobSheetId;
  final String? jobSheetNo;
  final String? action;
  final int? productId;
  final int? quantity;
  final String? price;

  factory MaintenanceNotificationPayload.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    return MaintenanceNotificationPayload(
      noteId: toInt(json['note_id']),
      jobSheetId: toInt(json['job_sheet_id']),
      jobSheetNo: json['job_sheet_no']?.toString(),
      action: json['action']?.toString(),
      productId: toInt(json['product_id']),
      quantity: toInt(json['quantity']),
      price: json['price']?.toString(),
    );
  }
}

class MaintenanceNotificationModel {
  MaintenanceNotificationModel({
    required this.id,
    required this.type,
    required this.data,
    required this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String type;
  final MaintenanceNotificationPayload? data;
  final String? readAt;
  final String? createdAt;
  final String? updatedAt;

  bool get isRead => readAt != null && readAt!.trim().isNotEmpty;

  factory MaintenanceNotificationModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceNotificationModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      data: (json['data'] is Map) ? MaintenanceNotificationPayload.fromJson(Map<String, dynamic>.from(json['data'] as Map)) : null,
      readAt: json['read_at']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}
