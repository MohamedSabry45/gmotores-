class ApiEndpoints {
  static const String checkPhone = '/contact/check/phone';
  static const String checkPhoneJobOrder = '/contact/check/phone/joborder';
  static const String contactStatus = '/contact/status';
  static const String saveProduct = '/contact/saveProduct';
  static const String uploadImage = '/contact/upload-image';
  static const String register = '/register';
  static const String login = '/contact/login';

  static const String customerInfo = '/connector/api/Info/customer';
  static const String branches = '/connector/api/Branshes';

  static const String aboutUs = '/connector/api/about-us';

  static const String brands = '/connector/api/brands';

  static String models({required int brandId}) {
    return '/connector/api/models/$brandId';
  }

  static String services({required int locationId}) {
    return '/connector/api/services?location_id=$locationId';
  }

  static const String customerJobOrders = '/connector/api/customer/joborder';
  static const String customerBookings = '/connector/api/customer/booking';

  static const String addBooking = '/connector/api/add/booking';

  static const String addCar = '/connector/api/add/car';

  // Job estimators list for a customer
  static String jobEstimators({required int customerId}) {
    return '/connector/api/job-estimators?customerId=$customerId';
  }

  static const String createJobEstimator = '/connector/api/job-estimators';

  // Job estimator details by id and last 4 digits of phone
  static String jobEstimatorDetails({required int id, required String phoneLast4}) {
    return '/connector/api/job-estimator-details?id=$id&phone=$phoneLast4';
  }

  static const String jobEstimatorSaveProducts = '/connector/api/saveProduct';

  static const String maintenanceNotifications = '/connector/api/maintenance-notifications';
  static const String maintenanceNotificationsMarkRead = '/connector/api/maintenance-notifications/mark-read';
  static const String maintenanceNotificationsMarkAllRead = '/connector/api/maintenance-notifications/mark-all-read';

  static const String blog = '/connector/api/blog';

  static String blogDetails({required int id}) {
    return '/connector/api/blog/$id';
  }

  static const String businessLocations = '/connector/api/booking-app-locations';

  static String businessLocationDetails({required int id}) {
    return '/connector/api/booking-app-locations/$id';
  }

  static const String customerPickupRequest = '/connector/api/add/booking-pickup';

  static const String loyaltyPoints = '/connector/api/loyalty-points';
  static const String loyaltyPointsRedeem = '/connector/api/loyalty-points/redeem';

  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String completeProfile = '/auth/complete-profile';
}
