import '../../domain/entities/pickup_request.dart';

class PickupRequestModel extends PickupRequest {
  const PickupRequestModel({
    required super.deviceId,
    required super.locationId,
    required super.serviceId,
    required super.bookingStart,
    required super.pickupLatitude,
    required super.pickupLongitude,
    required super.bookingNote,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'device_id': deviceId,
      'location_id': locationId,
      'service_id': serviceId,
      'booking_start': bookingStart,
      'pickup_latitude': pickupLatitude,
      'pickup_longitude': pickupLongitude,
      if (bookingNote != null && bookingNote!.trim().isNotEmpty) 'booking_note': bookingNote!.trim(),
    };
  }
}
