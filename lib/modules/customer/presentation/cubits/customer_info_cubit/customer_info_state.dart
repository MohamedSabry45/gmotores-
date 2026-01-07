import '../../../domain/entities/customer_info.dart';

abstract class CustomerInfoState {}

class CustomerInfoInitial extends CustomerInfoState {}

class CustomerInfoLoading extends CustomerInfoState {}

class CustomerInfoSuccess extends CustomerInfoState {
  final CustomerInfo info;

  CustomerInfoSuccess(this.info);
}

class CustomerInfoError extends CustomerInfoState {
  final String message;

  CustomerInfoError(this.message);
}
