import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/job_estimators_remote_datasource.dart';
import '../../data/models/job_estimator_model.dart';
import 'job_estimators_state.dart';

class JobEstimatorsCubit extends Cubit<JobEstimatorsState> {
  JobEstimatorsCubit() : super(JobEstimatorsInitial());

  static JobEstimatorsCubit of(context) => BlocProvider.of<JobEstimatorsCubit>(context);

  final JobEstimatorsRemoteDataSource _remote = JobEstimatorsRemoteDataSource();

  Future<void> load({required int customerId}) async {
    emit(JobEstimatorsLoading());
    try {
      final List<JobEstimatorModel> list = await _remote.getJobEstimators(customerId: customerId);
      emit(JobEstimatorsSuccess(list));
    } catch (e) {
      emit(JobEstimatorsError(e.toString()));
    }
  }
}
