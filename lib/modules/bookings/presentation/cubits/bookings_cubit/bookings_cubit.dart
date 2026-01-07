import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/bookings_remote_datasource.dart';
import 'bookings_state.dart';

class BookingsCubit extends Cubit<BookingsState> {
  BookingsCubit() : super(BookingsInitial());

  static BookingsCubit get(context) => BlocProvider.of<BookingsCubit>(context);

  late final BookingsRemoteDataSource _remote = BookingsRemoteDataSource();

  Future<void> load() async {
    emit(BookingsLoading());
    try {
      final bookings = await _remote.getCustomerBookings();
      emit(BookingsSuccess(bookings));
    } catch (e) {
      emit(BookingsError(e.toString()));
    }
  }
}
