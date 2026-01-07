class Booking {
  final int id;
  final String? jobSheetNo;
  final String bookingStatus;
  final String color;
  final String? plateNumber;
  final String brand;
  final String model;
  final String service;
  final String? bookingNote;
  final String bookingStart;
  final String? location;

  const Booking({
    required this.id,
    required this.jobSheetNo,
    required this.bookingStatus,
    required this.color,
    required this.plateNumber,
    required this.brand,
    required this.model,
    required this.service,
    required this.bookingNote,
    required this.bookingStart,
    required this.location,
  });
}
