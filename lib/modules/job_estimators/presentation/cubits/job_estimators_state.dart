import '../../../job_estimators/domain/entities/job_estimator.dart';

abstract class JobEstimatorsState {}

class JobEstimatorsInitial extends JobEstimatorsState {}

class JobEstimatorsLoading extends JobEstimatorsState {}

class JobEstimatorsSuccess extends JobEstimatorsState {
  final List<JobEstimator> estimators;
  JobEstimatorsSuccess(this.estimators);
}

class JobEstimatorsError extends JobEstimatorsState {
  final String message;
  JobEstimatorsError(this.message);
}
