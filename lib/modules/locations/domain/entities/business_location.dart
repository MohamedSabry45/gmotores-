class BusinessLocation {
  final int id;
  final String name;
  final String? landmark;
  final String country;
  final String state;
  final String city;
  final String mobile;
  final double? latitude;
  final double? longitude;

  const BusinessLocation({
    required this.id,
    required this.name,
    required this.landmark,
    required this.country,
    required this.state,
    required this.city,
    required this.mobile,
    required this.latitude,
    required this.longitude,
  });
}
