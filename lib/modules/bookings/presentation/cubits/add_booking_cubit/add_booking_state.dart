abstract class AddBookingState {}

class AddBookingInitial extends AddBookingState {}

class AddBookingLoading extends AddBookingState {}

class AddBookingSuccess extends AddBookingState {
  final String message;

  AddBookingSuccess(this.message);
}

class AddBookingError extends AddBookingState {
  final String message;

  AddBookingError(this.message);
}

class AddBookingGuestNotAllowed extends AddBookingState {}
