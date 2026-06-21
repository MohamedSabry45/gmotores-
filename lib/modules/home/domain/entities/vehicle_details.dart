class VehicleMedia {
  final int id;
  final String mediaType;
  final String filePath;
  final bool isPrimary;
  final int displayOrder;

  const VehicleMedia({
    required this.id,
    required this.mediaType,
    required this.filePath,
    required this.isPrimary,
    required this.displayOrder,
  });
}

class VehicleSeller {
  final int id;
  final String name;
  final String mobile;
  final String? email;
  final String type;

  const VehicleSeller({
    required this.id,
    required this.name,
    required this.mobile,
    required this.email,
    required this.type,
  });
}

class VehicleDetails {
  final int id;
  final String make;
  final String modelName;
  final int year;
  final String trimLevel;
  final String bodyType;
  final String color;
  final int mileageKm;
  final int engineCapacityCc;
  final int cylinderCount;
  final String fuelType;
  final String transmission;
  final String condition;
  final bool factoryPaint;
  final bool importedSpecs;
  final String listingPrice;
  final String minPrice;
  final String currency;
  final String description;
  final String conditionNotes;
  final String locationCity;
  final String locationArea;
  final int viewCount;
  final int favoritesCount;
  final int inquiriesCount;
  final bool isPremium;
  final bool isFeatured;
  final bool isFavorited;
  final List<VehicleMedia> media;
  final VehicleSeller? seller;

  const VehicleDetails({
    required this.id,
    required this.make,
    required this.modelName,
    required this.year,
    required this.trimLevel,
    required this.bodyType,
    required this.color,
    required this.mileageKm,
    required this.engineCapacityCc,
    required this.cylinderCount,
    required this.fuelType,
    required this.transmission,
    required this.condition,
    required this.factoryPaint,
    required this.importedSpecs,
    required this.listingPrice,
    required this.minPrice,
    required this.currency,
    required this.description,
    required this.conditionNotes,
    required this.locationCity,
    required this.locationArea,
    required this.viewCount,
    required this.favoritesCount,
    required this.inquiriesCount,
    required this.isPremium,
    required this.isFeatured,
    required this.isFavorited,
    required this.media,
    required this.seller,
  });

  VehicleMedia? get primaryMedia {
    for (final m in media) {
      if (m.isPrimary) return m;
    }
    return media.isEmpty ? null : media.first;
  }
}
