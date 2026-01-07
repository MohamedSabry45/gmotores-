import '../../../domain/entities/booking.dart';

abstract class BookingsState {}

class BookingsInitial extends BookingsState {}

class BookingsLoading extends BookingsState {}

class BookingsSuccess extends BookingsState {
  final List<Booking> bookings;

  BookingsSuccess(this.bookings);
}

class BookingsError extends BookingsState {
  final String message;

  BookingsError(this.message);
}
