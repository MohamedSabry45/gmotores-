import '../../domain/entities/vehicle.dart';

abstract class VehiclesState {}

class VehiclesInitial extends VehiclesState {}

class VehiclesLoading extends VehiclesState {}

class VehiclesSuccess extends VehiclesState {
  final List<Vehicle> vehicles;
  final bool isRefreshing;
  final bool isLoadingMore;
  final bool hasMore;

  VehiclesSuccess({
    required this.vehicles,
    required this.isRefreshing,
    required this.isLoadingMore,
    required this.hasMore,
  });
}

class VehiclesError extends VehiclesState {
  final String message;

  VehiclesError(this.message);
}
