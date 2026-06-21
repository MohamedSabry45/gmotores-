import 'invoice_contact_model.dart';
import 'sell_line_model.dart';

class SellInvoiceModel {
  final int id;
  final int businessId;
  final int locationId;
  final String type;
  final int contactId;
  final String invoiceNo;
  final String? shippingDetails;
  final String? shippingAddress;
  final String? shippingStatus;
  final String? deliveredTo;
  final String discountType;
  final double discountAmount;
  final double totalBeforeTax;
  final double taxAmount;
  final String status;
  final String paymentStatus;
  final String transactionDate;
  final String createdAt;
  final String updatedAt;
  final String invoiceToken;
  final double finalTotal;
  final double roundOffAmount;
  final String invoiceUrl;
  final String paymentLink;
  final List<SellLineModel> sellLines;
  final InvoiceContactModel? contact;

  const SellInvoiceModel({
    required this.id,
    required this.businessId,
    required this.locationId,
    required this.type,
    required this.contactId,
    required this.invoiceNo,
    required this.shippingDetails,
    required this.shippingAddress,
    required this.shippingStatus,
    required this.deliveredTo,
    required this.discountType,
    required this.discountAmount,
    required this.totalBeforeTax,
    required this.taxAmount,
    required this.status,
    required this.paymentStatus,
    required this.transactionDate,
    required this.createdAt,
    required this.updatedAt,
    required this.invoiceToken,
    required this.finalTotal,
    required this.roundOffAmount,
    required this.invoiceUrl,
    required this.paymentLink,
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
      businessId: int.tryParse(json['business_id']?.toString() ?? '') ?? 0,
      locationId: int.tryParse(json['location_id']?.toString() ?? '') ?? 0,
      type: json['type']?.toString() ?? '',
      contactId: int.tryParse(json['contact_id']?.toString() ?? '') ?? 0,
      invoiceNo: json['invoice_no']?.toString() ?? '',
      shippingDetails: json['shipping_details']?.toString(),
      shippingAddress: json['shipping_address']?.toString(),
      shippingStatus: json['shipping_status']?.toString(),
      deliveredTo: json['delivered_to']?.toString(),
      discountType: json['discount_type']?.toString() ?? '',
      discountAmount: d(json['discount_amount']),
      totalBeforeTax: d(json['total_before_tax']),
      taxAmount: d(json['tax_amount']),
      status: json['status']?.toString() ?? '',
      paymentStatus: json['payment_status']?.toString() ?? '',
      transactionDate: json['transaction_date']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      invoiceToken: json['invoice_token']?.toString() ?? '',
      finalTotal: d(json['final_total']),
      roundOffAmount: d(json['round_off_amount']),
      invoiceUrl: json['invoice_url']?.toString() ?? '',
      paymentLink: json['payment_link']?.toString() ?? '',
      sellLines: lines,
      contact: contactJson is Map<String, dynamic> ? InvoiceContactModel.fromJson(contactJson) : null,
    );
  }
}
