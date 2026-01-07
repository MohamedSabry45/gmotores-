import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/service_remote_datasource.dart';
import 'service_state.dart';

class ServiceCubit extends Cubit<ServiceState> {
  ServiceCubit() : super(ServiceInitial());

  static ServiceCubit get(context) => BlocProvider.of<ServiceCubit>(context);

  late final ServiceRemoteDataSource _remote = ServiceRemoteDataSource();

  Future<void> load({required int locationId}) async {
    emit(ServiceLoading());
    try {
      final services = await _remote.getServices(locationId: locationId);
      emit(ServiceSuccess(locationId: locationId, services: services));
    } catch (e) {
      emit(ServiceError(e.toString()));
    }
  }

  void clear() {
    emit(ServiceInitial());
  }
}
