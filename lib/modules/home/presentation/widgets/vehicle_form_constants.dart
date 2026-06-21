class VehicleFormConstants {
  static const List<String> licenseTypes = [
    'seller_owned',
    'private',
    'commercial',
  ];
  
  static const List<Map<String, String>> conditions = [
    {'value': 'new', 'ar': 'جديد', 'en': 'New'},
    {'value': 'used', 'ar': 'مستعمل', 'en': 'Used'},
  ];
  
  static const List<Map<String, String>> bodyTypes = [
    {'value': 'sedan', 'ar': 'سيدان', 'en': 'Sedan'},
    {'value': 'suv', 'ar': 'SUV', 'en': 'SUV'},
    {'value': 'coupe', 'ar': 'كوبيه', 'en': 'Coupe'},
    {'value': 'hatchback', 'ar': 'هاتشباك', 'en': 'Hatchback'},
    {'value': 'truck', 'ar': 'شاحنة', 'en': 'Truck'},
    {'value': 'van', 'ar': 'فان', 'en': 'Van'},
    {'value': 'convertible', 'ar': 'كابريوليه', 'en': 'Convertible'},
    {'value': 'wagon', 'ar': 'ستيشن', 'en': 'Wagon'},
    {'value': 'pickup', 'ar': 'بيك أب', 'en': 'Pickup'},
    {'value': 'other', 'ar': 'أخرى', 'en': 'Other'},
  ];
  
  static const List<Map<String, String>> fuelTypes = [
    {'value': 'gas', 'ar': 'بنزين', 'en': 'Gas'},
    {'value': 'diesel', 'ar': 'ديزل', 'en': 'Diesel'},
    {'value': 'electric', 'ar': 'كهرباء', 'en': 'Electric'},
    {'value': 'hybrid', 'ar': 'هايبرد', 'en': 'Hybrid'},
    {'value': 'natural_gas', 'ar': 'غاز طبيعي', 'en': 'Natural Gas'},
  ];
  
  static const List<Map<String, String>> transmissions = [
    {'value': 'automatic', 'ar': 'أوتوماتيك', 'en': 'Automatic'},
    {'value': 'manual', 'ar': 'مانوال', 'en': 'Manual'},
  ];
  
  static String getLicenseTypeLabel(String type, String languageCode) {
    switch (type) {
      case 'seller_owned':
        return languageCode == 'ar' ? 'مملوكة للبائع' : 'Seller Owned';
      case 'private':
        return languageCode == 'ar' ? 'خاص' : 'Private';
      case 'commercial':
        return languageCode == 'ar' ? 'تجاري' : 'Commercial';
      default:
        return type;
    }
  }
}
