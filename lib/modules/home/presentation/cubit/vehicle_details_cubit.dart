import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/vehicle_details_remote_datasource.dart';
import 'vehicle_details_state.dart';

class VehicleDetailsCubit extends Cubit<VehicleDetailsState> {
  VehicleDetailsCubit({required this.id}) : super(VehicleDetailsInitial());

  final int id;
  late final VehicleDetailsRemoteDataSource _remote = VehicleDetailsRemoteDataSource();

  Future<void> load() async {
    emit(VehicleDetailsLoading());
    try {
      final details = await _remote.getVehicleDetails(id: id);
      emit(VehicleDetailsSuccess(details));
    } catch (e) {
      emit(VehicleDetailsError(e.toString()));
    }
  }
}
