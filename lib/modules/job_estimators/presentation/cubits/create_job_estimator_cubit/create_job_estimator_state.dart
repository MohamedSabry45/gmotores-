abstract class CreateJobEstimatorState {}

class CreateJobEstimatorInitial extends CreateJobEstimatorState {}

class CreateJobEstimatorLoading extends CreateJobEstimatorState {}

class CreateJobEstimatorSuccess extends CreateJobEstimatorState {
  final int id;
  final String estimateNo;

  CreateJobEstimatorSuccess({
    required this.id,
    required this.estimateNo,
  });
}

class CreateJobEstimatorError extends CreateJobEstimatorState {
  final String message;

  CreateJobEstimatorError(this.message);
}
