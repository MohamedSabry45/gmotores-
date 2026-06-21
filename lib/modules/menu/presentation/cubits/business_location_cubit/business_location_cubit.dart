import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reservation_workshop/modules/menu/data/datasources/business_location_remote_datasource.dart';
import 'package:reservation_workshop/modules/menu/data/models/business_location_model.dart';

import 'business_location_state.dart';

class BusinessLocationCubit extends Cubit<BusinessLocationState> {
  BusinessLocationCubit() : super(BusinessLocationInitial());

  static BusinessLocationCubit get(context) => BlocProvider.of<BusinessLocationCubit>(context);

  final BusinessLocationRemoteDataSource _remote = BusinessLocationRemoteDataSource();
  BusinessLocation? _cachedLocation;

  BusinessLocation? get cachedLocation => _cachedLocation;

  Future<void> fetchBusinessLocation() async {
    if (_cachedLocation != null) {
      emit(BusinessLocationSuccess(_cachedLocation!));
      return;
    }

    emit(BusinessLocationLoading());
    try {
      final location = await _remote.getBusinessLocation();
      _cachedLocation = location;
      emit(BusinessLocationSuccess(location));
    } catch (e) {
      emit(BusinessLocationError(e.toString()));
    }
  }

  void clearCache() {
    _cachedLocation = null;
  }
}
