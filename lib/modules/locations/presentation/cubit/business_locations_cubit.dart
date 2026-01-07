import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/business_locations_remote_datasource.dart';
import 'business_locations_state.dart';

class BusinessLocationsCubit extends Cubit<BusinessLocationsState> {
  BusinessLocationsCubit() : super(BusinessLocationsInitial());

  static BusinessLocationsCubit get(context) => BlocProvider.of<BusinessLocationsCubit>(context);

  late final BusinessLocationsRemoteDataSource _remote = BusinessLocationsRemoteDataSource();

  Future<void> load() async {
    emit(BusinessLocationsLoading());
    try {
      final items = await _remote.getBusinessLocations();
      emit(BusinessLocationsSuccess(items));
    } catch (e) {
      emit(BusinessLocationsError(e.toString()));
    }
  }
}
