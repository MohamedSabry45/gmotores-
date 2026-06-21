import '../../domain/entities/vehicle_details.dart';

abstract class VehicleDetailsState {}

class VehicleDetailsInitial extends VehicleDetailsState {}

class VehicleDetailsLoading extends VehicleDetailsState {}

class VehicleDetailsSuccess extends VehicleDetailsState {
  final VehicleDetails details;

  VehicleDetailsSuccess(this.details);
}

class VehicleDetailsError extends VehicleDetailsState {
  final String message;

  VehicleDetailsError(this.message);
}
