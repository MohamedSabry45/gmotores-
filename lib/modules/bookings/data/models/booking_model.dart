import '../../domain/entities/booking.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.jobSheetNo,
    required super.bookingStatus,
    required super.color,
    required super.plateNumber,
    required super.brand,
    required super.model,
    required super.service,
    required super.bookingNote,
    required super.bookingStart,
    required super.location,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    return BookingModel(
      id: id is int ? id : int.tryParse(id?.toString() ?? '') ?? 0,
      jobSheetNo: json['job_sheet_no']?.toString(),
      bookingStatus: json['booking_status']?.toString() ?? '',
      color: json['color']?.toString() ?? '',
      plateNumber: json['plate_number']?.toString(),
      brand: json['brand']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      service: json['service']?.toString() ?? '',
      bookingNote: json['booking_note']?.toString(),
      bookingStart: json['booking_start']?.toString() ?? '',
      location: json['location']?.toString(),
    );
  }
}
