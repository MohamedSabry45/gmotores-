import '../../../domain/entities/job_order.dart';

abstract class JobOrdersState {}

class JobOrdersInitial extends JobOrdersState {}

class JobOrdersLoading extends JobOrdersState {}

class JobOrdersSuccess extends JobOrdersState {
  final List<JobOrder> orders;

  JobOrdersSuccess(this.orders);
}

class JobOrdersError extends JobOrdersState {
  final String message;

  JobOrdersError(this.message);
}
