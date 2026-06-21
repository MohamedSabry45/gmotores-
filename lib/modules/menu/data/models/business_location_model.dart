class BusinessLocation {
  final int id;
  final int businessId;
  final String locationId;
  final String name;
  final String? landmark;
  final String? country;
  final String? state;
  final String? city;
  final String? zipCode;
  final String? mobile;
  final String? email;
  final String? website;
  final String? customField1; // Instagram
  final String? customField2; // Facebook
  final String? customField3; // Share link
  final String? customField4;
  final int? isActive;
  final String? createdAt;
  final String? updatedAt;

  BusinessLocation({
    required this.id,
    required this.businessId,
    required this.locationId,
    required this.name,
    this.landmark,
    this.country,
    this.state,
    this.city,
    this.zipCode,
    this.mobile,
    this.email,
    this.website,
    this.customField1,
    this.customField2,
    this.customField3,
    this.customField4,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory BusinessLocation.fromJson(Map<String, dynamic> json) {
    return BusinessLocation(
      id: json['id'] ?? 0,
      businessId: json['business_id'] ?? 0,
      locationId: json['location_id'] ?? '',
      name: json['name'] ?? '',
      landmark: json['landmark']?.toString(),
      country: json['country']?.toString(),
      state: json['state']?.toString(),
      city: json['city']?.toString(),
      zipCode: json['zip_code']?.toString(),
      mobile: json['mobile']?.toString(),
      email: json['email']?.toString(),
      website: json['website']?.toString(),
      customField1: json['custom_field1']?.toString(),
      customField2: json['custom_field2']?.toString(),
      customField3: json['custom_field3']?.toString(),
      customField4: json['custom_field4']?.toString(),
      isActive: json['is_active'],
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_id': businessId,
      'location_id': locationId,
      'name': name,
      'landmark': landmark,
      'country': country,
      'state': state,
      'city': city,
      'zip_code': zipCode,
      'mobile': mobile,
      'email': email,
      'website': website,
      'custom_field1': customField1,
      'custom_field2': customField2,
      'custom_field3': customField3,
      'custom_field4': customField4,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
