import '../../../domain/entities/check_phone_result.dart';

abstract class CheckPhoneState {}

class CheckPhoneInitial extends CheckPhoneState {}

class CheckPhoneLoading extends CheckPhoneState {}

class CheckPhoneSuccess extends CheckPhoneState {
  final CheckPhoneResult result;
  final String mobile;

  CheckPhoneSuccess({
    required this.result,
    required this.mobile,
  });
}

class CheckPhoneError extends CheckPhoneState {
  final String message;

  CheckPhoneError(this.message);
}
