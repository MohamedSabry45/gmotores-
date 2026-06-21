class TaxonomyCategory {
  final int id;
  final String name;
  final int parentId;
  final String categoryType;
  final List<TaxonomyCategory> subCategories;
  final String? logo;

  const TaxonomyCategory({
    required this.id,
    required this.name,
    required this.parentId,
    required this.categoryType,
    required this.subCategories,
    this.logo,
  });
}
