class InvoiceContactModel {
  final int id;
  final String name;
  final String mobile;

  const InvoiceContactModel({
    required this.id,
    required this.name,
    required this.mobile,
  });

  factory InvoiceContactModel.fromJson(Map<String, dynamic> json) {
    return InvoiceContactModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
    );
  }
}
