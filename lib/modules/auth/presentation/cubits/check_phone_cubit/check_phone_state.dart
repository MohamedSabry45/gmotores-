import '../../../domain/entities/check_phone_result.dart';

abstract class CheckPhoneState {}

class CheckPhoneRestoreRequired extends CheckPhoneState {
  final int userId;
  final String message;
  final String mobile;

  CheckPhoneRestoreRequired({
    required this.userId,
    required this.message,
    required this.mobile,
  });
}

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
