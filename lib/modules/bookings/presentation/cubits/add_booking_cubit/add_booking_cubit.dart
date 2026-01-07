import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/add_booking_remote_datasource.dart';
import 'add_booking_state.dart';

class AddBookingCubit extends Cubit<AddBookingState> {
  AddBookingCubit() : super(AddBookingInitial());

  static AddBookingCubit get(context) => BlocProvider.of<AddBookingCubit>(context);

  late final AddBookingRemoteDataSource _remote = AddBookingRemoteDataSource();

  Future<void> addBooking({
    required String bookingStart,
    required int locationId,
    required String bookingNote,
    required int serviceId,
    required int deviceId,
  }) async {
    emit(AddBookingLoading());
    try {
      final msg = await _remote.addBooking(
        bookingStart: bookingStart,
        locationId: locationId,
        bookingNote: bookingNote,
        serviceId: serviceId,
        deviceId: deviceId,
      );
      emit(AddBookingSuccess(msg));
    } catch (e) {
      emit(AddBookingError(e.toString()));
    }
  }
}
