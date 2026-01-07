import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/job_orders_remote_datasource.dart';
import 'job_orders_state.dart';

class JobOrdersCubit extends Cubit<JobOrdersState> {
  JobOrdersCubit() : super(JobOrdersInitial());

  static JobOrdersCubit get(context) => BlocProvider.of<JobOrdersCubit>(context);

  late final JobOrdersRemoteDataSource _remote = JobOrdersRemoteDataSource();

  Future<void> load() async {
    emit(JobOrdersLoading());
    try {
      final orders = await _remote.getCustomerJobOrders();
      emit(JobOrdersSuccess(orders));
    } catch (e) {
      emit(JobOrdersError(e.toString()));
    }
  }
}
