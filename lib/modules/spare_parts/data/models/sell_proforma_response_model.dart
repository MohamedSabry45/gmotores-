class SellProformaResponseModel {
  final int id;
  final String invoiceNo;
  final String invoiceUrl;
  final double finalTotal;
  final String status;
  final String transactionDate;

  const SellProformaResponseModel({
    required this.id,
    required this.invoiceNo,
    required this.invoiceUrl,
    required this.finalTotal,
    required this.status,
    required this.transactionDate,
  });

  factory SellProformaResponseModel.fromJson(Map<String, dynamic> json) {
    double d(dynamic v) => double.tryParse(v?.toString() ?? '') ?? 0;

    return SellProformaResponseModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      invoiceNo: json['invoice_no']?.toString() ?? '',
      invoiceUrl: json['invoice_url']?.toString() ?? '',
      finalTotal: d(json['final_total']),
      status: json['status']?.toString() ?? '',
      transactionDate: json['transaction_date']?.toString() ?? '',
    );
  }
}
