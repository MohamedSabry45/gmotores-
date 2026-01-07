import 'package:reservation_workshop/modules/branch/domain/entities/branch.dart';
import 'package:reservation_workshop/modules/customer/domain/entities/customer_car.dart';
import 'package:reservation_workshop/modules/service/domain/entities/service.dart';

abstract class RescueState {}

class RescueInitial extends RescueState {}

class RescueLoading extends RescueState {}

class RescueLoaded extends RescueState {
  final List<CustomerCar> cars;
  final List<Branch> branches;
  final List<Service> services;
  final bool isSubmitting;

  RescueLoaded({
    required this.cars,
    required this.branches,
    required this.services,
    required this.isSubmitting,
  });
}

class RescueSuccess extends RescueState {
  final String message;

  RescueSuccess(this.message);
}

class RescueError extends RescueState {
  final String message;

  RescueError(this.message);
}
