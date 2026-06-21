import '../../domain/entities/vehicle_details.dart';

class VehicleMediaModel extends VehicleMedia {
  const VehicleMediaModel({
    required super.id,
    required super.mediaType,
    required super.filePath,
    required super.isPrimary,
    required super.displayOrder,
  });

  static VehicleMediaModel fromJson(Map<String, dynamic> json) {
    return VehicleMediaModel(
      id: _asInt(json['id']),
      mediaType: _asString(json['media_type']),
      filePath: _asString(json['file_path']),
      isPrimary: _asBool(json['is_primary']),
      displayOrder: _asInt(json['display_order']),
    );
  }
}

class VehicleSellerModel extends VehicleSeller {
  const VehicleSellerModel({
    required super.id,
    required super.name,
    required super.mobile,
    required super.email,
    required super.type,
  });

  static VehicleSellerModel fromJson(Map<String, dynamic> json) {
    return VehicleSellerModel(
      id: _asInt(json['id']),
      name: _asString(json['name']),
      mobile: _asString(json['mobile']),
      email: (json['email']?.toString() ?? '').trim().isEmpty ? null : json['email']?.toString(),
      type: _asString(json['type']),
    );
  }
}

class VehicleDetailsModel extends VehicleDetails {
  const VehicleDetailsModel({
    required super.id,
    required super.make,
    required super.modelName,
    required super.year,
    required super.trimLevel,
    required super.bodyType,
    required super.color,
    required super.mileageKm,
    required super.engineCapacityCc,
    required super.cylinderCount,
    required super.fuelType,
    required super.transmission,
    required super.condition,
    required super.factoryPaint,
    required super.importedSpecs,
    required super.listingPrice,
    required super.minPrice,
    required super.currency,
    required super.description,
    required super.conditionNotes,
    required super.locationCity,
    required super.locationArea,
    required super.viewCount,
    required super.favoritesCount,
    required super.inquiriesCount,
    required super.isPremium,
    required super.isFeatured,
    required super.isFavorited,
    required super.media,
    required super.seller,
  });

  static VehicleDetailsModel fromJson(
    Map<String, dynamic> json, {
    required String baseUrl,
  }) {
    String? normalizeImageUrl(String? filePath) {
      final input = (filePath ?? '').trim();
      if (input.isEmpty) return null;
      if (input.startsWith('http://') || input.startsWith('https://')) return input;

      final normalizedBase = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
      final normalizedPath = input.startsWith('/') ? input.substring(1) : input;
      return '$normalizedBase/$normalizedPath';
    }

    final mediaList = (json['media'] is List) ? (json['media'] as List) : const <dynamic>[];
    final media = mediaList.whereType<Map>().map((e) {
      final map = Map<String, dynamic>.from(e);
      map['file_path'] = normalizeImageUrl(map['file_path']?.toString());
      return VehicleMediaModel.fromJson(map);
    }).toList();

    media.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    final seller = (json['seller'] is Map)
        ? VehicleSellerModel.fromJson(Map<String, dynamic>.from(json['seller'] as Map))
        : null;

    return VehicleDetailsModel(
      id: _asInt(json['id']),
      make: _asString(json['make']),
      modelName: _asString(json['model_name']),
      year: _asInt(json['year']),
      trimLevel: _asString(json['trim_level']),
      bodyType: _asString(json['body_type']),
      color: _asString(json['color']),
      mileageKm: _asInt(json['mileage_km']),
      engineCapacityCc: _asInt(json['engine_capacity_cc']),
      cylinderCount: _asInt(json['cylinder_count']),
      fuelType: _asString(json['fuel_type']),
      transmission: _asString(json['transmission']),
      condition: _asString(json['condition']),
      factoryPaint: _asBool(json['factory_paint']),
      importedSpecs: _asBool(json['imported_specs']),
      listingPrice: _asString(json['listing_price']),
      minPrice: _asString(json['min_price']),
      currency: _asString(json['currency']),
      description: _asString(json['description']),
      conditionNotes: _asString(json['condition_notes']),
      locationCity: _asString(json['location_city']),
      locationArea: _asString(json['location_area']),
      viewCount: _asInt(json['view_count']),
      favoritesCount: _asInt(json['favorites_count']),
      inquiriesCount: _asInt(json['inquiries_count']),
      isPremium: _asBool(json['is_premium']),
      isFeatured: _asBool(json['is_featured']),
      isFavorited: _asBool(json['is_favorited']),
      media: media,
      seller: seller,
    );
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String _asString(dynamic value) {
  return (value?.toString() ?? '').trim();
}

bool _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  final s = (value?.toString() ?? '').trim().toLowerCase();
  return s == 'true' || s == '1' || s == 'yes';
}
