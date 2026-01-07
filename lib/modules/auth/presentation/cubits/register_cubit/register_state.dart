import '../../../domain/entities/auth_session.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final AuthSession session;

  RegisterSuccess(this.session);
}

class RegisterError extends RegisterState {
  final String message;

  RegisterError(this.message);
}
