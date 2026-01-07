import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reservation_workshop/modules/branch/data/datasources/branch_remote_datasource.dart';
import 'package:reservation_workshop/modules/branch/data/models/branch_model.dart';
import 'package:reservation_workshop/modules/customer/presentation/cubits/customer_info_cubit/customer_info_cubit.dart';
import 'package:reservation_workshop/modules/customer/presentation/cubits/customer_info_cubit/customer_info_state.dart';
import 'package:reservation_workshop/modules/service/data/datasources/service_remote_datasource.dart';

import '../../data/datasources/rescue_remote_datasource.dart';
import '../../data/models/pickup_request_model.dart';
import 'rescue_state.dart';

class RescueCubit extends Cubit<RescueState> {
  RescueCubit() : super(RescueInitial());

  late final RescueRemoteDataSource _remote = RescueRemoteDataSource();
  late final BranchRemoteDataSource _branchRemote = BranchRemoteDataSource();
  late final ServiceRemoteDataSource _serviceRemote = ServiceRemoteDataSource();

  Future<void> load({required CustomerInfoCubit customerInfoCubit}) async {
    emit(RescueLoading());
    try {
      if (customerInfoCubit.state is! CustomerInfoSuccess) {
        await customerInfoCubit.load();
      }

      final customerState = customerInfoCubit.state;
      if (customerState is! CustomerInfoSuccess) {
        throw Exception('Failed to load customer info');
      }

      final cars = customerState.info.cars;
      final branches = await _branchRemote.getBranches();

      emit(RescueLoaded(
        cars: cars,
        branches: branches,
        services: const [],
        isSubmitting: false,
      ));
    } catch (e) {
      emit(RescueError(e.toString()));
    }
  }

  Future<void> loadServices({required int locationId}) async {
    final current = state;
    if (current is! RescueLoaded) return;

    try {
      final services = await _serviceRemote.getServices(locationId: locationId);
      emit(RescueLoaded(
        cars: current.cars,
        branches: current.branches,
        services: services,
        isSubmitting: current.isSubmitting,
      ));
    } catch (e) {
      emit(RescueError(e.toString()));
    }
  }

  Future<void> submit({required PickupRequestModel request}) async {
    final current = state;
    if (current is! RescueLoaded) return;

    emit(RescueLoaded(
      cars: current.cars,
      branches: current.branches,
      services: current.services,
      isSubmitting: true,
    ));

    try {
      final res = await _remote.customerPickupRequest(request: request);
      if (res.success) {
        emit(RescueSuccess(res.message.isEmpty ? 'تم إرسال طلب الإنقاذ بنجاح' : res.message));
      } else {
        emit(RescueError(res.message.isEmpty ? 'تعذر إرسال الطلب' : res.message));
      }
    } catch (e) {
      emit(RescueError(e.toString()));
    }
  }
}
