abstract class AuthOtpState {}

class AuthOtpInitial extends AuthOtpState {}

class SendOtpLoading extends AuthOtpState {}

class SendOtpSuccess extends AuthOtpState {}

class VerifyOtpLoading extends AuthOtpState {}

class VerifyOtpSuccess extends AuthOtpState {
  VerifyOtpSuccess({required this.isFirstLogin});

  final bool isFirstLogin;
}

class CompleteProfileLoading extends AuthOtpState {}

class CompleteProfileSuccess extends AuthOtpState {}

class AuthOtpError extends AuthOtpState {
  AuthOtpError(this.message);

  final String message;
}
