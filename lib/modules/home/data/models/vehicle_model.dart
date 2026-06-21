import '../../domain/entities/vehicle.dart';

class VehicleModel extends Vehicle {
  const VehicleModel({
    required super.id,
    required super.make,
    required super.modelName,
    required super.year,
    required super.trimLevel,
    required super.bodyType,
    required super.color,
    required super.mileageKm,
    required super.listingPrice,
    required super.currency,
    required super.locationCity,
    required super.isPremium,
    required super.isFeatured,
    required super.viewCount,
    required super.favoritesCount,
    required super.inquiriesCount,
    required super.primaryImageUrl,
  });

  static VehicleModel fromJson(
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

    final primaryImage = (json['primary_image'] is Map) ? (json['primary_image'] as Map) : null;

    return VehicleModel(
      id: _asInt(json['id']),
      make: _asString(json['make']),
      modelName: _asString(json['model_name']),
      year: _asInt(json['year']),
      trimLevel: _asString(json['trim_level']),
      bodyType: _asString(json['body_type']),
      color: _asString(json['color']),
      mileageKm: _asInt(json['mileage_km']),
      listingPrice: _asString(json['listing_price']),
      currency: _asString(json['currency']),
      locationCity: _asString(json['location_city']),
      isPremium: _asBool(json['is_premium']),
      isFeatured: _asBool(json['is_featured']),
      viewCount: _asInt(json['view_count']),
      favoritesCount: _asInt(json['favorites_count']),
      inquiriesCount: _asInt(json['inquiries_count']),
      primaryImageUrl: normalizeImageUrl(primaryImage?['file_path']?.toString()),
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _asString(dynamic value) {
    return (value?.toString() ?? '').trim();
  }

  static bool _asBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    final s = (value?.toString() ?? '').trim().toLowerCase();
    return s == 'true' || s == '1' || s == 'yes';
  }
}
