import '../../domain/entities/business_location.dart';

abstract class BusinessLocationsState {}

class BusinessLocationsInitial extends BusinessLocationsState {}

class BusinessLocationsLoading extends BusinessLocationsState {}

class BusinessLocationsSuccess extends BusinessLocationsState {
  final List<BusinessLocation> locations;

  BusinessLocationsSuccess(this.locations);
}

class BusinessLocationsError extends BusinessLocationsState {
  final String message;

  BusinessLocationsError(this.message);
}
