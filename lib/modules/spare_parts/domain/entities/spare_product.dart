class SpareProduct {
  final int id;
  final String name;
  final String sku;
  final double qtyAvailable;
  final double defaultSellPrice;

  final int? brandId;
  final String? brandName;

  final int? categoryId;
  final String? categoryName;

  final int? subCategoryId;
  final String? subCategoryName;

  final List<ProductCompatibility> compatibility;
  final String? imageUrl;

  const SpareProduct({
    required this.id,
    required this.name,
    required this.sku,
    required this.qtyAvailable,
    required this.defaultSellPrice,
    required this.brandId,
    required this.brandName,
    required this.categoryId,
    required this.categoryName,
    required this.subCategoryId,
    required this.subCategoryName,
    required this.compatibility,
    this.imageUrl,
  });
}

class ProductCompatibility {
  final String brand;
  final String model;
  final int? fromYear;
  final int? toYear;
  final String label;

  const ProductCompatibility({
    required this.brand,
    required this.model,
    required this.fromYear,
    required this.toYear,
    required this.label,
  });
}
