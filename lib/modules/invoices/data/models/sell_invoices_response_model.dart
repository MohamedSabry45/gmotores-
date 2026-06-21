import 'sell_invoice_model.dart';

class SellInvoicesResponseModel {
  final List<SellInvoiceModel> data;
  final Map<String, dynamic> links;
  final Map<String, dynamic> meta;

  const SellInvoicesResponseModel({
    required this.data,
    required this.links,
    required this.meta,
  });

  factory SellInvoicesResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final invoices = <SellInvoiceModel>[];

    if (rawData is List) {
      for (final item in rawData) {
        if (item is Map<String, dynamic>) {
          invoices.add(SellInvoiceModel.fromJson(item));
        }
      }
    }

    final links = (json['links'] is Map)
        ? Map<String, dynamic>.from(json['links'] as Map)
        : <String, dynamic>{};

    final meta = (json['meta'] is Map)
        ? Map<String, dynamic>.from(json['meta'] as Map)
        : <String, dynamic>{};

    return SellInvoicesResponseModel(
      data: invoices,
      links: links,
      meta: meta,
    );
  }
}
