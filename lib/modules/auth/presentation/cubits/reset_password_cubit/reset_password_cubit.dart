import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/auth_remote_datasource.dart';

class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {}

class ResetPasswordError extends ResetPasswordState {
  final String message;

  ResetPasswordError(this.message);
}

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());

  static ResetPasswordCubit get(context) =>
      BlocProvider.of<ResetPasswordCubit>(context);

  final AuthRemoteDataSource _remote = AuthRemoteDataSource();

  Future<void> resetPassword({
    required String mobile,
    required String otp,
    required String newPassword,
  }) async {
    if (isClosed) return;
    emit(ResetPasswordLoading());

    final m = mobile.trim();
    final o = otp.trim();
    final p = newPassword.trim();

    if (m.isEmpty || o.isEmpty || p.isEmpty) {
      if (isClosed) return;
      emit(ResetPasswordError('All fields are required'));
      return;
    }

    try {
      await _remote.resetPassword(
        mobile: m,
        otp: o,
        newPassword: p,
      );
      if (isClosed) return;
      emit(ResetPasswordSuccess());
    } catch (e) {
      if (isClosed) return;
      emit(ResetPasswordError(e.toString()));
    }
  }
}
