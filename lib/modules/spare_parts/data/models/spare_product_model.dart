import '../../domain/entities/spare_product.dart';

class SpareProductModel extends SpareProduct {
  const SpareProductModel({
    required super.id,
    required super.name,
    required super.sku,
    required super.qtyAvailable,
    required super.defaultSellPrice,
    required super.brandId,
    required super.brandName,
    required super.categoryId,
    required super.categoryName,
    required super.subCategoryId,
    required super.subCategoryName,
    required super.compatibility,
    super.imageUrl,
  });

  factory SpareProductModel.fromJson(Map<String, dynamic> json) {
    int asInt(dynamic v) => v is int ? v : int.tryParse(v?.toString() ?? '') ?? 0;
    double asDouble(dynamic v) => double.tryParse(v?.toString() ?? '') ?? 0.0;

    final brand = json['brand'];
    final category = json['category'];
    final subCategory = json['sub_category'];

    int? firstNonZeroInt(dynamic v) {
      final x = asInt(v);
      return x == 0 ? null : x;
    }

    final brandId = brand is Map ? asInt(brand['id']) : null;
    final brandName = brand is Map ? brand['name']?.toString() : null;

    final categoryId = category is Map ? asInt(category['id']) : null;
    final categoryName = category is Map ? category['name']?.toString() : null;

    final subCategoryId = subCategory is Map
        ? asInt(subCategory['id'])
        : (firstNonZeroInt(json['sub_category_id']) ??
            firstNonZeroInt(json['sub_sub_category_id']) ??
            firstNonZeroInt(json['sub_sub_sub_category_id']));
    final subCategoryName = subCategory is Map ? subCategory['name']?.toString() : null;

    final rawCompat = json['compatibility'];
    final compatibility = rawCompat is List
        ? rawCompat
            .whereType<Map>()
            .map((e) {
              final m = Map<String, dynamic>.from(e);
              return ProductCompatibility(
                brand: m['brand']?.toString() ?? '',
                model: m['model']?.toString() ?? '',
                fromYear: m['from_year'] == null ? null : asInt(m['from_year']),
                toYear: m['to_year'] == null ? null : asInt(m['to_year']),
                label: m['label']?.toString() ?? '',
              );
            })
            .toList()
        : const <ProductCompatibility>[];

    return SpareProductModel(
      id: asInt(json['id']),
      name: json['name']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      qtyAvailable: asDouble(json['qty_available']),
      defaultSellPrice: asDouble(json['default_sell_price']),
      brandId: brand is Map ? brandId : null,
      brandName: brand is Map ? brandName : null,
      categoryId: category is Map ? categoryId : null,
      categoryName: category is Map ? categoryName : null,
      subCategoryId: subCategoryId,
      subCategoryName: subCategoryName,
      compatibility: compatibility,
      imageUrl: json['image_url']?.toString(),
    );
  }
}
