import '../../domain/entities/business_location.dart';

class BusinessLocationModel extends BusinessLocation {
  const BusinessLocationModel({
    required super.id,
    required super.name,
    required super.landmark,
    required super.country,
    required super.state,
    required super.city,
    required super.mobile,
    required super.latitude,
    required super.longitude,
  });

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  factory BusinessLocationModel.fromJson(Map<String, dynamic> json) {
    return BusinessLocationModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      landmark: json['landmark']?.toString(),
      country: json['country']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
    );
  }
}
