import 'package:reservation_workshop/modules/spare_parts/domain/entities/spare_product.dart';

class SpareCartItem {
  final SpareProduct product;
  final int variationId;
  final int quantity;
  final double unitPrice;
  final double discountAmount;
  final String discountType;

  const SpareCartItem({
    required this.product,
    required this.variationId,
    required this.quantity,
    required this.unitPrice,
    required this.discountAmount,
    required this.discountType,
  });

  SpareCartItem copyWith({
    SpareProduct? product,
    int? variationId,
    int? quantity,
    double? unitPrice,
    double? discountAmount,
    String? discountType,
  }) {
    return SpareCartItem(
      product: product ?? this.product,
      variationId: variationId ?? this.variationId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      discountAmount: discountAmount ?? this.discountAmount,
      discountType: discountType ?? this.discountType,
    );
  }

  double get lineTotal {
    final raw = unitPrice * quantity;
    if (discountAmount <= 0) return raw;
    if (discountType == 'percentage') {
      return raw - (raw * (discountAmount / 100.0));
    }
    return raw - discountAmount;
  }
}
