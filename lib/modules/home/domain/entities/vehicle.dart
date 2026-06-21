class Vehicle {
  final int id;
  final String make;
  final String modelName;
  final int year;
  final String trimLevel;
  final String bodyType;
  final String color;
  final int mileageKm;
  final String listingPrice;
  final String currency;
  final String locationCity;
  final bool isPremium;
  final bool isFeatured;
  final int viewCount;
  final int favoritesCount;
  final int inquiriesCount;
  final String? primaryImageUrl;

  const Vehicle({
    required this.id,
    required this.make,
    required this.modelName,
    required this.year,
    required this.trimLevel,
    required this.bodyType,
    required this.color,
    required this.mileageKm,
    required this.listingPrice,
    required this.currency,
    required this.locationCity,
    required this.isPremium,
    required this.isFeatured,
    required this.viewCount,
    required this.favoritesCount,
    required this.inquiriesCount,
    required this.primaryImageUrl,
  });
}
