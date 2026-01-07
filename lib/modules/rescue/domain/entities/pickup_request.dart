class PickupRequest {
  final int deviceId;
  final int locationId;
  final int serviceId;
  final String bookingStart;
  final double pickupLatitude;
  final double pickupLongitude;
  final String? bookingNote;

  const PickupRequest({
    required this.deviceId,
    required this.locationId,
    required this.serviceId,
    required this.bookingStart,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.bookingNote,
  });
}
