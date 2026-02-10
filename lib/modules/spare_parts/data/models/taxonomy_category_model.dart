import '../../domain/entities/taxonomy_category.dart';

class TaxonomyCategoryModel extends TaxonomyCategory {
  const TaxonomyCategoryModel({
    required super.id,
    required super.name,
    required super.parentId,
    required super.categoryType,
    required super.subCategories,
  });

  factory TaxonomyCategoryModel.fromJson(Map<String, dynamic> json) {
    int asInt(dynamic v) => v is int ? v : int.tryParse(v?.toString() ?? '') ?? 0;

    final rawSubs = json['sub_categories'];
    final subs = rawSubs is List
        ? rawSubs
            .whereType<Map>()
            .map((e) => TaxonomyCategoryModel.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : const <TaxonomyCategoryModel>[];

    return TaxonomyCategoryModel(
      id: asInt(json['id']),
      name: json['name']?.toString() ?? '',
      parentId: asInt(json['parent_id']),
      categoryType: json['category_type']?.toString() ?? '',
      subCategories: subs,
    );
  }
}
