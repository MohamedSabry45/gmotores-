import 'invoice_contact_model.dart';
import 'sell_line_model.dart';

class SellInvoiceModel {
  final int id;
  final int contactId;
  final String invoiceNo;
  final String status;
  final String paymentStatus;
  final String transactionDate;
  final double finalTotal;
  final String invoiceUrl;
  final List<SellLineModel> sellLines;
  final InvoiceContactModel? contact;

  const SellInvoiceModel({
    required this.id,
    required this.contactId,
    required this.invoiceNo,
    required this.status,
    required this.paymentStatus,
    required this.transactionDate,
    required this.finalTotal,
    required this.invoiceUrl,
    required this.sellLines,
    required this.contact,
  });

  factory SellInvoiceModel.fromJson(Map<String, dynamic> json) {
    double d(dynamic v) => double.tryParse(v?.toString() ?? '') ?? 0;

    final sellLinesJson = json['sell_lines'];
    final lines = <SellLineModel>[];
    if (sellLinesJson is List) {
      for (final item in sellLinesJson) {
        if (item is Map<String, dynamic>) {
          lines.add(SellLineModel.fromJson(item));
        }
      }
    }

    final contactJson = json['contact'];

    return SellInvoiceModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      contactId: int.tryParse(json['contact_id']?.toString() ?? '') ?? 0,
      invoiceNo: json['invoice_no']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      paymentStatus: json['payment_status']?.toString() ?? '',
      transactionDate: json['transaction_date']?.toString() ?? '',
      finalTotal: d(json['final_total']),
      invoiceUrl: json['invoice_url']?.toString() ?? '',
      sellLines: lines,
      contact: contactJson is Map<String, dynamic> ? InvoiceContactModel.fromJson(contactJson) : null,
    );
  }
}
