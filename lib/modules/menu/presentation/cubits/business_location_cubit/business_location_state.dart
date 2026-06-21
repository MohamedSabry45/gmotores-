import 'package:reservation_workshop/modules/menu/data/models/business_location_model.dart';

abstract class BusinessLocationState {}

class BusinessLocationInitial extends BusinessLocationState {}

class BusinessLocationLoading extends BusinessLocationState {}

class BusinessLocationSuccess extends BusinessLocationState {
  final BusinessLocation location;

  BusinessLocationSuccess(this.location);
}

class BusinessLocationError extends BusinessLocationState {
  final String message;

  BusinessLocationError(this.message);
}
