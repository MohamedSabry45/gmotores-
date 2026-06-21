class SellLineModel {
  final int id;
  final int transactionId;
  final int productId;
  final int variationId;
  final String productName;
  final double quantity;
  final double unitPrice;
  final double unitPriceIncTax;
  final String note;

  const SellLineModel({
    required this.id,
    required this.transactionId,
    required this.productId,
    required this.variationId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.unitPriceIncTax,
    required this.note,
  });

  factory SellLineModel.fromJson(Map<String, dynamic> json) {
    double d(dynamic v) => double.tryParse(v?.toString() ?? '') ?? 0;

    return SellLineModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      transactionId: int.tryParse(json['transaction_id']?.toString() ?? '') ?? 0,
      productId: int.tryParse(json['product_id']?.toString() ?? '') ?? 0,
      variationId: int.tryParse(json['variation_id']?.toString() ?? '') ?? 0,
      productName: json['product_name']?.toString() ?? '',
      quantity: d(json['quantity']),
      unitPrice: d(json['unit_price']),
      unitPriceIncTax: d(json['unit_price_inc_tax']),
      note: json['sell_line_note']?.toString() ?? '',
    );
  }
}
