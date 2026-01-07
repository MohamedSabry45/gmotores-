import 'package:reservation_workshop/modules/main/presentation/widgets/notification_card.dart';

class BookingDetailsArgs {
  final NotificationCardModel model;
  final String bookingStart;
  final int locationId;
  final int serviceId;
  final int deviceId;
  final String bookingNote;

  const BookingDetailsArgs({
    required this.model,
    required this.bookingStart,
    required this.locationId,
    required this.serviceId,
    required this.deviceId,
    required this.bookingNote,
  });
}
