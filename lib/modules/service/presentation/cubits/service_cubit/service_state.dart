import '../../../domain/entities/service.dart';

abstract class ServiceState {}

class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

class ServiceSuccess extends ServiceState {
  final int locationId;
  final List<Service> services;

  ServiceSuccess({required this.locationId, required this.services});
}

class ServiceError extends ServiceState {
  final String message;

  ServiceError(this.message);
}
